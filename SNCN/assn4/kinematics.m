function kineRes=kinematics(finger_pos)
window=0.064;
Freq=250;
A=finger_pos*[0,0;-10,0;0,-10];
xPos=A(:,1);
yPos=A(:,2);
deltaT=1/Freq;
Hd=ButterLP;
xPosFilter=filter(Hd,xPos);
yPosFilter=filter(Hd,yPos);
totalTime=length(xPos);
xVel=zeros(totalTime,1);
yVel=zeros(totalTime,1);
xAcc=zeros(totalTime,1);
yAcc=zeros(totalTime,1);
xVel(1)=(xPosFilter(2)-xPosFilter(1))/deltaT;
yVel(1)=(yPosFilter(2)-yPosFilter(1))/deltaT;
xVel(totalTime)=(xPosFilter(totalTime)-xPosFilter(totalTime-1))/deltaT;
xVel(totalTime)=(xPosFilter(totalTime)-xPosFilter(totalTime-1))/deltaT;
for i=2:totalTime-1
    xVel(i)=(xPosFilter(i+1)-xPosFilter(i-1))/(2*deltaT);
    yVel(i)=(yPosFilter(i+1)-yPosFilter(i-1))/(2*deltaT);
end
xAcc(1)=(xVel(2)-xVel(1))/deltaT;
yAcc(1)=(yVel(2)-yVel(1))/deltaT;
xAcc(totalTime)=(xVel(totalTime)-xVel(totalTime-1))/deltaT;
yAcc(totalTime)=(yVel(totalTime)-yVel(totalTime-1))/deltaT;
for i=2:totalTime-1
    xAcc(i)=(xVel(i+1)-xVel(i-1))/(2*deltaT);
    yAcc(i)=(yVel(i+1)-yVel(i-1))/(2*deltaT);
end
xPosRes=resample(xPosFilter,1000/window,1000*Freq);
yPosRes=resample(yPosFilter,1000/window,1000*Freq);
xVelRes=resample(xVel,1000/window,1000*Freq);
yVelRes=resample(yVel,1000/window,1000*Freq);
xAccRes=resample(xAcc,1000/window,1000*Freq);
yAccRes=resample(yAcc,1000/window,1000*Freq);
kineRes=cell(3,2);
kineRes{1,1}=xPosRes;
kineRes{1,2}=yPosRes;
kineRes{2,1}=xVelRes;
kineRes{2,2}=yVelRes;
kineRes{3,1}=xAccRes;
kineRes{3,2}=yAccRes;
% subplot(1,3,1)
% plot(ttt(1:100),xPosRes(1:100))
% xlabel('Time Window')
% ylabel('x')
% title('Position')
% subplot(1,3,2)
% plot(ttt(1:100),xVelRes(1:100))
% xlabel('Time Window')
% title('Velocity')
% subplot(1,3,3)
% plot(ttt(1:100),xAccRes(1:100))
% title('Acceleration')
% xlabel('Time Window')