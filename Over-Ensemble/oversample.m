function  [curtrainset1,curtrainlab1]=oversample(train_data,lab_tr,cn)
% cn  ----number of classes
% T   ----number of iterations
%divide each sample to each classes 
for i=1:cn
    trset_class{i}=train_data(find(lab_tr==i),:);
    trlab_class{i}=lab_tr(find(lab_tr==i));
    label_size(i)=size(find(lab_tr==i),1);
end

%---------------------------SMOTE--------------------------
% [label_order,label_ind]=sort(label_size,'descend');
% max_size=label_order(1);
%     curtrainset=[trset_class{label_ind(1)}];
%     curtrainlab=[trlab_class{label_ind(1)}];
%     for i=2:cn
%         min_trset=trset_class{label_ind(i)};
%             min_trlab=trlab_class{label_ind(i)};
%         if label_order(i)<=(max_size/10)
%             min_size=label_order(i)*9;
%         else
%             min_size=(max_size-label_order(i))*0.8;
%         end
%             min_sample=SMOTE(min_trset',min_size);
%             min_trset=[min_trset;min_sample'];
%             min_trlab=[min_trlab;label_ind(i)*ones(min_size,1)];
%              curtrainset=[curtrainset;min_trset];
%              curtrainlab=[curtrainlab;min_trlab];
%     end
%             
%           
%   
%     % order subset
%     curtrainset1=curtrainset(find(curtrainlab==1),:);
%     curtrainlab1=curtrainlab(find(curtrainlab==1),:);
%     for i=2:cn
%         curtrainset1=[curtrainset1;curtrainset(find(curtrainlab==i),:)];
%         curtrainlab1=[curtrainlab1;curtrainlab(find(curtrainlab==i),:)];
%     end
    


%--------------------------ROS----------------------------
%sort all classes, if the size of minimum class is less than 5, over-sampling the minimum class until the size of minimum class is lagrge than 5 
[label_order,label_ind]=sort(label_size,'descend');
max_size=label_order(1);
    curtrainset=[trset_class{label_ind(1)}];
    curtrainlab=[trlab_class{label_ind(1)}];



    for i=2:cn
 min_trset=trset_class{label_ind(i)};
 min_trlab=trlab_class{label_ind(i)};
 %randly repeat samples in those classes whose size is smaller than 5,
        if label_order(i)<=(max_size/10)
            min_size=label_order(i)*9;
            
        else
            min_size=(max_size-label_order(i));
 
        end
        
            for j=1:min_size
                min_trset=[min_trset;min_trset(randi([1 label_order(i)]),:)];
                 min_trlab=[min_trlab;label_ind(i)];
            end
             curtrainset=[curtrainset;min_trset];
             curtrainlab=[curtrainlab;min_trlab];
             %randly under-sampling samples in those majority classes.
        end  
  
    % order subset
    curtrainset1=curtrainset(find(curtrainlab==1),:);
    curtrainlab1=curtrainlab(find(curtrainlab==1),:);
    for i=2:cn
        curtrainset1=[curtrainset1;curtrainset(find(curtrainlab==i),:)];
        curtrainlab1=[curtrainlab1;curtrainlab(find(curtrainlab==i),:)];
    end
    
    
    


        
        