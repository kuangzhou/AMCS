function tree = ordi_TrainFun(patterns, targets) 
%Build a tree recursively 
%  patterns     - Train patterns, (the number of features) * (the numberofsamples)�������ԣ�������������  
%  targets	    - Train targets, 1*(the number of samples) ����������
%  ebs     - ֹͣ���֣������ǰ�ڵ���������Ե����������ϢС�ڵ���ֵ 
%ebs=input('Please input the value of ebs');
%  orig_traindata      =load('[002]breast(0-1).txt');
%  rem_traindata       =orig_traindata(:,1:end-1);
%  patterns      =rem_traindata'; % the features of the ordinal train data.
%  targets       =orig_traindata(:,end)'; % the targets of the ordinal train data.
ebs=-1;
% patterns=[1 2 3 1;0.1 0.2 0.3 0.1;10 12 14 12 ];
% targets=[1 2 1 3];
[Ni, L]    					= size(patterns);%��A��һ��������size(A)ֱ����ʾ��A�Ĵ�С�������ans=3 4;s=size(A)����һ��������s,s�ĵ�һ��Ԫ���Ǿ����������
                                              %�ڶ���Ԫ���Ǿ���������������s=3 4;[r,c]=size(A),������A���������ص���һ���������r,��������������ص��ڶ����������c,�����r=3,c=4 
Uc         					= unique(targets); %������һ�������е��ظ�Ԫ��ȥ��
tree.dim					= 0; %��ǰ�ڵ���ѡ�Ļ�������
tree.split_loc				= inf;%����� 

if isempty(patterns) %�жϾ����Ƿ�Ϊ��
    return;          % return��ʾ�˳�if���
end 
 
%ֹͣ���� �� ����������һ�� ���߷�����ͬ
if (( L == 1) | (length(Uc) == 1)) 
    tempvec1=zeros(1,length(Uc)); %����һ��ȫ�����
    for ii=1:length(Uc) 
        tempvec1(ii)=length(find(targets==Uc(ii))); %find�������ڷ�������ҪԪ�ص�����λ��
        %��λ�õ��ж����ھ����У���һ�п�ʼ�����϶��£�����Ϊ1,2,3����Ȼ���ٴӵڶ��У���������������������
        %find(A)���ؾ���A�з���Ԫ������λ�ã��磺A=[1 0 4 -3 0 0 0 8 6];X=find(A),X=1 3 4 8 9.find(A>5)���ؾ����д���5��Ԫ������λ�ã�ans=8 9.
    end %����tempvec1�е�Ԫ�ر�ʾ��ǰ�ڵ㴦��ÿ������������������������ĸ�����
    [m, largest] = max(tempvec1); % m ��ʾ���о���tempvec1��Ԫ�ص����ֵ��largest��ʾ���Ԫ�����ڵ��к�����
                                  %������Uc=[class1,class2,class3];tempvec1=[4,10,30]
    tree.child	 = Uc(largest); % ���������Ԫ�ص������Ϊ��Ҷ�ڵ�����
    disp('This is a leaf node. Its lable is: ');
    disp(tree.child);
   return;
end % ��if-end�����������жϳ�ĳ�ڵ��Ƿ�ΪҶ�ڵ㣬��������Ҷ�ڵ����������


P=zeros(L,4);
delta_Ib    = zeros(1, Ni); %�¶���Ni������
split_loc	= ones(1, Ni)*inf; %�������Եķָ��
I=zeros(1,L);
for i=1:Ni
    data	= patterns(i,:);
    for j=1:L
       indices3=find(patterns(i,:)<=patterns(i,j));
       data(indices3)=1;
       indices4=find(patterns(i,:)>patterns(i,j));
       data(indices4)=2;
       for k=1:L
          P(k,1) =length(find(data>=data(k)));
          P(k,2)=length(find(targets>=targets(k)));
          P(k,3)=length(find(data>=data(k) & targets>=targets(k)));
          P(k,4)=log2(P(j,1)*P(j,2))/(L*P(j,3));
          %I(j) =-sum(log(P(j,4)/log(2)))/L;
       end
       M=sum(P);
       mm=M(4);
       I(j)=-mm/L;
    end 
     [delta_Ib(i), s] = max(I); %��������Ե����������Ϣ������λ��
     split_loc(i) = patterns(i,s); %<=threshold vs. >threshold ����λ�õ����Ե�ֵ
end 
[m, dim]    = max(delta_Ib); %�������������Ϣ�����ǵڼ�������

%ֹͣ���������������ϢС����ֵ
if(m<ebs)
   tempvec1=zeros(1,length(Uc)); 
    for ii=1:length(Uc) 
        tempvec1(ii)=length(find(targets==Uc(ii))); 
    end 
    [m, largest] = max(tempvec1); 
    tree.child	 = Uc(largest); % ���������Ԫ�ص������Ϊ��Ҷ�ڵ�����
    disp('This is a ebs node. Its lable is: ');
    disp(tree.child);
    return;
end     

disp(dim);
disp(split_loc(dim));
    tree.dim    = dim; %�ڼ���������Ϊ��������
    tree.split_loc	= split_loc(dim); 
    indices1		   	= find(patterns(dim,:) <= split_loc(dim)); 
    indices2	   		= find(patterns(dim,:) >split_loc(dim)); 
    tree.child(1)	= ordi_TrainFun(patterns(:,indices1), targets(:,indices1)); 
    tree.child(2)	= ordi_TrainFun(patterns(:,indices2), targets(:,indices2)); 
 
