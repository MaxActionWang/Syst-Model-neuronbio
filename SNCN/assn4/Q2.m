clear
load('indy_20160921_01.mat'),
firingRate=count_firing_rates(t, spikes);
kineRes=kinematics(finger_pos);
xVel=kineRes{2,1};
yVel=kineRes{2,2};
totalTime=length(xVel);
velAngle=zeros(totalTime,1);
for i=1:totalTime
    if(xVel(i)>0 && yVel(i)>0)
        velAngle(i)=atan(yVel(i)/xVel(i));
    end
    if(xVel(i)>0 && yVel(i)<0)
        velAngle(i)=2*pi-atan(abs(yVel(i)/xVel(i)));
    end
    if(xVel(i)<0 && yVel(i)>0)
        velAngle(i)=pi-atan(abs(yVel(i)/xVel(i)));
    end
    if(xVel(i)<0 && yVel(i)<0)
        velAngle(i)=pi+atan(yVel(i)/xVel(i));
    end
    if(xVel(i)==0 && yVel(i)>0)
        velAngle(i)=pi/2;
    end
    if(xVel(i)==0 && yVel(i)<0)
        velAngle(i)=-pi/2;
    end
    if(xVel(i)>0 && yVel(i)==0)
        velAngle(i)=2*pi;
    end
    if(xVel(i)<0 && yVel(i)==0)
        velAngle(i)=pi;
    end
    if(xVel(i)==0 && yVel(i)==0)
        velAngle(i)=0;
    end
end
velAngle=ceil(velAngle.*180./pi);

x=0:360;
x=x';
p=fittype('a*cosd(b*x-c)+d','independent','x');

firingRateTemp=zeros(length(xVel),10);
firingRateTemp(:,1)=firingRate{1,2};
firingRateTemp(:,2)=firingRate{9,1};
firingRateTemp(:,3)=firingRate{66,1};
firingRateTemp(:,4)=firingRate{31,1};
firingRateTemp(:,5)=firingRate{12,2};
firingRateTemp(:,6)=firingRate{62,3};
firingRateTemp(:,7)=firingRate{33,2};
firingRateTemp(:,8)=firingRate{18,2};
firingRateTemp(:,9)=firingRate{68,2};
firingRateTemp(:,10)=firingRate{24,1};
stp=zeros(10,4);
stp(1,:)=[3,0.5,0,5];
stp(2,:)=[1,1,1,1];
stp(3,:)=[1,1,1,1];
stp(4,:)=[1,1,1,1];
stp(5,:)=[3,1,1,10];
stp(6,:)=[2,1,1,5];
stp(7,:)=[3,1,1,15];
stp(8,:)=[2,1,0,6];
stp(9,:)=[1,1,1,10];
stp(10,:)=[3,0.5,0,5];


for j=1:10
    avgFirRate=aver_fir(firingRateTemp(:,j),totalTime,velAngle);
    f=fit(x,avgFirRate,p,'StartPoint',stp(j,:));
    A=f.a;
    B=f.b;
    C=f.c;
    D=f.d;
    t=0:0.1:360;
    y=A*cosd(B*t-C)+D;
    M=max(y);
    theta=0;
    for i=1:3601
        if y(i)==M
            theta=(i-1)/10;
        end
    end
    subplot(2,5,j);
    bar(x,avgFirRate)
    hold on
    plot(f)
    hold on
    plot(theta,M,'go')
    hold off
    xlabel('Angle (Degree)');
    ylabel('Average Firing Rate');
    title(['theta=',num2str(theta)]);
    legend('hide')
end

function avgFirRate=aver_fir(firingRateTemp,totalTime,velAngle)
avgFirRate=zeros(361,1);
for i=0:360
    cnt=0;
    for j=1:totalTime
        if velAngle(j)==i
            avgFirRate(i+1)=avgFirRate(i+1)+firingRateTemp(j);
            cnt=cnt+1;
        end
    end
    if(avgFirRate(i+1)~=0)
        avgFirRate(i+1)=avgFirRate(i+1)/cnt;
    end
end
avgFirRate=smooth(avgFirRate,5);
end