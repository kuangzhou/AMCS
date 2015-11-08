function [I,predict, err,prob,Crate]=RBF(tr_data,tr_label,ts_data,ts_label)
% A RBF neural network classification algorithm based on NN-toolbox
% predict    - The output consisit the predicting label 
% prob       - probability matrix of size tsnum*cn, each element of prob denotes the probability of RBF-NN to assign a example to a class.
class=unique(ts_label);
cn=length(class);
tsnum=size(ts_data,1);
prob=zeros(tsnum,cn);
bi_prob=zeros(tsnum,1);% store the confidence of binary classification results
for i=1:cn
    label=tr_label;
    % take ith class as negtive(-1) and the rest as positive(+1) 
    if i==1
        label(find(label==i),:)=-1;
        label(find(label~=-1),:)=1;    
    else
        label(find(label~=i),:)=1;
        label(find(label==i),:)=-1;
    end
    net=newgrnn(tr_data',label',0.25); %training a RBF network
    Y=(sim(net,ts_data'))'; % classifying test examples (column vector)
%     predict(find(Y<0),:)=i;

%     prob(find(Y<0),i)=1;

    for j=1:tsnum
        if  abs(Y(j))<=1
            bi_prob(j)=abs(Y(j));
        elseif abs(Y(j))>1
            bi_prob(j)=1/abs(Y(j));
        end
        prob(find(Y<0),i)=bi_prob(find(Y<0));
        prob(find(Y>0),i)=1-bi_prob(find(Y>0));
    end
end
prob=prob./repmat(sum(prob,2),1,cn);
[maxprob,predict]=max(prob,[],2);
for i=1:tsnum
    if(predict(i)==ts_label(i))
        I(i)=0;
    else
        I(i)=1;
    end
end
err=length(find(predict~=ts_label))/tsnum;

%Calculate error rate for mojority class and minority class
max_count=0;
min_count=0;
count=zeros(1,cn);
for i=1:cn

    label_class{:,i}=find(ts_label==i);
    size_class(i)=size(label_class{:,i},1);
    for j=1:size_class(i)
    if predict(label_class{i}(j,:))==ts_label(label_class{i}(j,:))
         count(i)=count(i)+1;
    end
    end
end

Crate=count./size_class;
% 
% [max_size,max_class]=max(size_class);
% [min_size,min_class]=min(size_class);
% % for i=1:max_size
%     if predict(label_class{max_class}(i))==ts_label(label_class{max_class}(i))
%         max_count=max_count+1;
%     end
% end
% maxrate=1-(max_count/size_class(max_class));
% 
% for i=1:min_size
%     if predict(label_class{max_class}(i))==ts_label(label_class{max_class}(i))
%         min_count=min_count+1;
%     end
% end
% minrate=1-(min_count/size_class(min_class));


    

