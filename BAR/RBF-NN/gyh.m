function data=gyh(data)
%���ݹ�һ��
  A=minmax((data)');  %��С�����
  B=size(data);   %������
  for j=1:B(2)%����4
      for i=1:B(1)%����31
          if A(j,1)==A(j,2)
              data(:,j)=1;
              break
          end
          data(i,j)=(data(i,j)-A(j,1))/(A(j,2)-A(j,1));
      end
  end
  return