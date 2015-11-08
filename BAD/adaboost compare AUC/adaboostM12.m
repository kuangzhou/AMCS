% adaboost.M1
 %function [trerr, tserr, w] = adaboostM1(fea_tr, lab_tr, fea_ts, lab_ts,M,cn)
 function [trerr, tserr, w,avgscore_ts,ts_res,rate] = adaboostM12(type, fea_tr, lab_tr, fea_ts, lab_ts, M, cn,Distr)
% perform adaboost algorithm 
% type:                 the based classifier
% fea_tr, lab_tr:       training feature and label
% fea_ts, lab_ts:       testing feature and label
% M:                    iteration num
% cn:                   class num
% 
% trerr                 training error (combined)
% tserr                 testing error
% w                     weight distribution

% first get parameters
vsize = size(fea_tr, 2);
trnum = size(fea_tr, 1);
tsnum = size(fea_ts, 1);
totalscore_tr=zeros(trnum,cn);
totalscore_ts=zeros(tsnum,cn);
avgscore_tr=zeros(trnum,cn);
avgscore_ts=zeros(tsnum,cn);
% 

if (vsize ~= size(fea_ts, 2))
    disp('training feature and testing feature donnot have same size\n');
    return;
end
if (trnum ~= size(lab_tr, 1))
    
    disp('training set has different feature and label size\n');
    return;
end

if (tsnum ~= size(lab_ts, 1))
    disp('testing set has different feature and label size\n');
    return;
end

% deal with different base classifiers
% switch lower(type)
%     


% case 'nearest'                      % nearest neighbour
    % parameters
    weight = ones(1, trnum) / trnum;
    alpha_M = zeros(1, M);
    hypo_tr_M = zeros(1, trnum, M);
    I_tr_M = zeros(1, trnum, M);
    hypo_ts_M = zeros(1, tsnum, M);
    I_ts_M = zeros(1, tsnum, M);
    m = 1; err=[];err(1)=-1;score_tr=[];score_ts=[];
    while m<=M 

% err<0.5 &
%         [fea_tr,fea_ts] = get_sample(ln);
        
         % resample data
       [fea_w, lab_w, idx_w] = resample(fea_tr, lab_tr', weight);
        
        % train base classifier and run base classifier on ORIGINAL trainning data, I==1 means wrongly classified
%-----------------------for KNN, it requires only one step-----------------
%         [I_tr, hypo_tr,rate_tr,score_tr(:,:,m)] = KNN3(fea_w, lab_w, fea_tr, lab_tr,5,'Euclidean');        % train on training set
%         [I_ts, hypo_ts,rate_ts,score_ts(:,:,m)] = KNN3(fea_w, lab_w, fea_ts, lab_ts,5,'Euclidean'); % train on testing set

% %-----------------------Trian RBF-NN---------------------------------------
%         [I_tr, hypo_tr,rate_tr,score_tr(:,:,m)] = RBF(fea_w, lab_w', fea_tr, lab_tr);
%         [I_ts, hypo_ts,rate_ts,score_ts(:,:,m)] = RBF(fea_w, lab_w', fea_ts, lab_ts);

% %-----------------------Trian C45---------------------------------------
%                 [I_tr, hypo_tr,rate_tr,score_tr(:,:,m)] = C4_5(fea_w', lab_w, fea_tr', lab_tr',cn);
%         [I_ts, hypo_ts,rate_ts,score_ts(:,:,m)] = C4_5(fea_w', lab_w, fea_ts', lab_ts',cn);
       

% %-----------------------Trian NB---------------------------------------
        [I_tr, hypo_tr,rate_tr,score_tr(:,:,m)] = DGC(fea_w, lab_w', fea_tr, lab_tr,Distr);
        [I_ts, hypo_ts,rate_ts,score_ts(:,:,m)] = DGC(fea_w, lab_w', fea_ts, lab_ts,Distr);

        % calculate err
        err(m) = weight * I_tr';
%         err
%         totalscore_tr=totalscore_tr+score_tr;
%         totalscore_ts=totalscore_ts+score_ts;
        % calculate beta
        beta_M(m) = err(m)/(1-err(m));
        
        % update weight
        weight = weight .*(beta_M(m).^(1-I_tr));
        weight = weight ./ sum(weight,2);
       
        % store parameters for round m
        hypo_tr_M(:, :, m) = hypo_tr;
        hypo_ts_M(:, :, m) = hypo_ts;
        I_tr_M(:, :, m) = I_tr;
        I_ts_M(:, :, m) = I_ts;
        
        % update m
        m = m + 1;
        
    end

        

    %weighted score
%     acc_weight=(ones(1,(m-1))-err)./sum(ones(1,(m-1))-err);
%     for i=1:m-1
%     avgscore_tr=avgscore_tr+acc_weight(i).*score_tr(:,:,i);
%      avgscore_ts=avgscore_ts+acc_weight(i).*score_ts(:,:,i);
%     end

 
    % show debug information
%     disp(m);
%     disp(alpha_M);
    
    % combine all weak learners and output trainning error
    tr_res = zeros(1, trnum);
    for i = 1:trnum
         
        v = zeros(1, cn);
        for t = 1:m-1
          
            if hypo_tr_M(:, i, t) == lab_tr(i)
             
                v(hypo_tr_M(:, i, t)) = v(hypo_tr_M(:, i, t)) + log(1/beta_M(t));
            end
        end
%          v
         
        [c,argmax] = max(v);
        tr_res(:, i) = argmax; 
    end
    
    tr_err = (tr_res ~= lab_tr');
    trerr = sum(tr_err)/trnum;
%     trerr
    %fprintf(1, 'training err of 5NN is %f\n', trerr);
%    hypo_ts_M
%     
%     % combine all weak learners and output testing error
    ts_res = zeros(1, tsnum);
    for i = 1:tsnum
        v = zeros(1, cn);
        for t = 1:m-1
            if hypo_ts_M(:, i, t) == lab_ts(i)
                v(hypo_ts_M(:, i, t)) = v(hypo_ts_M(:, i, t)) + log(1/beta_M(t));
            end
        end
        
        [c,argmax] = max(v);
        ts_res(:, i) = argmax; 
    end
%     ts_res
    ts_err = (ts_res ~= lab_ts');
    tserr = sum(ts_err)/tsnum;
    
    %fprintf(1, 'testing err of 5NN is %f\n', tserr);
% %     
% %     % output weight
    w = weight;
    
%  %Calculate error rate for mojority class and minority class    
max_count=0;
min_count=0;
count=zeros(1,cn);
for i=1:cn

    label_class{:,i}=find(lab_ts==i);
    size_class(i)=size(label_class{:,i},1);
        for j=1:size_class(i)
    if ts_res(label_class{i}(j,:))==lab_ts(label_class{i}(j,:))
         count(i)=count(i)+1;
    end
        end
end
rate=count./size_class;
avgscore_ts=zeros(tsnum,cn);

for i=1:cn

avgscore_ts(find(ts_res'==i),i)=1;
end



% [max_size,max_class]=max(size_class);
% [min_size,min_class]=min(size_class);
% for i=1:max_size
%     if ts_res(label_class{max_class}(i))==lab_ts(label_class{max_class}(i))
%         max_count=max_count+1;
%     end
% end
% maxrate=1-(max_count/size_class(max_class));
% 
% for i=1:min_size
%     if ts_res(label_class{min_class}(i))==lab_ts(label_class{min_class}(i))
%         min_count=min_count+1;
%     end
% end
% minrate=1-(min_count/size_class(min_class));