load('twobrains.mat')
% % subplot(1,2,1),imagesc(squeeze(brain2(:,100,:))); 
% % colorbar
% % subplot(1,2,2),imagesc(squeeze(brain2(:,100,:)));
% % colorbar
% 
% subplot
% for i =1:3
%     for j=1:3
%         subplot(3,3,i*3+j-3),imagesc(squeeze(brain2(:,20*(i*3+j-3),:)));
%     end
% end
% 
% %统计灰度的分布，看看一共有多少种脑区
% count = zeros(1,5);
% for i = 1:256
%     for j = 1:256
%         for k = 1:256
%             if brain2(i, j, k)>980 &&brain2(i, j, k)<1050
%                 count(1)=count(1)+1;
%             elseif brain2(i, j, k)>2000 &&brain2(i, j, k)<2040
%                 count(2)=count(2)+1;
%                 
%             elseif brain2(i, j, k)>2990 &&brain2(i, j, k)<3040
%                 count(3)=count(3)+1;
%               
%             elseif brain2(i, j, k)>3980 &&brain2(i, j, k)<4040
%                 count(4)=count(4)+1;
%                 
%             elseif brain2(i, j, k)>4090 &&brain2(i, j, k)<5010
%                 count(5)=count(5)+1;
%             end
%         end
%     end
% end
% stem(count);
                
%% 本部分计算了不同脑区的皮层表面积和体积，代码由农宇涵完成
%更改brain1与brain2：将所有brain1均改为brain2即可，共8处。

%计算脑区体积
A=zeros(14175,1);  
for i=1:256
    for j=1:256
        for k=1:256
            a=brain2(i,j,k);     %1，2
            if a==0 
                continue
            else A(a)=A(a)+1;
            end
        end
    end
end


%用lbl记录脑区，用vlm记录该脑区对应体积
t=1;   
for i=1:14175
    if A(i)==0
        continue
    else 
        lbl(t)=i;
        vlm(t)=A(i);
        t=t+1;
    end
end

%计算脑区表面积
len=length(lbl); %有多少种脑区
srf=zeros(len,1);  
for i=1:256
    for j=1:256
        for k=1:256
            a=brain2(i,j,k);  %1，2
            if a==0
                continue
            else  
                for w=1:182
                    if lbl(w)==a
                        break
                    end
                end                            %6个面，每有一个面为0就加1
                if brain2(i-1,j,k)==0   %1，2
                    srf(w)=srf(w)+1;
                end
                if brain2(i+1,j,k)==0  %1，2
                    srf(w)=srf(w)+1;
                end
                if brain2(i,j-1,k)==0  %1，2
                    srf(w)=srf(w)+1;
                end
                if brain2(i,j+1,k)==0  %1，2
                    srf(w)=srf(w)+1;
                end
                if brain2(i,j,k-1)==0   %1，2
                    srf(w)=srf(w)+1;
                end
                if brain2(i,j,k+1)==0  %1，2
                    srf(w)=srf(w)+1;
                end
            end
        end
    end
end

%找出脑区对应lobe
l_frontal=[1003,1012,1014,1018,1019,1020,1022,1024,1027,1028,1032];
l_temporal=[1001,1006,1007,1009,1015,1030,1033,1034];
l_parietal=[1008,1017,1021,1025,1029,1031];
l_occipital=[1005,1011,1013];
r_frontal=l_frontal+1000;
r_temporal=l_temporal+1000;
r_parietal=l_parietal+1000;
r_occipital=l_occipital+1000;
l_cortex=[1000:1003,1005:1035];  %整个大脑皮层
r_cortex=l_cortex+1000;
l_transversetemporal=[1034];  %两个脑区
r_transversetemporal=l_transversetemporal+1000;
l_parsopercularis=[1018];
r_parsopercularis=l_parsopercularis+1000;

%计算体积
% Volume=[sumlobe(lbl,l_frontal,vlm)+sumlobe(lbl,r_frontal,vlm),
% sumlobe(lbl,l_temporal,vlm)+sumlobe(lbl,r_temporal,vlm),
% sumlobe(lbl,l_parietal,vlm)+sumlobe(lbl,r_parietal,vlm),
% sumlobe(lbl,l_occipital,vlm)+sumlobe(lbl,r_occipital,vlm),
% sumlobe(lbl,l_cortex,vlm)+sumlobe(lbl,r_cortex,vlm)];

%计算表面积
Surface=[sumlobe(lbl,l_frontal,srf)+sumlobe(lbl,r_frontal,srf),
    sumlobe(lbl,l_temporal,srf)+sumlobe(lbl,r_temporal,srf),
    sumlobe(lbl,l_parietal,srf)+sumlobe(lbl,r_parietal,srf),
    sumlobe(lbl,l_occipital,srf)+sumlobe(lbl,r_occipital,srf),
    sumlobe(lbl,l_cortex,srf)+sumlobe(lbl,r_cortex,srf)];
%计算transversetemporal，parsopercularis体积
l_transversetemporal_vlm=sumlobe(lbl,l_transversetemporal,vlm);
r_transversetemporal_vlm=sumlobe(lbl,r_transversetemporal,vlm);
l_parsopercularis_vlm=sumlobe(lbl,l_parsopercularis,vlm);
r_parsopercularis_vlm=sumlobe(lbl,r_parsopercularis,vlm);
%% 本部分由本人自己完成
%皮层不同脑区占比
S_portion=Surface(1:4)./Surface(5)

%计算两个脑区的不对称指数
asym_idx_T = 2*(l_transversetemporal_vlm-r_transversetemporal_vlm)/(l_transversetemporal_vlm+r_transversetemporal_vlm)
asym_idx_P = 2*(l_parsopercularis_vlm-r_parsopercularis_vlm)/(l_parsopercularis_vlm+r_parsopercularis_vlm)

%% 加和函数，农宇涵同学完成
function sum_vlmsur=sumlobe(lbl,arr_used, vlmsrf)
len=length(arr_used);
sum_vlmsur=0;
for i=1:len
    for j=1:length(lbl)
        if lbl(j)==arr_used(i)
            sum_vlmsur=sum_vlmsur+vlmsrf(j);
        end
    end
end
end