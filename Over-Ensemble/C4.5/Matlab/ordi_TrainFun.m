function tree = ordi_TrainFun(patterns, targets) 
%Build a tree recursively 
%  patterns     - Train patterns, (the number of features) * (the numberofsamples)行是属性，列是样本个数  
%  targets	    - Train targets, 1*(the number of samples) 决策类向量
%  ebs     - 停止划分，如果当前节点的所有属性的最大有序互信息小于的阈值 
%ebs=input('Please input the value of ebs');
%  orig_traindata      =load('[002]breast(0-1).txt');
%  rem_traindata       =orig_traindata(:,1:end-1);
%  patterns      =rem_traindata'; % the features of the ordinal train data.
%  targets       =orig_traindata(:,end)'; % the targets of the ordinal train data.
ebs=-1;
% patterns=[1 2 3 1;0.1 0.2 0.3 0.1;10 12 14 12 ];
% targets=[1 2 1 3];
[Ni, L]    					= size(patterns);%设A是一个矩阵，则size(A)直接显示出A的大小，输出：ans=3 4;s=size(A)返回一个行向量s,s的第一个元素是矩阵的行数，
                                              %第二个元素是矩阵的列数，输出：s=3 4;[r,c]=size(A),将矩阵A的行数返回到第一个输出变量r,将矩阵的列数返回到第二个输出变量c,输出：r=3,c=4 
Uc         					= unique(targets); %用来把一个数组中的重复元素去掉
tree.dim					= 0; %当前节点所选的划分属性
tree.split_loc				= inf;%无穷大 

if isempty(patterns) %判断矩阵是否为空
    return;          % return表示退出if语句
end 
 
%停止条件 ： 样例个数是一个 或者分类相同
if (( L == 1) | (length(Uc) == 1)) 
    tempvec1=zeros(1,length(Uc)); %创建一个全零矩阵
    for ii=1:length(Uc) 
        tempvec1(ii)=length(find(targets==Uc(ii))); %find函数用于返回所需要元素的所在位置
        %（位置的判定：在矩阵中，第一列开始，自上而下，依次为1,2,3……然后再从第二列，第三列依次往后数）。
        %find(A)返回矩阵A中非零元素所在位置，如：A=[1 0 4 -3 0 0 0 8 6];X=find(A),X=1 3 4 8 9.find(A>5)返回矩阵中大于5的元素所在位置，ans=8 9.
    end %矩阵tempvec1中的元素表示当前节点处的每个类的种类中所包含的样本的个数。
    [m, largest] = max(tempvec1); % m 表示单行矩阵tempvec1中元素的最大值，largest表示最大元素所在的列号数。
                                  %例如设Uc=[class1,class2,class3];tempvec1=[4,10,30]
    tree.child	 = Uc(largest); % 将包含最多元素的类别定义为该叶节点的类别。
    disp('This is a leaf node. Its lable is: ');
    disp(tree.child);
   return;
end % 此if-end语句的作用是判断出某节点是否为叶节点，并给出该叶节点所属的类别。


P=zeros(L,4);
delta_Ib    = zeros(1, Ni); %新定义Ni个属性
split_loc	= ones(1, Ni)*inf; %各个属性的分割点
I=zeros(1,L);
for i=1:Ni
    data	= patterns(i,:);
    for j=1:L
       indices3=find(patterns(i,:)<=patterns(i,j));
       data(indices3)=1;
       indices4=find(patterns(i,:)>patterns(i,j));
       data(indices4)=2;
       for k=1:L
          P(k,1) =length(find(data>=data(k)));
          P(k,2)=length(find(targets>=targets(k)));
          P(k,3)=length(find(data>=data(k) & targets>=targets(k)));
          P(k,4)=log2(P(j,1)*P(j,2))/(L*P(j,3));
          %I(j) =-sum(log(P(j,4)/log(2)))/L;
       end
       M=sum(P);
       mm=M(4);
       I(j)=-mm/L;
    end 
     [delta_Ib(i), s] = max(I); %求出单属性的最大有序互信息及分裂位置
     split_loc(i) = patterns(i,s); %<=threshold vs. >threshold 分裂位置的属性的值
end 
[m, dim]    = max(delta_Ib); %求出最大的有序互信息，及是第几个属性

%停止的条件最大有序互信息小于阈值
if(m<ebs)
   tempvec1=zeros(1,length(Uc)); 
    for ii=1:length(Uc) 
        tempvec1(ii)=length(find(targets==Uc(ii))); 
    end 
    [m, largest] = max(tempvec1); 
    tree.child	 = Uc(largest); % 将包含最多元素的类别定义为该叶节点的类别。
    disp('This is a ebs node. Its lable is: ');
    disp(tree.child);
    return;
end     

disp(dim);
disp(split_loc(dim));
    tree.dim    = dim; %第几个属性作为划分属性
    tree.split_loc	= split_loc(dim); 
    indices1		   	= find(patterns(dim,:) <= split_loc(dim)); 
    indices2	   		= find(patterns(dim,:) >split_loc(dim)); 
    tree.child(1)	= ordi_TrainFun(patterns(:,indices1), targets(:,indices1)); 
    tree.child(2)	= ordi_TrainFun(patterns(:,indices2), targets(:,indices2)); 
 
