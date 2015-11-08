function  [curtrainset1,curtrainlab1]=undersample(train_data,lab_tr,cn)
% cn  ----number of classes
% T   ----number of iterations
%divide each sample to each classes 
for i=1:cn
    trset_class{i}=train_data(find(lab_tr==i),:);
    trlab_class{i}=lab_tr(find(lab_tr==i));
    label_size(i)=size(find(lab_tr==i),1);
end
%sort all classes, if the size of minimum class is less than 5, over-sampling the minimum class until the size of minimum class is lagrge than 5 
[label_order,label_ind]=sort(label_size);
min_size=label_order(1);
if label_order(1)<=5
             min_trset=repmat(trset_class{label_ind(1)},round(5/label_order(1)),1);
             min_trlab=repmat(trlab_class{label_ind(1)},round(5/label_order(1)),1);
%              min_trset=trset_class{label_ind(1)};
%              min_trlab=trlab_class{label_ind(1)};
             min_size=5;
             curtrainset=[min_trset];
             curtrainlab=[min_trlab];
else
    curtrainset=[trset_class{label_ind(1)}];
    curtrainlab=[trlab_class{label_ind(1)}];
end


    for i=2:cn
        trset=[];trlab=[];
            %randly repeat samples in those classes whose size is smaller than 5,
        if label_order(i)<=5
             min_trset=repmat(trset_class{label_ind(i)},round(min_size/label_order(i)),1);
             min_trlab=repmat(trlab_class{label_ind(i)},round(min_size/label_order(i)),1);
%              min_trset=trset_class{label_ind(i)};
%              min_trlab=trlab_class{label_ind(i)},round(min_size/label_order(i)),1);
             curtrainset=[curtrainset;min_trset];
             curtrainlab=[curtrainlab;min_trlab];
             %randly under-sampling samples in those majority classes.
        else if label_order(i)>min_size*2
                maj_size=min_size*2;
            trset_class{label_ind(i)}=trset_class{label_ind(i)}(randperm(label_order(i)),:);
            trset=trset_class{label_ind(i)}([1:maj_size],:);
            trlab=trlab_class{label_ind(i)}([1:maj_size]);
            curtrainset=[curtrainset;trset];
            curtrainlab=[curtrainlab;trlab];
            %If the size of majority classes are larger than twice of min_size, under-sample 2*min_size of majority class.
            else
            trset_class{label_ind(i)}=trset_class{label_ind(i)}(randperm(label_order(i)),:);
            trset=trset_class{label_ind(i)}([1:min_size],:);
            trlab=trlab_class{label_ind(i)}([1:min_size]);
            curtrainset=[curtrainset;trset];
            curtrainlab=[curtrainlab;trlab];
            end
        end  
    end
    % order subset
    curtrainset1=curtrainset(find(curtrainlab==1),:);
    curtrainlab1=curtrainlab(find(curtrainlab==1),:);
    for i=2:cn
        curtrainset1=[curtrainset1;curtrainset(find(curtrainlab==i),:)];
        curtrainlab1=[curtrainlab1;curtrainlab(find(curtrainlab==i),:)];
    end
    
        
        