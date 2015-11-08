function tree = C4_5TrainFun(patterns, targets, inc_node, discrete_dim) 
%Build a tree recursively 
%  patterns     - Train patterns, (the number of features) * (the number of samples) 
%  targets	    - Train targets, 1*(the number of samples) 
%  inc_node     - Stop building a subtree if its total samples are less than inc_node 
%  discrete_dim - 1*(the number of features). 0 entries for continuous features  
 
[Ni, L]    					= size(patterns);%设A是一个矩阵，则size(A)直接显示出A的大小，输出：ans=3 4;s=size(A)返回一个行向量s,s的第一个元素是矩阵的行数，
                                              %第二个元素是矩阵的列数，输出：s=3 4;[r,c]=size(A),将矩阵A的行数返回到第一个输出变量r,将矩阵的列数返回到第二个输出变量c,输出：r=3,c=4 
Uc         					= unique(targets); 
tree.dim					= 0; 
tree.split_loc				= inf;%无穷大 
 
if isempty(patterns) %判断矩阵是否为空，为空，返回值为1，非空返回值为0
    return;          % return表示退出if语句
end 
 
%When to stop: If the number of examples is smaller than inc_node, or is 1, or the category is unique 
if ((inc_node > L) | (L == 1) | (length(Uc) == 1)) 
    tempvec1=zeros(1,length(Uc)); 
    for ii=1:length(Uc) 
        tempvec1(ii)=length(find(targets==Uc(ii))); %find函数用于返回所需要元素的所在位置
        %（位置的判定：在矩阵中，第一列开始，自上而下，依次为1,2,3……然后再从第二列，第三列依次往后数）。
        %find(A)返回矩阵A中非零元素所在位置，如：A=[1 0 4 -3 0 0 0 8 6];X=find(A),X=1 3 4 8 9.find(A>5)返回矩阵中大于5的元素所在位置，ans=8 9.
    end %矩阵tempvec1中的元素表示当前节点处的每个类的种类中所包含的样本的个数。
    [m, largest] = max(tempvec1); % m 表示单行矩阵tempvec1中元素的最大值，largest表示最大元素所在的列号数。
                                  %例如设Uc=[class1,class2,class3];tempvec1=[4,10,30]
    tree.child	 = Uc(largest); % 将包含最多元素的类别定义为该叶节点的类别。
    return 
end % 此if-end语句的作用是判断出某节点是否为叶节点，并给出该叶节点所属的类别。
 
%Compute the node's entropy 
for i = 1:length(Uc), 
    Pnode(i) = length(find(targets == Uc(i))) / L; 
end  % Pnode(i)中的每个元素表示各节点处各种类别的样例数占总样例的百分数
Inode = -sum(Pnode.*log(Pnode)/log(2)); % 计算根节点处样例集的信息熵
 
%For each dimension, comput e the gain ratio impurity 
%This is done separately for discrete and continuous patterns 
delta_Ib    = zeros(1, Ni); 
split_loc	= ones(1, Ni)*inf; 
 
for i = 1:Ni, 
    data	= patterns(i,:); 
    Ud      = unique(data); 
    Nbins	= length(Ud); 
    if (discrete_dim(i)), 
        %This is a discrete pattern 
        P	= zeros(length(Uc), Nbins); 
        for j = 1:length(Uc), 
            for k = 1:Nbins, 
                indices 	= find((targets == Uc(j)) & (patterns(i,:) == Ud(k))); 
                P(j,k) 	= length(indices); 
            end 
        end  % 对于每一个是离散属性的条件属性，都生成一个矩阵P，它中的元素P(j,k)表示属于第j个类别且该条件属性的值为第k个独特值的样例的个数。
        Pk          = sum(P); % sum(P)表示对矩阵P进行竖向相加，求每列的和，结果是行向量。则此时P是一个一行k列的矩阵，每个元素表示当前节点处
                              %该条件属性的值为第k个独特值的样例的总个数。
       
        P           = P./(eps+repmat(Pk,size(P,1),1));  % repmat函数的作用：这是一个处理大矩阵且内容有重复时使用，其功能是以A的内容堆叠在（MxN）的矩阵B中，
                                                        % B矩阵的大小由MxN及A矩阵的内容决定，例如：
                                                        %>>B=repmat( [1 2;3 4],2,3)
                                                        %  B = 

                                                        %     1     2     1     2     1     2

                                                        %     3     4     3     4     3     4

                                                        %     1     2     1     2     1     2

                                                        %     3     4     3     4     3     4

                                                        % size(P,1)该语句返回的是矩阵P的行数。
                                                      
                                                       



        Pk          = Pk/sum(Pk); 
        info        = sum(-P.*log(eps+P)/log(2)); 
        delta_Ib(i) = (Inode-sum(Pk.*info))/-sum(Pk.*log(eps+Pk)/log(2)); 
                                                                          
    else 
        %This is a continuous pattern 
        P	= zeros(length(Uc), 2); 
 
        %Sort the patterns 
        [sorted_data, indices] = sort(data); %B=sort(A) 对一维或二维数组进行升序排序,并返回排序后的数组,当A为二维时,对数组每一列进行排序. 

                                             %eg: A=[1,5,3],则sort(A)=[1,3,5]  A=[1,5,3;2,4,1],则sort(A)=[1,4,1;2,5,3]
                                             % indices保留的是元素在排序前在矩阵data中的位置
                                             % sort(data)对连续属性的属性值进行升序排序。
        sorted_targets = targets(indices); 
         
        %Calculate the information for each possible split 
        I	= zeros(1, L-1); % L表示的是样本个数，L-1是割点的个数。
        for j = 1:L-1, % 对于每一个割点而言
            for k =1:length(Uc), 
                P(k,1) = length(find(sorted_targets(1:j) 	 == Uc(k))); 
                P(k,2) = length(find(sorted_targets(j+1:end) == Uc(k))); 
            end   % 对于每一个割点，都会生成一个矩阵P，共有多少个类别，P就有几行。P有2列。对于第j个割点（对应矩阵为P），P(k,1)表示
                  % 前j个割点中决策属性为Uc(k)的样例的个数。P(k,2)表示后j+1到L-1个割点中决策属性为Uc(k)的样
                  % 例的个数。
            Pk      = sum(P); 
            
            P       = P./(eps+repmat(Pk,size(P,1),1)); 
            
            Pk      = Pk/sum(Pk); 
            info	= sum(-P.*log(eps+P)/log(2));  
            I(j)	= (Inode-sum(Pk.*info))/-sum(Pk.*log(eps+Pk)/log(2));  
        end 
        [delta_Ib(i), s] = max(I); 
        split_loc(i) = sorted_data(s); %<=threshold vs. >threshold 
    end 
end 
 
%Find the dimension maximizing delta_Ib 
[m, dim]    = max(delta_Ib); 
dims        = 1:Ni; 
tree.dim    = dim; 
 
dims(dim)=[]; %The remaining attributes 
 
%Split along the 'dim' dimension 
Nf		= unique(patterns(dim,:)); 
Nbins	= length(Nf); 
if (discrete_dim(dim)), 
    %Discrete pattern 
    for i = 1:Nbins, 
        indices    	= find(patterns(dim, :) == Nf(i)); 
        if isempty(dims) 
            tempvec1=zeros(1,length(Uc)); 
            for ii=1:length(Uc) 
                tempvec1(ii)=length(find(targets(indices)==Uc(ii))); 
            end 
            [m, largest] 	= max(tempvec1); 
            tree.child(i) 	= Uc(largest); 
        else 
            tree.child(i)	= C4_5TrainFun(patterns(dims, indices), targets(indices), inc_node, discrete_dim(dims)); 
        end 
    end 
else 
    %Continuous pattern 
    tree.split_loc	= split_loc(dim); 
    indices1		   	= find(patterns(dim,:) <= split_loc(dim)); 
    indices2	   		= find(patterns(dim,:) > split_loc(dim)); 
    if isempty(dims) 
        tempvec1=zeros(1,length(Uc)); 
        for ii=1:length(Uc) 
            tempvec1(ii)=length(find(targets(indices1)==Uc(ii))); 
        end 
        [m, largest] 	= max(tempvec1); 
        tree.child(1) 	= Uc(largest); 
        tempvec1=zeros(1,length(Uc)); 
        for ii=1:length(Uc) 
            tempvec1(ii)=length(find(targets(indices2)==Uc(ii))); 
        end 
        [m, largest] 	= max(tempvec1); 
        tree.child(2) 	= Uc(largest); 
    else if ~(isempty(indices1) | isempty(indices2))
        
        tree.child(1)	= C4_5TrainFun(patterns(dims, indices1), targets(indices1), inc_node, discrete_dim(dims)); 
        tree.child(2)	= C4_5TrainFun(patterns(dims, indices2), targets(indices2), inc_node, discrete_dim(dims)); 
        else
        H				= hist(targets, length(Uc));
        [m, largest] 	= max(H);
        tree.child	 	= Uc(largest);
        tree.dim                = 0;
        end
    end 
end