function [G,F]=G(lab_data,hypo,cn)
c=1;Area=0;
for i=1:cn
   
            clear laba labb na nb score lab;
            laba=find(lab_data==i);
            na=size(laba,1);
            lab=zeros(size(lab_data));
            for k=1:na
                lab(laba(k))=1;
            end
       
            labb=find(hypo==i);
            nb=size(labb,2);
            hyp=zeros(size(lab_data));
            for k=1:nb
                hyp(labb(k))=1;
            end
        [GM(i),FV(i)]=calculate(lab,hyp);
%         fprintf('第%d类和',i);fprintf('其余类');fprintf('的GM值为:%d\n',GM(i));
%                 fprintf('第%d类和',i);fprintf('其余类');fprintf('的FV值为:%d\n',FV(i));
                
                

   
end
G=mean(GM);
                F=mean(FV);
     