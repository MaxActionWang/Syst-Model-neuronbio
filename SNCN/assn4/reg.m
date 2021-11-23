%% 数据预处理
load('indy_20160921_01.mat')
empty_pos = cellfun('isempty',spikes);
nCount = 0;
for i = 1:length(spikes)
    for j = 1:length(spikes(i,:))
        if empty_pos(i,j)==0
            nCount = nCount + 1;
            neuros(nCount) = spikes(i,j);
        end
    end
end
neuros = neuros';
%每个神经元平均发放率
spike_num = cellfun(@length,neuros);
spike_rate=spike_num/370;
neuros(spike_rate < 0.5) = [];%丢弃放电次数过少的神经元。

Fs = 500; % Sampling Frequency
N = 5; % Order
Fc = 1; % Cutoff Frequency
flag = 'scale'; % Sampling Flag
win = hamming(N+1);% Create the window vector for the design algorithm.
b = fir1(N, Fc/(Fs/2), 'low', win, flag);% Calculate the coefficients using the FIR1 function.
Hd = dfilt.dffir(b);

figure(1)
plot(t(1:200),finger_pos(1:200,1),'r');%画出输入信号图形
title('输入信号');
hold on;
fpx = filter(Hd,finger_pos(1:end,1));%通过filter函数将信号y送入参数为Hd的滤波器
plot(t(6:200),fpx(6:200),'b');%画出输入信号图形

figure(2)
plot(t,finger_pos(:,2),'r');%画出输入信号图形
title('输入信号');
hold on;
fpy = filter(Hd,finger_pos(:,2));%通过filter函数将信号y送入参数为Hd的滤波器
plot(t,fpy(6:end),'b');

velocity_x = zeros(length(fpx)-1,1);
for i=1:length(fpx)-1
    velocity_x(i) = (fpx(i+1)-fpx(i))/(t(i+1)-t(i));
end

accelerate_x = zeros(length(fpx)-2,1);
for i=1:length(fpx)-2
    accelerate_x(i) = (velocity_x(i+1)-velocity_x(i))/(t(i+1)-t(i));
end

velocity_y = zeros(length(fpy)-1,1);
for i=1:length(fpy)-1
    velocity_y(i) = (fpy(i+1)-fpy(i))/(t(i+1)-t(i));
end

accelerate_y = zeros(length(fpy)-2,1);
for i=1:length(fpy)-2
    accelerate_y(i) = (velocity_y(i+1)-velocity_y(i))/(t(i+1)-t(i));
end
newfpx = resample(fpx(5:end),1431,90038);
newfpx = newfpx(2:end);
newfpy = resample(fpy(6:end),1430,90038);
newvelocity_x = resample(velocity_x(6:end),1430,90037);
newvelocity_y = resample(velocity_y(6:end),1430,90037);
newacce_x = resample(accelerate_x(6:end),1430,90036);
newacce_y = resample(accelerate_y(6:end),1430,90036);





for i =1:length(neuros)
    index = 1;
    nCount2 = 1;
    j = 1;
    while true 
        while neuros{i}(nCount2) -neuros{i}(index) < 0.2 && nCount2 < length(neuros{i})
            nCount2 = nCount2 + 1;
        end
        if nCount2 >= length(neuros{i})
            break;
        end
        rate{i}(j)=(nCount2 - index)/(neuros{i}(nCount2) -neuros{i}(index));
        j = j + 1;
        while neuros{i}(nCount2) -neuros{i}(index) >= 0.4
            rate{i}(j)=rate{i}(j-1);
            neuros{i}(index) = neuros{i}(index) + 0.2;
            j = j + 1;
        end
        index = nCount2;
        display(nCount2);
    end
    rate{i}=rate{i}';
end
rate = rate';

minL =  length(rate{1});
for i = 1:length(rate)
    if minL > length(rate{i})
        minL = length(rate{i});
    end
end
for i = 1:length(rate)
    rate_new{i} = rate{i}(1:minL);
    rate_new{i} = rate_new{i}';
end
rate_new = rate_new';

X = [ones(size(rate_new{1})) rate_new{1}];
for i = 2:length(rate_new)
    X = [X rate_new{i}];
end

%% 1
bfpx = regress(newfpx,X);
bfpy = regress(newfpy,X);
bvx = regress(newvelocity_x,X);
bvy = regress(newvelocity_y,X);
bax = regress(newacce_x,X);
bay = regress(newacce_y,X);

figure(1)
title('利用线性回归解码手部运动参数结果示意')
subplot(2,3,1)
predpx = X(:,2:end)*bfpx(2:end);
plot(newfpx(1:200),'b');
hold on;
plot(predpx(1:200)+mean(newfpx),'r');
title('Position')
ylabel('X')
legend('gt','pred')

subplot(2,3,4)
predpy = X(:,2:end)*bfpy(2:end);
plot(newfpy(1:200),'b');
hold on;
plot(predpy(1:200),'r');
title('Position')
ylabel('Y')
legend('gt','pred')

subplot(2,3,2)
predvx = X(:,2:end)*bvx(2:end);
plot(newvelocity_x(1:200),'b');
hold on;
plot(predvx(1:200),'r');
title('Velocity')
ylabel('X')
legend('gt','pred')

subplot(2,3,5)
predvy = X(:,2:end)*bvy(2:end);
plot(newvelocity_y(1:200),'b');
hold on;
plot(predvy(1:200),'r');
title('Velocity')
ylabel('Y')
legend('gt','pred')

subplot(2,3,3)
predax = X(:,2:end)*bax(2:end);
plot(newacce_x(1:200),'b');
hold on;
plot(predax(1:200),'r');
title('Acceleration')
ylabel('X')
legend('gt','pred')

subplot(2,3,6)
predvy = X(:,2:end)*bvy(2:end);
plot(newvelocity_y(1:200),'b');
hold on;
plot(predvy(1:200),'r');
title('Acceleration')
ylabel('Y')
legend('gt','pred')
saveas(1, '1.jpg'); %保存Figure 2窗口的图像

%% 2
vd = zeros(length(fpx)-1,1);
for i=1:length(fpx)-1
    if fpy(i+1)-fpy(i) >=0 
        if fpx(i+1)-fpx(i)>=0
            vd(i) = 180*(atan((fpy(i+1)-fpy(i))/(fpx(i+1)-fpx(i))))/pi;
        else 
            vd(i) = 180*(atan((fpy(i+1)-fpy(i))/(fpx(i+1)-fpx(i))))/pi + 360;
        end
    else
            vd(i) = 180*(atan((fpy(i+1)-fpy(i))/(fpx(i+1)-fpx(i))))/pi + 180;
    end
end

newvd = zeros(length(newfpx)-1,1);
for i=1:length(newfpx)-1
    if newfpy(i+1)-newfpy(i) >=0 
        if newfpx(i+1) - newfpx(i)>=0
            newvd(i) = 180*(atan((newfpy(i+1)-newfpy(i))/(newfpx(i+1)-newfpx(i))))/pi;
        else 
            newvd(i) = 180*(atan((newfpy(i+1)-newfpy(i))/(newfpx(i+1)-newfpx(i))))/pi + 360;
        end
    else
            newvd(i) = 180*(atan((newfpy(i+1)-newfpy(i))/(newfpx(i+1)-newfpx(i))))/pi + 180;
    end
end

angleCount = ones(50,1);
rate_hist = zeros(50,1);
for i = 1:length(newvd)
    for mod = 1:50
        if newvd(i) > (mod - 1)*7.2 && newvd(i) < mod*7.2
            angleCount(mod) = angleCount(mod) + 1;
            rate_hist(mod) = rate_hist(mod) + rate_new{1}(i);
        end
    end
end
rate_hist = rate_hist./angleCount;
x = 0:7.2:360-7.2;

figure(2)
h = bar(x,rate_hist,1,'b');
xlim([0,360])
xlabel('Angle。')
ylabel('Spikes / time window')
title('\theta = 270。')
set(h,'edgecolor','none');
hold on;
xx = 30:300;
plot(xx,2*cos(4*pi*xx/360 + pi)+4);
line([270,270],[0,12],'linestyle','-','color','r');
saveas(2, '2_1.jpg'); %保存Figure 2窗口的图像




maxAngle = zeros(length(rate_new),1);
for k = 1:length(rate_new)
    angleCount = ones(50,1);
    rate_hist = zeros(50,1);
    for i = 1:length(newvd)
        for mod = 1:50
            if newvd(i) > (mod - 1)*7.2 && newvd(i) < mod*7.2
                angleCount(mod) = angleCount(mod) + 1;
                rate_hist(mod) = rate_hist(mod) + rate_new{k}(i);
            end
        end
    end
rate_hist = rate_hist./angleCount;
[ans,aa] = max(rate_hist);
maxAngle(k)=aa*7.2-3.6;
end

%% 找前50发放率最大的神经

spike_mean= cellfun(@mean,rate_new);
merge = [spike_mean maxAngle];
merge = sortrows(merge,-1);    
angle_plot = 2*pi*merge(1:47,2)/360;
dpd = [cos(angle_plot) sin(angle_plot)];
scatter(dpd(:,1),dpd(:,2),'filled')
line([0,0],[-1.2,1.2],'linestyle',':','color', 'black')
line([-1.2,1.2],[0,0],'linestyle',':','color', 'black')
axis equal
xlim([-1.2,1.2])
ylim([-1.2,1.2])
xlabel('cos\theta')
ylabel('sin\theta')
title('Distrubution of preferred directions')
legend('Preferred direction')


%% 2_1
x = 0:7.2:360-7.2;
figure(2)
h = bar(x,rate_hist,1,'b');
xlim([0,360])
xlabel('Angle。')
ylabel('Spikes / time window')
title('\theta = 167。')
set(h,'edgecolor','none');
hold on;
xx = 1:360;
%plot(xx,3*cos((3/2)*pi*xx/360 - 225/180*pi)+6);
plot(xx,3*cos(2*pi*xx/360 - 175/180*pi)+10);
line([167,167],[0,max(rate_hist)],'linestyle','-','color','r');
saveas(2, '2_10.jpg'); %保存Figure 2窗口的图像



    
    
  