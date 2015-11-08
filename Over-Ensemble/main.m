tic
clc
clear
clear all
addpath(genpath(pwd));
load autos
lab_tr=tr_label;
lab_ts=ts_label;
[trnum,dim]=size(tr_data);
[tsnum,dim]=size(ts_data);
class=unique(lab_tr);
cn=length(class);
% Feature selection
[gBest,gBestScore]=BPSO(1,cn,lab_tr,lab_ts,tr_data,ts_data)
%Ensemble learning
% gBest=ones(1,dim);
% gBest=[1     0     1     0     1     1     1     0]%aba
[Bhypo,hypo,BCrate,Crate,Bacc,acc]=EnsembleLearning(tr_data,lab_tr,ts_data,lab_ts,gBest,cn);
count=zeros(1,cn);
Bcount=zeros(1,cn);

%Output
M=zeros(tsnum,cn);
BM=zeros(tsnum,cn);
for j=1:5
    fprintf('rule %d : \n',j);
for i=1:tsnum
    M(i,hypo(j,i),j)=1;
    BM(i,Bhypo(:,i),j)=1;
end
    %AUCarea
[Xa1,Ya1,Ensemble_FS,ada_AUC1]=aucplot(lab_ts,BM(:,:,j),cn);
fprintf('\n')
fprintf('AUCarea:')
Mean_E_FS=mean(ada_AUC1);
AUCarea=Ensemble_FS

%Gmean,Fvalue
[GM,FV]=G(lab_ts,Bhypo(j,:),cn)
end

% FCBF
fprintf('results when using FCBF as feature selection method')
gBest=FCBF(tr_data,lab_tr);
%Ensemble learning
% gBest=ones(1,dim);
% gBest=[1     0     1     0     1     1     1     0]%aba
[Fhypo,FCrate,Facc]=FCBF_EnsembleLearning(tr_data,lab_tr,ts_data,lab_ts,gBest,cn);
FCrate

Facc
Fcount=zeros(1,cn);

%Output
FM=zeros(tsnum,cn);
for j=1:5
    fprintf('rule %d : \n',j);
for i=1:tsnum
    FM(i,Fhypo(:,i),j)=1;
end
    %AUCarea
[Xa1,Ya1,Ensemble_FE,ada_AUC1]=aucplot(lab_ts,FM(:,:,j),cn);

fprintf('AUCarea:')
Mean_E_FS=mean(ada_AUC1)
AUCarea=Ensemble_FS

%Gmean,Fvalue

[GM,FV]=G(lab_ts,Fhypo(j,:),cn)
end

toc