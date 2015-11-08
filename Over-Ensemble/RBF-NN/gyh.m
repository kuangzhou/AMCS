function data=gyh(data)
%数据归一化
  A=minmax((data)');  %最小和最大
  B=size(data);   %行列数
  for j=1:B(2)%列数4
      for i=1:B(1)%行数31
          if A(j,1)==A(j,2)
              data(:,j)=1;
              break
          end
          data(i,j)=(data(i,j)-A(j,1))/(A(j,2)-A(j,1));
      end
  end
  return