function [X,Y,Area,AUC]=aucplot(lab_data,score_data,cn)
c=1;Area=0;

for i=1:cn
    for j=i+1:cn
       
            clear laba labb na nb score lab;
            laba=find(lab_data==i);
            labb=find(lab_data==j);
            na=size(laba,1);
            nb=size(labb,1);
            
            if na>nb%decide which is positive pattern
                n=i;m=na;Plab=laba;Flab=labb;
            else 
                n=j;m=nb;Plab=labb;Flab=laba;
            end
            for k=1:m
                score(k)=score_data(Plab(k),n);
%                 /(score_data(Plab(k),i)+score_data(Plab(k),j));
                lab(k)=1;
            end
            for k=m+1:na+nb
                score(k)=score_data(Flab(k-m),n);
%                 /(score_data(Flab(k-m),i)+score_data(Flab(k-m),j));
                lab(k)=0;
            end
     
        AUC(c)=rocplot(score,lab,0);
%          fprintf('第%d类和',i);fprintf('第%d类',j);fprintf('的AUC值为:%d\n',AUC(c));
%    
        c=c+1;
    end
end
%将AUC点排序
order=sort(AUC,'descend');
n=size(order,2);
if n==3
    r=order;
    Area=0.5*sin(2*pi/n)*(r(1)*r(2)+r(2)*r(3)+r(n)*r(1));
else if n/2==0
    for i=1:(n/2)
    r(i+1)=order(2*i);
    end
    for i=(n/2)+1:n-1
    r(i+1)=order(n-2*(i-(n/2)-1)-1);
    end
    else
    for i=1:floor(n/2)
    r(i+1)=order(2*i);
    end
    for i=floor(n/2)+1:n-1
    r(i+1)=order(n-2*(i-floor(n/2)-1));
    end
    end
    r(1)=order(1);
    tmp=0;
    for i=1:n-1
        tmp=tmp+r(i)*r(i+1);
    end
    Area=0.5*sin(2*pi/n)*(tmp+r(n)*r(1));
   
end
maxArea=0.5*sin(2*pi/n)*n;
Area=Area/maxArea;
X=[0:pi/(cn*(cn-1)/4):2*pi];
Y=[r,r(1)];




            