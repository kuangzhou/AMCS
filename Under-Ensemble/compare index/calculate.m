function [GM,FV]=calculate(lab,hypo)
TP=sum(hypo==1&lab==1);
FN=sum(hypo==0&lab==1);
FP=sum(hypo==1&lab==0);
TN=sum(hypo==0&lab==0);
% if TP==0&FN==0
%     GM=sqrt(TN/(TN+FP));
% else if TN==0&FP==0
%         GM=sqrt(TP/(TP+FN));
%     else
GM=((TP/(TP+FN))*(TN/(TN+FP)))^0.5;
%     end
% end
RE=TP/(TP+FN);
PR=TP/(TP+FP);
if TP==0
    FV=0;
else
    FV=(2*RE*PR)/(RE+PR);
end