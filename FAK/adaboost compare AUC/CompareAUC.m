function [Khypo,Ahypo,BKhypo,BAhypo,adatserr,adatserr1]=CompareAUC(train_data,lab_tr,test_data,lab_ts,gBest)
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


[I,BKhypo,tserr1,Kscore_ts1,tsrate1]=KNN(fea_tr,lab_tr,fea_ts,lab_ts,5);

% 
[adatrerr1, adatserr1,w,Ascore_ts1,BAhypo,adatsrate1] = adaboostM12('nearest',fea_tr, lab_tr, fea_ts, lab_ts, iterationNum,cn);


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


[I,Khypo,tserr,Kscore_ts,tsrate]=KNN(fea_tr,lab_tr,fea_ts, lab_ts,5);

[adatrerr, adatserr,w,Ascore_ts,Ahypo,adatsrate] = adaboostM12('nearest',fea_tr, lab_tr, fea_ts, lab_ts, iterationNum,cn);
%  min_tsacc1=1-min_tserr1
%  min_tsacc=1-min_tserr
%  max_tsacc1=1-max_tserr1
%  max_tsacc=1-max_tserr
adatsrate
adatsrate1
tsrate
tsrate1
 tsacc1=1-tserr1
tsacc=1-tserr
 adatsacc=1-adatserr
adatsacc1=1-adatserr1

fprintf('ada-KNN(FS)各类AUC对比:\n');
[Xa1,Ya1,ada_area1,ada_AUC1]=aucplot(lab_ts,Ascore_ts1,cn);
fprintf('\n')
fprintf('ada-KNN(FS)的AUCarea:')
ada_area1
fprintf('\n')
fprintf('KNN(FS)各类AUC对比:\n');
[Xk1,Yk1,knn_area1,knn_AUC1]=aucplot(lab_ts,Kscore_ts1,cn);
fprintf('\n')
fprintf('KNN(FS)的AUCarea:')
knn_area1
fprintf('\n')
fprintf('KNN各类AUC对比:\n');
[Xk,Yk,knn_area,knn_AUC]=aucplot(lab_ts,Kscore_ts,cn);
fprintf('\n')
fprintf('KNN的AUCarea:')
knn_area
fprintf('\n')
fprintf('ada-KNN各类AUC对比:\n');
[Xa,Ya,ada_area,ada_AUC]=aucplot(lab_ts,Ascore_ts,cn);
fprintf('\n')
fprintf('ada-KNN的AUCarea:')
ada_area

%figure(2);
%polar(Xa,Ya,'-ob');
%hold on
%polar(Xk,Yk,'-.^k');
%hold on 
%polar(Xk1,Yk1,'-*r');
%hold on
%polar(Xa1,Ya1,'-+g');
%legend( 'multi-AUC using Adaboost-KNN', 'multi-AUC using KNN', 'multi-AUC using BPSO-KNN','multi-AUC using BPSO-Adaboost-KNN');
% title('AUC of oilsk84')