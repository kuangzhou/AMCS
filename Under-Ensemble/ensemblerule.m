function hypo=ensemblerule(prob,cn,rule,tsnum)
for i=1:tsnum
for j=1:cn
    switch rule
        case 1 %max
            r(i,j)=max(prob(i,j,:));
        case 2 %min
            r(i,j)=min(prob(i,j,:));
        case 3 %product
            r(i,j)=prod(prob(i,j,:));
        case 4 %majority vote
            [tmp,ind]=max(prob(i,:,:),[],2);
            r(i,j)=length(find(ind==j));
        case 5 %sum
            r(i,j)=sum(prob(i,j,:));
    end
end
[p,hypo(i)]=max(r(i,:));
end

            
           