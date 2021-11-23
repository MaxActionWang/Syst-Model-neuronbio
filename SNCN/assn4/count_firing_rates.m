function firingRate=count_firing_rates(t, spikes)
channelNumTotal=size(spikes);
channelNum=channelNumTotal(1);
window=0.064;
Freq=250;
deltaT=1/Freq;
totalTime=length(t);
totalWin=ceil(totalTime*deltaT/window);
minFirCnt=(t(totalTime)-t(1))*2;
firingRate=cell(channelNum,4);
for i=1:channelNum
    for j=1:4
        spikeTemp=spikes{i,j+1};
        if length(spikeTemp)<minFirCnt
            firingRate{i,j}=[];
        else
            tempFirCnt=zeros(totalWin,1);
            pointer=1;
            while(spikeTemp(pointer)<t(1))
                pointer=pointer+1;
            end
            for k=1:totalWin
                tempCnt=0;
                if pointer>length(spikeTemp)
                    tempFirCnt(k)=0;
                else
                    while(spikeTemp(pointer)<t(16*k-15))
                        pointer=pointer+1;
                    end
                    while(spikeTemp(pointer)<(t(16*k-15)+window))
                        tempCnt=tempCnt+1;
                        pointer=pointer+1;
                        if pointer>length(spikeTemp)
                            break;
                        end
                    end
                    tempFirCnt(k)=tempCnt;
                end
            end
            firingRate{i,j}=smooth(tempFirCnt./window,10);
            %firingRate{i,j}=tempFirCnt./window;
        end
    end
end
% ttt=1:5628;
% bar(ttt,firingRate{4,2})
% hold on
% bar(ttt,smooth(firingRate{4,2},10))
% hold off
            
