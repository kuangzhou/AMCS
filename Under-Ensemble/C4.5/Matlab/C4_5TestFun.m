function targets = C4_5TestFun(patterns, tree, discrete_dim) 
%Classify recursively using a tree 
%  patterns     - Test patterns, (the number of features) * (the number of samples) 
 
indices = 1:size(patterns,2); 
targets = zeros(1, size(patterns,2)); 
 
if (tree.dim == 0) 
    %Reached the end of the tree 
    targets(indices) = tree.child; 
    return 
end 
 
%This is not the last level of the tree, so: 
%First, find the dimension we are to work on 
dim = tree.dim; 
dims= 1:size(patterns,1); 
dims(dim)=[]; %ssl 
 
%And classify according to it 
if (discrete_dim(dim) == 0) 
    %Continuous pattern 
    in				= indices(find(patterns(dim, indices) <= tree.split_loc)); 
    if isempty(dims) 
        targets(in)=tree.child(1); 
    else 
        targets(in)	= C4_5TestFun(patterns(dims, in), tree.child(1), discrete_dim(dims)); 
    end 
    in				= indices(find(patterns(dim, indices) >  tree.split_loc)); 
    if isempty(dims) 
        targets(in)=tree.child(2); 
    else 
        tmp	= C4_5TestFun(patterns(dims,in), tree.child(2), discrete_dim(dims));
        if isempty(tmp)
            targets(in)=randi([1 cn]);
        else
            targets(in)=tmp(1);
        end
    end 
else 
    %Discrete pattern 
    Uf				= unique(patterns(dim,:))
    for i = 1:length(Uf) 
        in   	   = indices(find(patterns(dim, indices) == Uf(i))); 
        if isempty(dims) 
            tree.child
            targets(in)=tree.child(i); 
        else             
            tmp1	=C4_5TestFun(patterns(dims, in), tree.child(i), discrete_dim(dims)); 
                    if isempty(tmp1)
            targets(in)=randi([1 cn]);
        else
            targets(in)=tmp1(1);
        end
        end 
    end 
end 
 
%END use_tree