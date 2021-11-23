function A=linReg(t,spikes,finger_pos)
firingRate=count_firing_rates(t, spikes);
kineRes=kinematics(finger_pos);
xPos=kineRes{1,1};
yPos=kineRes{1,2};
xVel=kineRes{2,1};
yVel=kineRes{2,2};
xAcc=kineRes{3,1};
yAcc=kineRes{3,2};
firRateMat=zeros(length(xPos),384);
kineResMat=zeros(length(xPos),6);

kineResMat(:,1)=xPos;
kineResMat(:,2)=yPos;
kineResMat(:,3)=xVel;
kineResMat(:,4)=yVel;
kineResMat(:,5)=xAcc;
kineResMat(:,6)=yAcc;
for i=1:384
    if mod(i,4)==0
        tempLie=4;
        tempHang=floor(i/4);
    else
        tempLie=mod(i,4);
        tempHang=floor(i/4)+1;
    end
    temp=firingRate{tempHang,tempLie};
    if isempty(temp)
        firRateMat(:,i)=zeros(length(xPos),1);
    else
        firRateMat(:,i)=firingRate{tempHang,tempLie};
    end
end
firRateMat=firRateMat';
kineResMat=kineResMat';
A=kineResMat*(firRateMat')*pinv((firRateMat*firRateMat'));

