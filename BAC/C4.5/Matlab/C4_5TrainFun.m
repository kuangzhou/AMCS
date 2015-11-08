function tree = C4_5TrainFun(patterns, targets, inc_node, discrete_dim) 
%Build a tree recursively 
%  patterns     - Train patterns, (the number of features) * (the number of samples) 
%  targets	    - Train targets, 1*(the number of samples) 
%  inc_node     - Stop building a subtree if its total samples are less than inc_node 
%  discrete_dim - 1*(the number of features). 0 entries for continuous features  
 
[Ni, L]    					= size(patterns);%��A��һ��������size(A)ֱ����ʾ��A�Ĵ�С�������ans=3 4;s=size(A)����һ��������s,s�ĵ�һ��Ԫ���Ǿ����������
                                              %�ڶ���Ԫ���Ǿ���������������s=3 4;[r,c]=size(A),������A���������ص���һ���������r,��������������ص��ڶ����������c,�����r=3,c=4 
Uc         					= unique(targets); 
tree.dim					= 0; 
tree.split_loc				= inf;%����� 
 
if isempty(patterns) %�жϾ����Ƿ�Ϊ�գ�Ϊ�գ�����ֵΪ1���ǿշ���ֵΪ0
    return;          % return��ʾ�˳�if���
end 
 
%When to stop: If the number of examples is smaller than inc_node, or is 1, or the category is unique 
if ((inc_node > L) | (L == 1) | (length(Uc) == 1)) 
    tempvec1=zeros(1,length(Uc)); 
    for ii=1:length(Uc) 
        tempvec1(ii)=length(find(targets==Uc(ii))); %find�������ڷ�������ҪԪ�ص�����λ��
        %��λ�õ��ж����ھ����У���һ�п�ʼ�����϶��£�����Ϊ1,2,3����Ȼ���ٴӵڶ��У���������������������
        %find(A)���ؾ���A�з���Ԫ������λ�ã��磺A=[1 0 4 -3 0 0 0 8 6];X=find(A),X=1 3 4 8 9.find(A>5)���ؾ����д���5��Ԫ������λ�ã�ans=8 9.
    end %����tempvec1�е�Ԫ�ر�ʾ��ǰ�ڵ㴦��ÿ������������������������ĸ�����
    [m, largest] = max(tempvec1); % m ��ʾ���о���tempvec1��Ԫ�ص����ֵ��largest��ʾ���Ԫ�����ڵ��к�����
                                  %������Uc=[class1,class2,class3];tempvec1=[4,10,30]
    tree.child	 = Uc(largest); % ���������Ԫ�ص������Ϊ��Ҷ�ڵ�����
    return 
end % ��if-end�����������жϳ�ĳ�ڵ��Ƿ�ΪҶ�ڵ㣬��������Ҷ�ڵ����������
 
%Compute the node's entropy 
for i = 1:length(Uc), 
    Pnode(i) = length(find(targets == Uc(i))) / L; 
end  % Pnode(i)�е�ÿ��Ԫ�ر�ʾ���ڵ㴦��������������ռ�������İٷ���
Inode = -sum(Pnode.*log(Pnode)/log(2)); % ������ڵ㴦����������Ϣ��
 
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
        end  % ����ÿһ������ɢ���Ե��������ԣ�������һ������P�����е�Ԫ��P(j,k)��ʾ���ڵ�j������Ҹ��������Ե�ֵΪ��k������ֵ�������ĸ�����
        Pk          = sum(P); % sum(P)��ʾ�Ծ���P����������ӣ���ÿ�еĺͣ�����������������ʱP��һ��һ��k�еľ���ÿ��Ԫ�ر�ʾ��ǰ�ڵ㴦
                              %���������Ե�ֵΪ��k������ֵ���������ܸ�����
       
        P           = P./(eps+repmat(Pk,size(P,1),1));  % repmat���������ã�����һ�������������������ظ�ʱʹ�ã��书������A�����ݶѵ��ڣ�MxN���ľ���B�У�
                                                        % B����Ĵ�С��MxN��A��������ݾ��������磺
                                                        %>>B=repmat( [1 2;3 4],2,3)
                                                        %  B = 

                                                        %     1     2     1     2     1     2

                                                        %     3     4     3     4     3     4

                                                        %     1     2     1     2     1     2

                                                        %     3     4     3     4     3     4

                                                        % size(P,1)����䷵�ص��Ǿ���P��������
                                                      
                                                       



        Pk          = Pk/sum(Pk); 
        info        = sum(-P.*log(eps+P)/log(2)); 
        delta_Ib(i) = (Inode-sum(Pk.*info))/-sum(Pk.*log(eps+Pk)/log(2)); 
                                                                          
    else 
        %This is a continuous pattern 
        P	= zeros(length(Uc), 2); 
 
        %Sort the patterns 
        [sorted_data, indices] = sort(data); %B=sort(A) ��һά���ά���������������,����������������,��AΪ��άʱ,������ÿһ�н�������. 

                                             %eg: A=[1,5,3],��sort(A)=[1,3,5]  A=[1,5,3;2,4,1],��sort(A)=[1,4,1;2,5,3]
                                             % indices��������Ԫ��������ǰ�ھ���data�е�λ��
                                             % sort(data)���������Ե�����ֵ������������
        sorted_targets = targets(indices); 
         
        %Calculate the information for each possible split 
        I	= zeros(1, L-1); % L��ʾ��������������L-1�Ǹ��ĸ�����
        for j = 1:L-1, % ����ÿһ��������
            for k =1:length(Uc), 
                P(k,1) = length(find(sorted_targets(1:j) 	 == Uc(k))); 
                P(k,2) = length(find(sorted_targets(j+1:end) == Uc(k))); 
            end   % ����ÿһ����㣬��������һ������P�����ж��ٸ����P���м��С�P��2�С����ڵ�j����㣨��Ӧ����ΪP����P(k,1)��ʾ
                  % ǰj������о�������ΪUc(k)�������ĸ�����P(k,2)��ʾ��j+1��L-1������о�������ΪUc(k)����
                  % ���ĸ�����
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