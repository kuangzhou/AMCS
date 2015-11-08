clc
clear
clear all
% 添加当前路径下所有子目录

load('splice.mat');
    train_data=tr_data;
    lab_tr=tr_lable';
    test_data=ts_data;
    lab_ts=ts_lable';
   
%load('oilsk81.mat');
%    load('oilsk82.mat');
    %oilsk84data(7,:)=[];
   % oilsk84lable(:,7)=[];
 %   train_data=oilsk81data;
 %   lab_tr=oilsk81lable;
 %   test_data=oilsk82data;
%lab_ts=oilsk82lable;

U        = unique(lab_tr); % class labels
cn= length(U);%number of classes

gBest=ones(1,size(train_data,2));%计算最佳特征子集的分类效果
fea_tr=[];fea_ts=[];j=1;
for i=1:size(gBest,2)%提取样本子集
    if gBest(i)==1
        fea_tr(:,j)=train_data(:,i);
        fea_ts(:,j)=test_data(:,i);
        j=j+1;
    end
end
 iterationNum=50;
[I,hypo,trerr,Kscore_tr]=KNN1(fea_tr,lab_tr,fea_tr, lab_tr,5,'Euclidean');
[I,Khypo,tserr,Kscore_ts]=KNN1(fea_tr,lab_tr,fea_ts,lab_ts,5,'Euclidean');
[GMK,FVK]=G(lab_ts,Khypo,cn)
[adatrerr, adatserr,Ahypo] = adaboostM1('nearest',fea_tr, lab_tr, fea_ts, lab_ts, iterationNum,cn);
[GMA,FVA]=G(lab_ts,Ahypo,cn)


%gBest=[ 0    0     0    1     0     1];
%gBest=[1 0 0 1];%new
%gBest=[0 1 1 1];%balance
%gBest=[1     1     1     1     0     1     1     0     0]%glass
%gBest=[1     1     1     0     0     1     0     1     1     1     0     0 1     1     0     0]%zoo
%gBest=[1 0 0 01 1 1 0 0 1 1 0 1 1 0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0 0 1 0 0 1]%landsat
%gBest=[1 1 1 0 1 1 0]%ecoli
%gBest=[0 0 1 1 1 ]%hayes
%gBest=[0 0 1 1 1 0 0 1 0 1 0 0 0 0  1 1 1 1 0 0 0 1 1 1 0 0 1 1 1 1 0 1 0
%1 0 0 1 0 1 0 0 1 0 1 1 1 1 1 0 1 0 0 0 0 1 0 0 0 1 1 ]%splice
gBest=[1 1 1 0 1 0 1 1 1 0]%page
%gBest=[0 1 0 1 1 0 1 0 0 0 1]
%计算最佳特征子集的分类效果
fea_tr=[];fea_ts=[];j=1;
for i=1:size(gBest,2)%提取样本子集
    if gBest(i)==1
        fea_tr(:,j)=train_data(:,i);
        fea_ts(:,j)=test_data(:,i);
        j=j+1;
    end
end
iterationNum=50;
[I,hypo,trerr1,Kscore_tr]=KNN1(fea_tr,lab_tr,fea_tr, lab_tr,5,'Euclidean');
[I,BKhypo,tserr1,Kscore_ts]=KNN1(fea_tr,lab_tr,fea_ts,lab_ts,5,'Euclidean');
[GMBK,FVBK]=G(lab_ts,BKhypo,cn)
[adatrerr1, adatserr1,BAhypo] = adaboostM1('nearest',fea_tr, lab_tr, fea_ts, lab_ts, iterationNum,cn);
[GMBA,FVBA]=G(lab_ts,BAhypo,cn)
