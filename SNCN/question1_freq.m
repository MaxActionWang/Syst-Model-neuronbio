%% parameters initialization
load('R15N111_Raw.mat')

f0 = 24414.0625; %Hz
t = [1:length(wave)]';
t = t./f0; %s
% plot(t, wave);
% xlim([0 t(length(t))]);
% histogram(wave)
% ylim([0 1000])

%% spike source sorting by amplitude
thr1=40;
thr2=75;

wave1=single(wave);
[pks, locs] = findpeaks(wave1, t, 'MinPeakHeight',40);
% hold on
% plot(locs, pks,'o')
% hold off

j=1; k=1;
for i=1:length(locs)
    if pks(i)>thr1 && pks(i)<thr2
        unit1(j) = locs(i);
        j=j+1;
    else if pks(i)>thr2
        unit2(k) = locs(i);
        k = k+1;
        end
    end
end
        
% load('R15N111_Spikes.mat') 
%%  to show the sorting result
% unit1N=ceil(unit1.*f0);
% unit2N=ceil(unit2.*f0);
% 
% spike1=zeros(1,length(wave));
% for i=1:length(unit1N)
%     spike1(unit1N(i)) = wave(unit1N(i));
% end
% spike2=zeros(1,length(wave));
% for i=1:length(unit2N)
%     spike2(unit2N(i)) = wave(unit2N(i));
% end
% 
% subplot
% subplot(2,1,1)
% plot(t, spike1)
% xlabel('time(sec)')
% ylabel('response of neuron1')
% subplot(2,1,2)
% plot(t, spike2)
% xlabel('time(sec)')
% ylabel('response of neuron2')
%% tuning curve 
load('R15N111_Stimulus.mat')
n = length(freqs);
spknum1=zeros(1,n);
j = 1;
for i=1:length(unit1)
    if unit1(i)> sti_onset(j)+0.05 && j <=n-1
        j=j+1;
    end
    if unit1(i)>= sti_onset(j) && unit1(i)<=(sti_onset(j)+0.05)
        spknum1(j)= spknum1(j)+1;
    end
end
spknum1=spknum1';
spknum2=zeros(1,n);
j = 1;
for i=1:length(unit2)
    if unit2(i)> sti_onset(j)+0.25 && j <=n-1
        j=j+1;
    end
    if unit2(i)>= sti_onset(j) && unit2(i)<=(sti_onset(j)+0.25)
        spknum2(j)= spknum2(j)+1;
    end
end
spknum2=spknum2';

tb=table(freqs,levels,spknum1,spknum2);
tb = sortrows(tb,{'levels','freqs'},{'ascend','ascend'});

% subplot
% title('')
% subplot(3,1,1)
% plot(tb.freqs(1:21),tb.spknum1(1:21),'*')
% title('tuning curve of neuron1  0 dB SPL')
% 
% subplot(3,1,2)
% plot(tb.freqs(85:105),tb.spknum1(85:105),'*')
% title('20 dB SPL')
% ylabel('spike number in 50 ms')
% 
% subplot(3,1,3)
% plot(tb.freqs(169:189),tb.spknum1(169:189),'*')
% xlabel('freqency (Hz)')
% title('40 dB SPL')
% 
% subplot
% title('')
% subplot(3,1,1)
% plot(tb.freqs(1:21),tb.spknum2(1:21),'-*')
% title('tuning curve of neuron2  0 dB SPL')
% 
% subplot(3,1,2)
% plot(tb.freqs(85:105),tb.spknum2(85:105),'-*')
% title('20 dB SPL')
% ylabel('spike number in 50 ms')
% 
% subplot(3,1,3)
% plot(tb.freqs(169:189),tb.spknum2(169:189),'-*')
% xlabel('freqency (Hz)')
% title('40 dB SPL')
%% heatmap generation with the help from Yuhan Nong about function 'imagesc' selection
uni1=(tb.spknum1(1:21));
for i = 1:8
    uni1= [uni1 tb.spknum1((21*i+1):(21*i+21))];
end
uni1=uni1';
uni2=(tb.spknum1(1:21));
for i = 1:8
    uni2= [uni2 tb.spknum2((21*i+1):(21*i+21))];
end
uni2=uni2';
% hm1=plot3(tb.freqs, tb.levels, tb.spknum1,'o');
% imagesc(tb.freqs, tb.levels, tb.spknum1)

x=tb.freqs(1:21);
y=[0:5:40];
clims=[0:20];
imagesc(x,y,uni2);%% 
colorbar
xlabel('freqs(Hz)')
ylabel('dB SPL')
title('neuron2')
% contour(freqs,levels,spknum1,10)