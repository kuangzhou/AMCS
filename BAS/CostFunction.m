function [fitness]=CostFunction(Position,lab_tr,lab_ts,train_data,test_data)
j=1;fea_tr=[];fea_ts=[];

for i=1:size(Position,2)%提取样本子集
    if Position(:,i)==1
        fea_tr(:,j)=train_data(:,i);
        fea_ts(:,j)=test_data(:,i);
        j=j+1;
    end
end
U        = unique(lab_tr); % class labels
cn= length(U);%number of classes
 iterationNum=30;
% [I,hypo,trerr,Kscore_tr]=KNN1(fea_tr,lab_tr,fea_tr, lab_tr,5,'Euclidean');
% trerr = repmat(trerr, 1, iterationNum);
% [I,hypo,tserr,Kscore_ts]=KNN1(fea_tr,lab_tr,fea_ts,lab_ts,5,'Euclidean');
[I,hypo,tserr,Kscore_ts]=SVM(fea_tr,lab_tr,fea_ts,lab_ts);

[Xk,Yk,knn_area,knn_AUC]=aucplot_fit(lab_ts,Kscore_ts,cn);


fitness=1-knn_area;
