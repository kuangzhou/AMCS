function [I,hypo,rate,Kscore,Crate] = KNN(Train_data,Train_label,Test_data,Test_label,k,Distance_mark);
% K-Nearest-Neighbor classifier(K-NN classifier)
%Input:
%     Train_data,Test_data are training data set and test data
%     set,respectively.(Each row is a data point)
%     Train_label,Test_label are column vectors.They are labels of training
%     data set and test data set,respectively.
%     k is the number of nearest neighbors
%     Distance_mark           :   ['Euclidean', 'L2'| 'L1' | 'Cos']
%     'Cos' represents Cosine distance.
%Output:
%     rate:Accuracy of K-NN classifier

if nargin < 5
    error('Not enought arguments!');
elseif nargin < 6
    Distance_mark='L2';
end
[n dim]    = size(Test_data);% number of test data set
train_num  = size(Train_data,1);% number of training data set
% Normalize each feature to have zero mean and unit variance.
% If you need the following four rows,you can uncomment them.
M        = mean(Train_data); % mean & std of the training data set
S        = std(Train_data);
% Train_data = (Train_data - ones(train_num, 1) * M)./(ones(train_num, 1) * S); % normalize training data set
% Test_data            = (Test_data-ones(n,1)*M)./(ones(n,1)*S); % normalize data
U        = unique(Test_label); % class labels
nclasses = length(U);%number of classes
Result  = zeros(n, 1);
Count   = zeros(nclasses, 1);
score=[];
dist=zeros(train_num,1);
for i = 1:n
    % compute distances between test data and all training data and
    % sort them
    test=Test_data(i,:);
    for j=1:train_num
        train=Train_data(j,:);V=test-train;
        switch Distance_mark
            case {'Euclidean', 'L2'}
                dist(j,1)=norm(V,2); % Euclead (L2) distance
            case 'L1'
                dist(j,1)=norm(V,1); % L1 distance
            case 'Cos'
                dist(j,1)=acos(test*train'/(norm(test,2)*norm(train,2)));     % cos distance
            otherwise
                dist(j,1)=norm(V,2); % Default distance
        end
    end
    [Dummy Inds] = sort(dist);
    % compute the class labels of the k nearest samples
    Count(:) = 0;
    for j = 1:k
        ind        = find(Train_label(Inds(j)) == U); %find the label of the j'th nearest neighbors
        Count(ind) = Count(ind) + 1;
    end% Count:the number of each class of k nearest neighbors
     for c=1:nclasses %Count the score of each class
   score(i,c)=Count(c,:)/k;
    end
    % determine the class of the data sample
    [dummy ind] = max(Count);
    Result(i)   = U(ind);
end
for i=1:n
    if(Result(i)==Test_label(i))
        I(i)=0;
    else
        I(i)=1;
    end
end

hypo=Result;
correctnumbers=length(find(Result==Test_label));

rate=1-correctnumbers/n;


%Calculate error rate for mojority class and minority class
max_count=0;
min_count=0;
count=zeros(1,nclasses);
for i=1:nclasses
    label_class{:,i}=find(Test_label==i);
    size_class(i)=size(label_class{:,i},1);
    for j=1:size_class(i)
    if hypo(label_class{i}(j,:))==Test_label(label_class{i}(j,:))
         count(i)=count(i)+1;
    end
    end
end

Crate=count./size_class;
Kscore=score;
