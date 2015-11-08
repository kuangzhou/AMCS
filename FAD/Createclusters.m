function clusters=Createclusters(tr_data,tr_label,epsilon,cn)
%the clusters is a structure that contains three parts, namely size,
%particle and centroid.
%%%        (1)cluster.mass stores the number of example in the data particle 
%             cluster.mass is a cell of size cn(# of class),in which cluster.mass{k} is a J-dimention vector,J is the number of particles belong to class k. 
%             Each element of cluster.mass{k}(j) represent the number of training examples in particle j that belongs to class k.
%%%        (2)clusters.par is a cell of size {cn}*{J}. cluster.par{k}{j} stores the training exsamples of particle j that belongs to class k
%%%        (3)cluster.cen{k}(j,:) is the centroid of particle j that belongs to class k

trnum=size(tr_data,1);
dim=size(tr_data,2);
clusters.mass=cell(1,cn);
for k=1:cn
    clear sub_data
    sub_data=tr_data(find(tr_label==k),:);
    sub_size=size(sub_data,1);
    j=1;
    while ~isempty(sub_data) 
        %initialize clusters{k}{j}
        clusters.par{k}{j}=[sub_data(1,:)];
        clusters.cen{k}(j,:)=sub_data(1,:);
        clusters.mass{k}(j)=size(clusters.par{k}{j},1);
        if sub_size==1
            clusters.mass{k}(j)=1;
            break;
        end
        index=[1];
        for i=2:sub_size
            if abs(sum(sub_data(i,:)-clusters.cen{k}(j,:)))/dim <epsilon
                clusters.par{k}{j}=[clusters.par{k}{j};sub_data(i,:)]; %add sub_data(u,:) to the particle
                clusters.cen{k}(j,:)=sum(clusters.par{k}{j})./size(clusters.par{k}{j},1);% updating the centroid
                index=[index i];%record the index of selected example
            end
        end
        %remove all the examples selected into the particle{k}{j}
        sub_data(index,:)=[];
        sub_size=sub_size-size(index,2);
        
        %update mass of cluster{k}{j}, if the sub_data is not empty,
        %turn into next round to construct another particle that belongs to
        %clss k
        clusters.mass{k}(j)=size(clusters.par{k}{j},1);
        j=j+1;
    end
end
        
    
    



