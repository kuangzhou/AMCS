function data=Supervised_Discretization(numData,targets)
[order index]=sort(numData);
data=numData;
cn=length(unique(targets));
minInterval=6; % The number of instances in each interval
count=1; %count the number of interval
i=1;
while i<=size(numData,1)
    % assign the count index to the first minInterval data
    j=i;
    if (j+minInterval-1)>=size(numData,1)
        data(index(i:end))=count;
        break
    end
    for i=j:minInterval+j-1
        data(index(i))=count;
        class(i-j+1)=targets(index(i));
    end
    % find the majority class label seen until then in this interval
    for c=1:cn
        Class_size(c)=length(find(targets(class==c)));
    end
    [max_size,max_label]=max(Class_size);
    i=i+1;
    while i<=size(numData,1) & targets(index(i))==max_label 
        data(index(i))=count;
        i=i+1;
    end
    count=count+1;
end