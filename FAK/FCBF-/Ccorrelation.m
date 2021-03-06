function [SU_xy]= Ccorrelation(patterns, targets)
%Calculating information gain and information about X and Y
%  patterns     - Train patterns,(the number of samples)*(the number of features)
%  targets	    - Train targets, (the number of samples)*1
[trnum, dim]		= size(patterns);
class= unique(targets);%训练集D的类数，并从小到大排序
Cn=length(class);
% Comput P of y(P_y) and information of y(Hy)
for i = 1:length(class),
    P_y(i) = length(find(targets == class(i))) / trnum;
end
Hy = -sum(P_y.*log2(P_y));%info(D),H(Y)

%For each dimension, compute the P_x and P of x given y(denote as P_xy)
for c = 1:dim,
    data	= patterns(:,c);
    Ud      = unique(data);% range of data
    Nbins	= length(Ud);
    % discretization numberic data
    if Nbins>0.1*trnum & any(round(data)~=data)
        data=Supervised_Discretization(data,targets);
        Ud      = unique(data);% range of data
        Nbins	= length(Ud);
    end

    for i=1:Nbins
        P_x(i)=length(find(data==Ud(i)))/trnum;
        Hx(c)=-sum(P_x.*log2(P_x));
        for j=1:Cn
            P_xy(i,j)=length(find((targets==class(j)) & (data==Ud(i))))/trnum/P_y(j);
            if P_xy(i,j)==0
                P_xy(i,j)=1;
            end
        end
    end
    Hxy(c)=-sum(P_y.*sum(P_xy.*log2(P_xy)));
    IG(c)=Hx(c)-Hxy(c);
end
SU_xy=2*(IG./(Hx+Hy));
        
