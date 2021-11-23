% Max Wang @April 6, 2021
% SCNS hw3, question 1, single- and multiple- spike-triggered average

load('c1p8.mat')
t=[1:150].*2;%ms
%% question 1-1, single-spike triggered average
j=0;
for i=150:length(stim)
    if rho(i)==1
        j=j+1;
    end
end
%result: j=53583,52583 '1' in rho

snglec=zeros(j,150);
j=0;
for i=150:length(stim)
    if rho(i)==1
        j=j+1;
        snglec(j,:)=stim((i-149):i);
    end
end
sngle=mean(snglec);
plot(t,sngle);
xlabel('time(ms)');
ylabel('stimulus');
title('single-spike triggered average');
%% question 1-2, paired-spikes
subplot
for k=1:50
    m=zeros(1,k+1);
    m(1)=1;
    m(k+1)=1;
    tri=find(conv(rho, m) == 2);

    pairedc=zeros(length(tri),150);
    j=0;
    for i=1:length(tri)
        if tri(i)>=150
            pairedc(i,:)=stim((tri(i)-149):tri(i));
            j=j+1;
        end
    end
    pairedc=pairedc(1:j,:);
    paired=mean(pairedc);
%     r=ceil((k-1)/5)+1;
%     c=mod(k,5);
    subplot(10,5,k) 
    plot(t,paired);
%     xlabel('ms');
%     ylabel('stimulus');
    title(2*k);
end