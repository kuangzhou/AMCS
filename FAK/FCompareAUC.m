function [BKhypo,BAhypo]=FCompareAUC(train_data,lab_tr,test_data,lab_ts,gBest)
 iterationNum=10;
   U        = unique(lab_tr); % class labels
cn= length(U);%number of classes

%������������Ӽ��ķ���Ч��
fea_tr=[];fea_ts=[];j=1;
for i=1:size(gBest,2)%��ȡ�����Ӽ�
    if gBest(i)==1
        fea_tr(:,j)=train_data(:,i);
        fea_ts(:,j)=test_data(:,i);
        j=j+1;
    end
end


[I,BKhypo,tserr1,Kscore_ts1,Ftsrate1]=KNN(fea_tr,lab_tr,fea_ts,lab_ts,5);

% 
[adatrerr1, adatserr1,w,Ascore_ts1,BAhypo,Fadatsrate1] = adaboostM12('nearest',fea_tr, lab_tr, fea_ts, lab_ts, iterationNum,cn);
Ftsrate1
Fadatsrate1

[Xa1,Ya1,ada_area1,ada_AUC1]=aucplot(lab_ts,Ascore_ts1,cn);
fprintf('F-ada-KNN��AUCarea:\n');
ada_area1
[Xk1,Yk1,knn_area1,knn_AUC1]=aucplot(lab_ts,Kscore_ts1,cn);
fprintf('F-KNN(FS)��AUCarea:')
knn_area1