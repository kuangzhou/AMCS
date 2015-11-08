function targets = TestFun(test_patterns, tree) 
%Classify recursively using a tree 
%  patterns     - Test patterns, (the number of features) * (the number of samples) 
 
indices = 1:size(test_patterns,2); %���Լ�����������
targets = zeros(1, size(test_patterns,2)); 
 
if (tree.dim == 0) 
    %Reached the end of the tree 
    targets(indices) = tree.child; %������ڵ���Ҷ�ӽڵ㣬���������������עΪ��ǰ�ڵ����
    return 
end 
 
%This is not the last level of the tree, so: 
%First, find the dimension we are to work on 
dim = tree.dim; %�ҵ���������


in	= indices(find(test_patterns(dim,:) <= tree.split_loc)); %������С�ڷָ�ֵ�����Ե�����

targets(in)	= TestFun(test_patterns(:, in), tree.child(1)); 

in	= indices(find(test_patterns(dim,:) > tree.split_loc)); 
    
targets(in)	= TestFun(test_patterns(:,in), tree.child(2)); 


 
