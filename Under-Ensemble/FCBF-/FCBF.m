function Sbest=FCBF(data,label)
[nd,dim]=size(data);
%Calculate SU for each featrue, select the featrues whose SU larger than
%thr into original subset
SU_xy=Ccorrelation(data,label);
SU_xy=sort(SU_xy);
class=unique(label);
cn=length(class);
% thr=SU_xy(round(dim/log(dim))); %threshold label
thr=0; %threshold label

Sub_SU=SU_xy(find(SU_xy>=thr));
Sub_data=data(:,find(SU_xy>=thr));
[Order,Sub_index]=sort(Sub_SU,'descend');
Sub_size=size(Sub_index,2);
Fj=Sub_index(1);%get the first element of original subset
j=1;
i=1;
while j<Sub_size
    while i<Sub_size
        Fi=Sub_index(i+1);
        SU_xx=Fcorrelation(Sub_data(:,Fj),Sub_data(:,Fi));% compute SU of featrue Fi and Fj
        if SU_xx>=Sub_SU(Sub_index(i));
            Sub_index(i)=[];
            Sub_size=Sub_size-1;
        else
            i=i+1;
        end
    end
        Fj=Sub_index(j);
    j=j+1;

end
Sbest=zeros(1,cn);
Sbest(Sub_index)=1;



