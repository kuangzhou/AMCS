function [SU_xx]= Fcorrelation(Xi, Xj)
%Calculating information gain of a pair of featrues, namely featrue xi and
%featrue xj

trnum=length(Xi);

% Comput P of Xi(P_Xi), and information of Xi(H_Xi) 
U_Xi      = unique(Xi);% range of data
    Nbins_Xi	= length(U_Xi);
    % discretization numberic data
    if Nbins_Xi>0.1*trnum & any(round(Xi)~=Xi)
        Xi=Discretization(Xi);
        U_Xi      = unique(Xi);% range of data
        Nbins_Xi	= length(U_Xi);
    end
    for i=1:Nbins_Xi
        P_Xi(i)=length(find(Xi==U_Xi(i)))/trnum;
    end
    H_Xi=-sum(P_Xi.*log2(P_Xi));

% Compute p of Xj(P_Xj) and information of Xj(H_Xj)
U_Xj      = unique(Xj);% range of data
    Nbins_Xj	= length(U_Xj);
    % discretization numberic data
    if Nbins_Xj>0.1*trnum & any(round(Xj)~=Xj)
        Xj=Discretization(Xj);
        U_Xj      = unique(Xj);% range of data
        Nbins_Xj	= length(U_Xj);
    end
    for i=1:Nbins_Xj
        P_Xj(i)=length(find(Xj==U_Xj(i)))/trnum;
    end
    H_Xj=-sum(P_Xj.*log2(P_Xj));
    
%Compute  P of Xi given Xj(denote as P_xx)

    for i=1:Nbins_Xi
        for j=1:Nbins_Xj
            P_xx(i,j)=length(find((Xj==U_Xj(j)) & (Xi==U_Xi(i))))/trnum/P_Xj(j);
            if P_xx(i,j)==0
                P_xx(i,j)=1;
            end
        end
    end
    Hxx=-sum(P_Xj.*sum(P_xx.*log2(P_xx)));
    IG=H_Xi-Hxx;
    SU_xx=2*(IG./(H_Xi+H_Xj));