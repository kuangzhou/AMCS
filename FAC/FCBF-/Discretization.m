function data=Discretization(numData)
[order index]=sort(numData);
data=numData;
trnum=size(numData,1);
minInterval=floor(0.1*trnum); % The number of instances in each interval
count=1; %count the number of interval
i=1;
while i<=trnum
    % assign the count index to the first minInterval data
    j=i;
    if (j+minInterval-1)>=size(numData,1)
        data(index(i:end))=count;
        break
    end
    for i=j:minInterval+j-1
        data(index(i))=count;
    end
    i=i+1;
  
    count=count+1;
end