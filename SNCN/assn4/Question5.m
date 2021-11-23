clear,
load('indy_20160930_02.mat')
firingRate=count_firing_rates(t, spikes);
kineRes=kinematics(finger_pos);
xVel=kineRes{2,1};
yVel=kineRes{2,2};
tttt=2000:3000;
temp=firingRate{27,1};
plot(tttt,xVel(2000:3000)./(max(xVel)))
hold on
bar(tttt,temp(2000:3000)./(max(temp)))
hold off
xlabel('Time Window (0.064s)');
legend('x Velocity','Firing Rate')