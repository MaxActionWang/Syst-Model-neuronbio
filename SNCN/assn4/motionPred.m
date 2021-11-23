%% SCNS homework 4, motion prediction with electro-physiologyS
% codes NOT originally created by Minxing Wang @June 4, 2021
% UTF-8

%% data loading
load('indy_20160921_01.mat');
%I2=load('indy_20161212_02.mat');
%L5=load('loco_20170301_05.mat');

%% spike rate acquisition
%利用农宇涵提供的count_firing_rates函数进行发放数量统计
% t_bin=(t(1):0.064:t(end));
% spikes{:, 1};
% for i = 1:96
%     for j = 1:length(spikes{i,2})
%     end
% end
firingRate=count_firing_rates(t, spikes);

%% motion filtering
%利用农宇涵提供的kinematics将finger_pos的数据进行低通滤波并重采样；
%滤波器函数为ButterLP，为本人完成，滤波器参数参考文献Joseph G Makin et al 2018 J. Neural Eng. 15 026010
% l_f = length(finger_pos);
%finger_pos: (z, -x, -y)

n=size(kineRes{1,1},1);
kineRes=kinematics(finger_pos);
firRateMat=zeros(n,384);
kineResMat=zeros(n,6);
kineResMat(:,1)=kineRes{1,1};
kineResMat(:,2)=kineRes{1,2};
kineResMat(:,3)=kineRes{2,1};
kineResMat(:,4)=kineRes{2,2};
kineResMat(:,5)=kineRes{3,1};
kineResMat(:,6)=kineRes{3,2};

for i=1:384
    if mod(i,4)==0
        tempLie=4;
        tempHang=floor(i/4);
    else
        tempLie=mod(i,4);
        tempHang=floor(i/4)+1;
    end
    temp=firingRate{tempHang,tempLie};
    if length(temp)==0
        firRateMat(:,i)=zeros(n,1);
    else
        firRateMat(:,i)=firingRate{tempHang,tempLie};
    end
end
%% 利用线性回归模型预测运动
%linreg函数由农宇涵提供，
load('indy_20160921_01.mat'),
A1=linReg(t,spikes,finger_pos);
load('indy_20160930_05.mat'),
A3=linReg(t,spikes,finger_pos);
load('indy_20161212_02.mat'),
A4=linReg(t,spikes,finger_pos);

firRateMat=firRateMat';
kineResMat=kineResMat';
A=(A1+A3+A4)./3;
Pred=A*firRateMat;

i=600;
j=800;
ttt=i:j;
figure(1)
for a = 1:6
    subplot(2,3,a)
    plot(ttt,kineResMat(1,i:j))
    hold on
    plot(ttt,Pred(1,i:j))
    hold off
    legend('gt','Pred');
    
    if a==4
        ylabel('y')
    end
    if a ==1
        ylabel('x')
    end
    if mod(a,3)==1
        title('position')
    else if mod(a,3)==2
            title('velocity')
        else
            title('acceleration')
        end
    end
    
end
saveas(1, 'motionPred.png');

rSquare=zeros(1,6);
SNR=zeros(1,6);
for i=1:6
    rtemp=corrcoef(kineResMat(i,:),Pred(i,:));
    rSquare(i)=(rtemp(1,2))^2;
    SNR(i)=-10*log10(1-rSquare(i));
end