function [I,predict, err,prob,Crate]=SVM(tr_data,tr_label,ts_data,ts_label)
class=unique(ts_label);
cn=length(class);
tsnum=size(ts_label,1);
svm = svmtrain(tr_label,tr_data,'-t 2 -b 1');
[predict,acc,prob] = svmpredict(ts_label,ts_data,svm,'-b 1');
count=zeros(1,cn);
err=length(find(predict~=ts_label))/length(ts_label);
for i=1:tsnum
    if(predict(i)==ts_label(i))
        I(i)=0;
    else
        I(i)=1;
    end
end
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