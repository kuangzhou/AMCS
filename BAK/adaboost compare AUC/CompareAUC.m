function [BAhypo,acc,ada_area1]=CompareAUC(train_data,lab_tr,test_data,lab_ts,gBest)
 iterationNum=10;
   U        = unique(lab_tr); % class labels
cn= length(U);%number of classes

%extract best feature set
fea_tr=[];fea_ts=[];j=1;
for i=1:size(gBest,2)
    if gBest(i)==1
        fea_tr(:,j)=train_data(:,i);
        fea_ts(:,j)=test_data(:,i);
        j=j+1;
    end
end

% 
[adatrerr1, adatserr1,w,Ascore_ts1,BAhypo,adatsrate1] = adaboostM12('nearest',fea_tr, lab_tr, fea_ts, lab_ts, iterationNum,cn);
acc=1-adatserr1

[Xa1,Ya1,ada_area1,ada_AUC1]=aucplot(lab_ts,Ascore_ts1,cn);
