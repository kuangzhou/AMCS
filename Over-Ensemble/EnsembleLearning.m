function [Bhypo,hypo,BCrate,Crate,Bacc,acc]=EnsembleLearning(train_data,lab_tr,test_data,lab_ts,gBest,cn)
[trnum,dim]=size(train_data);
[tsnum,dim]=size(test_data);
en_num=10; %the number of base classifiers
   for i=1:cn
    label_class{:,i}=find(lab_ts==i);
    size_class(i)=size(label_class{:,i},1);
   end
   size_class


%计算最佳特征子集的分类效果
fea_tr=[];fea_ts=[];j=1;
for i=1:size(gBest,2)%提取样本子集
    if gBest(i)==1
        fea_tr(:,j)=train_data(:,i);
        fea_ts(:,j)=test_data(:,i);
        j=j+1;
    end
end
% under-sampling and train base classifiers
for i=1:en_num
    [curtrainset,curtrainlab]=oversample(fea_tr,lab_tr,cn);
%     [BI(i,:),Bpredict(:,i), Berr(i),Bprob(:,:,i),BCrate(i,:)]=RBF(curtrainset,curtrainlab,fea_ts,lab_ts);
%    [BI(i,:),Bpredict(:,i), Berr(i),Bprob(:,:,i),BCrate(i,:)]=DGC(curtrainset,curtrainlab,fea_ts,lab_ts);
% [BI(i,:),Bpredict(:,i), Berr(i),Bprob(:,:,i),BCrate(i,:)]=KNN(curtrainset,curtrainlab,fea_ts,lab_ts,5);
[BI(i,:),Bpredict(:,i), Berr(i),Bprob(:,:,i),BCrate(i,:)]=C4_5(curtrainset',curtrainlab',fea_ts',lab_ts,cn);
% [BI(i,:),Bpredict(:,i), Berr(i),Bprob(:,:,i),BCrate(i,:)]=SVM(curtrainset,curtrainlab,fea_ts,lab_ts);
end
for j=1:5
Bhypo(j,:)=ensemblerule(Bprob,cn,j,tsnum);
Bacc(j)=length(find(Bhypo(j,:)'==lab_ts))/tsnum;
end
% 

%计算原数据集的分类效果
gBest=ones(1,size(train_data,2));
fea_tr=[];fea_ts=[];j=1;
for i=1:size(gBest,2)%提取样本子集
    if gBest(i)==1
        fea_tr(:,j)=train_data(:,i);
        fea_ts(:,j)=test_data(:,i);
        j=j+1;
    end
end

for i=1:en_num
    [curtrainset,curtrainlab]=oversample(fea_tr,lab_tr,cn);
%    [I(i,:),predict(:,i), err(i),prob(:,:,i),Crate(i,:)]=RBF(curtrainset,curtrainlab,fea_ts,lab_ts);
    [I(i,:),predict(:,i), err(i),prob(:,:,i),Crate(i,:)]=DGC(curtrainset,curtrainlab,fea_ts,lab_ts);
% [I(i,:),predict(:,i), err(i),prob(:,:,i),Crate(i,:)]=KNN(curtrainset,curtrainlab,fea_ts,lab_ts,5);
% [I(i,:),predict(:,i), err(i),prob(:,:,i),Crate(i,:)]=C4_5(curtrainset',curtrainlab',fea_ts',lab_ts,cn);
%  [I(i,:),predict(:,i), err(i),prob(:,:,i),Crate(i,:)]=SVM(curtrainset,curtrainlab,fea_ts,lab_ts);


end
for j=1:5
hypo(j,:)=ensemblerule(prob,cn,j,tsnum);
acc(j)=length(find(hypo(j,:)'==lab_ts))/tsnum;
end






