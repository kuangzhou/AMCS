function [ada_area1,BAhypo]=FCompareAUC(train_data,lab_tr,test_data,lab_ts,gBest)
 iterationNum=10;
   U        = unique(lab_tr); % class labels
cn= length(U);%number of classes

%计算最佳特征子集的分类效果
fea_tr=[];fea_ts=[];j=1;
for i=1:size(gBest,2)%提取样本子集
    if gBest(i)==1
        fea_tr(:,j)=train_data(:,i);
        fea_ts(:,j)=test_data(:,i);
        j=j+1;
    end
end

% 
[adatrerr1, adatserr1,w,Ascore_ts1,BAhypo,Fadatsrate1] = adaboostM12('nearest',fea_tr, lab_tr, fea_ts, lab_ts, iterationNum,cn);

[Xa1,Ya1,ada_area1,ada_AUC1]=aucplot(lab_ts,Ascore_ts1,cn);
