% Max Wang @April 6, 2021
% SCNS hw3, question 2, 2D-averaged stimuli
load('c2p3.mat')
stim=double(stim);
n=length(counts)/12;

img=zeros(16,16,12);
wimg=zeros(16,16,length(counts));
for i=1:12
    for j=ceil(n*(i-1))+1:ceil(n*i)
        wimg(:,:,j)=stim(:,:,j).*counts(j);
    end
    img(:,:,i)=sum(wimg(:,:,ceil(n*(i-1))+1:ceil(n*i)),3)./sum(counts(ceil(n*(i-1))+1:ceil(n*i)));
    subplot
    subplot(3,4,i)
    imagesc(img(:,:,i))
    title(i)  
end


seq=mean(img,1);
sq=zeros(16,12);
for i=1:16
    for j=1:12
        sq(i,j)=seq(1,i,j);
    end
end
subplot(1,1,1)
imagesc(sq);
xlabel('time step')
ylabel('angle')
colorbar