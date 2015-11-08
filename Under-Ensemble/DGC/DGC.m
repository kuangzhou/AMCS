function [I,test_targets, err,prob,Crate]=DGC(tr_data,tr_label,ts_data,ts_label)
tsnum=size(ts_data,1);
trnum=size(tr_data,1);
   U        = unique(ts_label); % class labels
cn= length(U);%number of classes
Distr=zeros(1,cn);
for k=1:cn
    Distr(k)=size(find(tr_label==k),1);
end
coef=trnum*ones(1,cn)./Distr;
F=zeros(tsnum,cn);
gravi=zeros(1,tsnum); %max gravitation of each test sample
test_targets=zeros(tsnum,1); %hypothesis of each test sample given by the classifier

w=ones(1,size(tr_data,2));
clusters=Createclusters(tr_data,tr_label,0.01,cn);

for i=1:tsnum
    %%%Calculate the gravitation between the given exsample and the
    %%%particles of each class

    for k=1:cn
        l(k)=size(clusters.mass{k},2);
        w_dis=zeros(1,l(k));
        for j=1:l(k)
            w_dis(j)=sum((w.*((clusters.cen{k}(j,:)-ts_data(i,:)).^2)));
            F(i,k)=F(i,k)+coef(k)*clusters.mass{k}(j)/w_dis(j);
        end 
    end
    [gravi(i) test_targets(i)]=max(F(i,:));
     prob(i,:)=F(i,:);

end


        %output
   U        = unique(ts_label); % class labels
cn= length(U);%number of classes
% prob=zeros(tsnum,cn);
for i=1:tsnum
    if test_targets(i)==0
        test_targets(i)=randi([1 cn]);
    end
%     prob(i,test_targets(i))=gravi(i);
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
%END
    
    

