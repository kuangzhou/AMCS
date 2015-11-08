function [I,test_targets, err,prob,Crate] =UseC45(train_patterns,train_targets,test_patterns,ts_label,cn)

%================================================C4.5 decision tree 
% Inputs: 
% 	training_patterns   - Train patterns, (the number of features) * (the number of samples) 
%	training_targets	- Train targets, 1*(the number of samples) 
%   test_patterns       - Test  patterns, (the number of features) * (the number of samples) 
%	Fra_inc_node        - Fraction of incorrectly assigned samples at a 
%	                     node.  To avoid overfitting.  
% Outputs 
%	test_targets        - Predicted targets, 1*(the number of samples) 
 
Fra_inc_node=0.01; 
 trnum=size(train_patterns,2);
 tsnum=size(test_patterns,2);
%NOTE: In this implementation it is assumed that a pattern vector with fewer than 10 unique values (the parameter Nu) 
%is discrete, and will be treated as such. Other vectors will be treated as continuous 
[Ni, M]		= size(train_patterns); 
inc_node    = round(Fra_inc_node*M); %Stop building a subtree if the total samples are less than inc_node. 
Nu          =round(0.1 *trnum); 
 
%Find which of the input patterns are discrete, and discretisize the corresponding 
%dimension on the test patterns 
discrete_dim = zeros(1,Ni); 
for i = 1:Ni, 
    Ub = unique(train_patterns(i,:)); 
    Nb = length(Ub); 
    if ( Nb <= Nu)
        %This is a discrete pattern 
        discrete_dim(i)	= Nb; 
%         dist            = abs(ones(Nb ,1)*test_patterns(i,:) - Ub'*ones(1, size(test_patterns,2))); 
%         [m, in]         = min(dist); 
%         test_patterns(i,:)  = Ub(in); 
    end 
end 

%=======================Build the tree recursively 
%disp('Building a tree...') 
tree            = C4_5TrainFun(train_patterns, train_targets, inc_node, discrete_dim); 
 
%======================Classify test samples 
%disp('Classify test samples using the tree...') 
test_targets    =  C4_5TestFun(test_patterns, tree, discrete_dim);

%output
prob=zeros(tsnum,cn);
for i=1:tsnum
    prob(i,test_targets(i))=1;
    if(test_targets(i)==ts_label(i))
        I(i)=0;
    else
        I(i)=1;
    end
end
err=length(find(test_targets~=ts_label))/tsnum;

%Calculate error rate for mojority class and minority class
max_count=0;
min_count=0;
count=zeros(1,cn);
for i=1:cn
    label_class{:,i}=find(ts_label==i);
    size_class(i)=size(label_class{:,i},1);
    for j=1:size_class(i)
    if test_targets(label_class{i}(j,:))==ts_label(label_class{i}(j,:))
         count(i)=count(i)+1;
    end
    end
end

Crate=count./size_class;
