%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  BPSO and VPSO source codes version 1.0                           %
%                                                                   %
%  Developed in MATLAB R2011b(7.13)                                 %
%                                                                   %
%  Author and programmer: Seyedali Mirjalili                        %
%                                                                   %
%         e-Mail: ali.mirjalili@gmail.com                           %
%                 seyedali.mirjalili@griffithuni.edu.au             %
%                                                                   %
%       Homepage: http://www.alimirjalili.com                       %
%                                                                   %
%   Main paper: S. Mirjalili and A. Lewis, "S-shaped versus         %
%               V-shaped transfer functions for binary Particle     %
%               Swarm Optimization," Swarm and Evolutionary         %
%               Computation, vol. 9, pp. 1-14, 2013.                %
%                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [gBest,gBestScore]=BPSO(BPSO_num,cn,lab_tr,lab_ts,train_data,test_data,Distr)

%Initial Parameters for PSO
Max_iteration=20; % Maximum number of iterations
noP=20; % Number of particles
D=size(train_data,2);%样本数和特征维数 
w=2;              %Inirtia weight
wMax=0.9;         %Max inirtia weight
wMin=0.4;         %Min inirtia weight
c1=2;
c2=2;
Vmax=6;

Velocity=zeros(noP,D);%Velocity vector
Position=zeros(noP,D);%Position vector
fitness=zeros(1,noP);

%////////Cognitive component///////// 
pBestScore=ones(noP);
pBest=ones(noP,D);
%////////////////////////////////////

%////////Social component///////////
gBestScore=inf;
gBest=ones(1,D);
%///////////////////////////////////

ConvergenceCurve=zeros(1,Max_iteration); %Convergence vector

%Initialization
for i=1:size(Position,1) % For each particle
    for j=1:size(Position,2) % For each variable
        if rand<=0.5
            Position(i,j)=0;
        else
            Position(i,j)=1;
        end
    end
     if Position(i,:)==zeros(1,D);
                Position(i,randi([1,D],1,1))=1;
        else if Position(i,:)==ones(1,D);
                 Position(i,randi([1,D],1,1))=0;
            end
    end
end


for l=1:Max_iteration

    %Calculate cost for each particle
    for i=1:size(Position,1)  
        fitness(i)=CostFunction(Position(i,:),lab_tr,lab_ts,train_data,test_data,Distr);
        
        if(pBestScore(i)>fitness(i))
            pBestScore(i)=fitness(i);
            pBest(i,:)=Position(i,:);
        end
        if(gBestScore>fitness(i))
            gBestScore=fitness(i);
            gBest=Position(i,:);
        end
    end

    %update the W of PSO
    w=wMax-l*((wMax-wMin)/Max_iteration);
    %Update the Velocity and Position of particles
    for i=1:size(Position,1)
        for j=1:size(Position,2) 
            %Equation (1)
            Velocity(i,j)=w*Velocity(i,j)+c1*rand()*(pBest(i,j)-Position(i,j))+c2*rand()*(gBest(j)-Position(i,j));
            
            if(Velocity(i,j)>Vmax)
                Velocity(i,j)=Vmax;
            end
            if(Velocity(i,j)<-Vmax)
                Velocity(i,j)=-Vmax;
            end  
            
            if BPSO_num==1
                s=1/(1+exp(-2*Velocity(i,j))); %S1 transfer function
            end
            if BPSO_num==2
                s=1/(1+exp(-Velocity(i,j)));   %S2 transfer function              
            end
            if BPSO_num==3
                s=1/(1+exp(-Velocity(i,j)/2)); %S3 transfer function              
            end
            if BPSO_num==4
               s=1/(1+exp(-Velocity(i,j)/3));  %S4 transfer function
            end            
            
            if BPSO_num<=4 %S-shaped transfer functions
                if rand<s % Equation (4) and (8)
                    Position(i,j)=1;
                else
                    Position(i,j)=0;
                end
            end
           
        end
        if Position(i,:)==zeros(1,D);
                Position(i,randi([1,D],1,1))=1;
%         else if Position(i,:)==ones(1,D);
%                  Position(i,randi([1,D],1,1))=0;
            end
    end

    end
 
%ConvergenceCurve(l)=gBestScore;
end
%figure(1)
%plot(ConvergenceCurve);%绘制最优适应度轨迹
% title('Convergence graph for balance');
% xlabel('iteration number');
 %ylabel('fitness of gBest');



