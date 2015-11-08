function AMCS(tr_data,tr_label,ts_data,ts_label)
% This is the source code of Adaptive Multiple Classifier System£¨AMCS£©
%?	For the High IR, High dimension, Large number of classes datasets, the adapting route of AMCS is: FCBF as feature selection algorithm, Adaboost as the ensemble framework, C4.5 as the base classifier. 
%?	For theHigh IR, Low dimension, Large number of classes datasets, the adapting route of AMCS is:BPSO as feature selection algorithm, Adaboost as the ensemble framework, KNN as the base classifier.
%?	For the High IR, High dimension, Small number of classes datasets,the adapting route of AMCS is: FCBF as feature selection algorithm, Adaboost as the ensemble framework, C4.5 as the base classifier.
%?	For the High IR, Low dimension, Small number of classes datasets, the adapting route of AMCS is: BPSO as feature selection algorithm, Adaboost as the ensemble framework, SVM as the base classifier.
%?	For the Low IR, High dimension, Large number of classes datasets, the adapting route of AMCS is: BPSO as feature selection algorithm, Adaboost as the ensemble framework, RBF as the base classifier.
%?	For the Low IR, Low dimension, Large number of classes datasets, the adapting route of AMCS is:FCBF as feature selection algorithm, Adaboost as the ensemble framework, SVM as the base classifier.
%?	For the Low IR, High dimension, Small number of classes datasets, the adapting route of AMCS is:BPSO as feature selection algorithm, Adaboost as the ensemble framework, C4.5 as the base classifier.
%?	For the Low IR, Low dimension, Small number of classes, the adapting route of AMCS is: BPSO as feature selection algorithm, Adaboost as the ensemble framework, SVM as the base classifier.


% tr_label,ts_label are column vector
% libsvm need to be installed for using this code
U        = unique(tr_label); % class labels
cn= length(U);%number of classes
%
   for i=1:cn
    label_class{:,i}=find(ts_label==i);
    size_class(i)=size(label_class{:,i},1);
   end
IR=max(size_class)/min(size_class);
[trnum,dim]=size(tr_data);
if IR>=10 && cn>=6 && dim>=10
    addpath('FAC');
    FAC(tr_data,tr_label,ts_data,ts_label,cn)
elseif IR>=10 && dim<10 && cn >=6
    addpath('BAK')
    BAK(tr_data,tr_label,ts_data,ts_label,cn)
elseif IR>=10 && dim>=10 && cn<6
    addpath('FAC')
    FAC(tr_data,tr_label,ts_data,ts_label,cn)
elseif IR>=10 && dim<10 &&cn<6
    addpath('BAS')
    BAS(tr_data,tr_label,ts_data,ts_label,cn)
elseif IR<10 && dim>=10 && cn>=6
    addpath('BAR')
    BAR(tr_data,tr_label,ts_data,ts_label,cn)
elseif IR<10 && dim<10 && cn>=6
    addpath('FAS')
    FAS(tr_data,tr_label,ts_data,ts_label,cn)    
elseif IR<10 && dim>=10 && cn<6
    addpath('BAC')
    BAC(tr_data,tr_label,ts_data,ts_label,cn)  
elseif IR<10 && dim<10 && cn<6
    addpath('BAS')
    BAS(tr_data,tr_label,ts_data,ts_label,cn)

end
    
