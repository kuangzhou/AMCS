function targets = TestFun(test_patterns, tree) 
%Classify recursively using a tree 
%  patterns     - Test patterns, (the number of features) * (the number of samples) 
 
indices = 1:size(test_patterns,2); %测试集样本个个数
targets = zeros(1, size(test_patterns,2)); 
 
if (tree.dim == 0) 
    %Reached the end of the tree 
    targets(indices) = tree.child; %如果根节点是叶子节点，把所有样例的类标注为当前节点的类
    return 
end 
 
%This is not the last level of the tree, so: 
%First, find the dimension we are to work on 
dim = tree.dim; %找到划分属性


in	= indices(find(test_patterns(dim,:) <= tree.split_loc)); %样例中小于分割值的属性的索引

targets(in)	= TestFun(test_patterns(:, in), tree.child(1)); 

in	= indices(find(test_patterns(dim,:) > tree.split_loc)); 
    
targets(in)	= TestFun(test_patterns(:,in), tree.child(2)); 


 
