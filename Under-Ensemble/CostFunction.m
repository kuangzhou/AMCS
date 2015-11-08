function [fitness]=CostFunction(Position,lab_tr,lab_ts,train_data,test_data)
j=1;fea_tr=[];fea_ts=[];
class=unique(lab_tr);
cn=length(class);
tsnum=size(lab_ts,1);
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

% [I,hypo,tserr]=RBF(fea_tr,lab_tr,fea_ts,lab_ts);
%  [I,hypo,tserr]=DGC(fea_tr,lab_tr,fea_ts,lab_ts);
% [I,hypo,tserr]=KNN(fea_tr,lab_tr,fea_ts,lab_ts,5);
[I,hypo,tserr]=C4_5(fea_tr',lab_tr',fea_ts',lab_ts,cn);
%  [I,hypo,tserr]=SVM(fea_tr,lab_tr,fea_ts,lab_ts);

M=zeros(tsnum,cn);
for i=1:tsnum
    M(i,hypo(i,:))=1;
end

[Xk,Yk,knn_area,knn_AUC]=aucplot_fit(lab_ts,M,cn);

fitness=1-knn_area;

