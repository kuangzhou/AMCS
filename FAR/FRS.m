function  FRS(train_data,lab_tr,test_data,lab_ts,cn)
% Using FCBF as feature selection method, Adaboost as ensemble framework and RBF as base classifier
addpath(genpath(pwd));
gBest=FCBF(train_data,lab_tr);tsnum=length(lab_ts);

[AUCarea,FAhypo]=FCompareAUC(train_data,lab_tr,test_data,lab_ts,gBest);
AUCarea
Fcount=zeros(1,cn);
acc=length(find(FAhypo'==lab_ts))/tsnum
%Output
[GM,FV]=G(lab_ts,FAhypo,cn)

