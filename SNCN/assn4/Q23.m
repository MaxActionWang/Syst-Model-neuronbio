clear,
load('indy_20160921_01.mat')
%load('indy_20161212_02.mat')
firingRate=count_firing_rates(t, spikes);
kineRes=kinematics(finger_pos);
xVel=kineRes{2,1};
yVel=kineRes{2,2};
cosFitRes=fitCos(xVel,yVel,firingRate);
C=zeros(96,4);
c=1;
angles=[];
for i=1:96
    for j=1:4 
        tempNum=cosFitRes{i,j};
        if isempty(tempNum)
            C(i,j)=0;
        else
            if abs(tempNum(1))>0.4 && abs(tempNum(2)-1)<0.5
                C(i,j)=1;
                angles(c)=tempNum(5);
                c=c+1;
            end
        end
    end
end

sinAngles=sind(angles);
cosAngles=cosd(angles);

theta=0:pi/20:2*pi; 
x=cos(theta);
y=sin(theta);

plot(x,y,'-')
hold on
P=plot(cosAngles,sinAngles,'o');
hold off
xlabel('cos(theta)');
ylabel('sin(theta)');
title('Distribution of preferred directions @2016.09');
legend(P,'Preferred direction')
axis equal

function cosFitRes=fitCos(xVel,yVel,firingRate)
totalTime=length(xVel);
velAngle=calVelAngle(xVel,yVel,totalTime);

x=0:360;
x=x';
p=fittype('a*cosd(b*x-c)+d','independent','x');

cosFitRes=cell(95,4);
for i=1:96
    for j=1:4
        if isempty(firingRate{i,j})
            cosFitRes{i,j}=[];
        else
            firingRateTemp=firingRate{i,j};
            avgFirRate=aver_fir(firingRateTemp,totalTime,velAngle);
            stp=[1,1,1,mean(avgFirRate)];
            f=fit(x,avgFirRate,p,'StartPoint',stp);
            A=f.a;
            B=f.b;
            C=f.c;
            D=f.d;
            t=0:0.1:360;
            y=A*cosd(B*t-C)+D;
            M=max(y);
            theta=0;
            for k=1:3601
                if y(k)==M
                    theta=(k-1)/10;
                end
            end
            cosFitRes{i,j}=[A,B,C,D,theta];    
        end
    end
end

function avgFirRate=aver_fir(firingRateTemp,totalTime,velAngle)
avgFirRate=zeros(361,1);
for ii=0:360
    cnt=0;
    for jj=1:totalTime
        if velAngle(jj)==ii
            avgFirRate(ii+1)=avgFirRate(ii+1)+firingRateTemp(jj);
            cnt=cnt+1;
        end
    end
    if(avgFirRate(ii+1)~=0)
        avgFirRate(ii+1)=avgFirRate(ii+1)/cnt;
    end
end
avgFirRate=smooth(avgFirRate,5);
end

function velAngle=calVelAngle(xVel,yVel,totalTime)
velAngle=zeros(totalTime,1);
for s=1:totalTime
    if(xVel(s)>0 && yVel(s)>0)
        velAngle(s)=atan(yVel(s)/xVel(s));
    end
    if(xVel(s)>0 && yVel(s)<0)
        velAngle(s)=2*pi-atan(abs(yVel(s)/xVel(s)));
    end
    if(xVel(s)<0 && yVel(s)>0)
        velAngle(s)=pi-atan(abs(yVel(s)/xVel(s)));
    end
    if(xVel(s)<0 && yVel(s)<0)
        velAngle(s)=pi+atan(yVel(s)/xVel(s));
    end
    if(xVel(s)==0 && yVel(s)>0)
        velAngle(s)=pi/2;
    end
    if(xVel(s)==0 && yVel(s)<0)
        velAngle(s)=-pi/2;
    end
    if(xVel(s)>0 && yVel(s)==0)
        velAngle(s)=2*pi;
    end
    if(xVel(s)<0 && yVel(s)==0)
        velAngle(s)=pi;
    end
    if(xVel(s)==0 && yVel(s)==0)
        velAngle(s)=0;
    end
end
velAngle=ceil(velAngle.*180./pi);
end

end