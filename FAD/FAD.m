function  FAD(train_data,lab_tr,test_data,lab_ts,cn)
% Using FCBF as feature selection method, Adaboost as ensemble framework and DGC as base classifier
addpath(genpath(pwd));
gBest=FCBF(train_data,lab_tr);
tsnum=length(lab_ts);

[AUCarea,FAhypo]=FCompareAUC(train_data,lab_tr,test_data,lab_ts,gBest);
AUCarea
acc=length(find(FAhypo'==lab_ts))/tsnum
%Output
[GM,FV]=G(lab_ts,FAhypo,cn)
