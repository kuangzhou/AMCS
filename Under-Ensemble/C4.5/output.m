function output(hypo,lab_ts,cn,test_data)
%[GMA,FVA,accuracy,maxrate,minrate]=
tsnum=size(lab_ts,2); 
ts_err = (hypo ~= lab_ts);
   accuracy = 1-sum(ts_err)/tsnum%total accuracy
    
% accuracy of majority and minority 
max_count=0;
min_count=0;
for i=1:cn

    label_class{:,i}=find(lab_ts==i);
    size_class(i)=size(label_class{:,i},2);
end
[max_size,max_class]=max(size_class);
[min_size,min_class]=min(size_class);
for i=1:max_size
    if hypo(label_class{max_class}(i))==lab_ts(label_class{max_class}(i))
        max_count=max_count+1;
    end
end
maxrate=(max_count/size_class(max_class))

for i=1:min_size
    if hypo(label_class{max_class}(i))==lab_ts(label_class{max_class}(i))
        min_count=min_count+1;
    end
end
minrate=(min_count/size_class(min_class))
% construct matrix score
score_data=zeros(size(test_data,1),cn);
for i=1:size(test_data,1)
    for j=1:cn
        if hypo(i)==j
            score_data(i,j)=1;
        else
            score_data(i,j)=0;
        end
    end
end
% calculate AUCarea,Gmean and Fvalue
 [Xa,Ya,ada_area,ada_AUC]=aucplot(lab_ts,score_data,cn);
ada_area
[GMA,FVA]=G(lab_ts,hypo,cn)
 
