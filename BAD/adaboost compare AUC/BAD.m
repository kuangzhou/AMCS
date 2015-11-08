function  BAD(train_data,lab_tr,test_data,lab_ts,cn)
% Using BPSO as feature selection method, Adaboost as ensemble framework and KNN as base classifier
addpath(genpath(pwd));
[gBest,gBestScore]=BPSO(1,cn,lab_tr,lab_ts,train_data,test_data)
[BAhypo,acc,AUCarea]=CompareAUC(train_data,lab_tr,test_data,lab_ts,gBest);
acc
AUCarea
[GM,FV]=G(lab_ts,BAhypo,cn)