%% This script can generate sound trains meeting the requirement of assignment 2 in course-SCNS.
% Minxing Wang, Mar 22, 2021
% Audio generation part refers to TA Yichao Li

srate = 20000; %Hz
click_t = 1e-4; %s
click_len = int32(click_t * srate);

total_time = 1; %s
t_len = int32(total_time * srate);
ICI = [10:10:100];
seq = zeros(10,t_len);
for i = 1 : 10
    locs=t_len/ICI(i);
    for j=1:t_len
        if mod(j,locs)==0
            seq(i,j+1:j+click_len)=1;
        end
    end
end

str=randperm(100);
str=mod(str,10);
str=str+1;
for i=1:100
    soundsc(seq(str(i),:), srate);
    pause(3);
end

%% function curve plotting part
x=ICI;
y=[1 1 0.8 1 1 0.8 0.8 0.6 0.7 0.6];
plot(x,y)
ylim([0 1])
xlabel('freq/Hz')
ylabel('disecrete probability')

%% 