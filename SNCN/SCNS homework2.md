# SCNS: homework2

> 王敏行 2018012386 wangmx18@mails.tsinghua.edu.cn

## assignment 1



1. | $f/Hz$ | 10   | 20   | 30   | 40   | 50   |
   | ------ | ---- | ---- | ---- | ---- | ---- |
   | $P_0$  | 1    | 1    | 0.8  | 1    | 1    |
   | $f$/Hz | 60   | 70   | 80   | 90   | 100  |
   | $P_0$  | 0.8  | 0.8  | 0.6  | 0.7  | 0.6  |
   
2. ![curve](D:\本科\系统与计算神经\hw2\SCNS2021_HW2\curve.png)

3. This experiment is not so successful as expected, potentially because **the volunteer(it's me) knew that all the train are discrete** . And **discreteness-to-continuousness boundary** cannot be calculated precisely.



Code is attached below. The Matlab file(`.m`) is also included in the zip-pack.

```matlab
%% This script can generate sound trains meeting the requirement of assignment 2 in course-SCNS.
% Minxing Wang, Mar 22, 2021
% Audio generation part refers to TA Yichao Li

srate = 20000; %Hz
click_t = 1e-4; %s
click_len = int32(click_t * srate);

total_time = 1; %s
t_len = int32(total_time * srate);
ICI = [10:10:100];
seq = zeros(10,t_len);
for i = 1 : 10
    locs=t_len/ICI(i);
    for j=1:t_len
        if mod(j,locs)==0
            seq(i,j+1:j+click_len)=1;
        end
    end
end

str=randperm(100);
str=mod(str,10);
str=str+1;
for i=1:100
    soundsc(seq(str(i),:), srate);
    pause(3);
end
```



## assignment 2

1. 
$$
\\
P_{hit}=
\begin{cases}
1&\beta<10\\
{P_{ICI}>\beta}=\frac{14-\beta}{14-10}&10<\beta<14\\
0&\beta>14\\
\end{cases}
\\
\\
P_{FA}=
\begin{cases}
1&\beta<7.5\\
{P_{ICI}>\beta}=\frac{12.5-\beta}{12.5-7.5}&7.5<\beta<12.5\\
0&\beta>12.5\\
\end{cases}
\\
$$

| $\beta$   | 6    | 7    | 8    | 9    | 10   | 11   | 12   | 13   | 14   | 15   |
| --------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| $P_{hit}$ | 1    | 1    | 1    | 1    | 1    | 0.75 | 0.5  | 0.25 | 0    | 0    |
| $P_{FA}$  | 1    | 1    | 0.9  | 0.7  | 0.5  | 0.3  | 0.1  | 0    | 0    | 0    |

2. 
$$
P_{hit}=
\begin{cases}
1&\beta<11\\
{P_{ICI}>\beta}=\frac{15-\beta}{15-11}&11<\beta<15\\
0&\beta>15\\
\end{cases}
$$

| $\beta$   | 6    | 7    | 8    | 9    | 10   | 11   | 12   | 13   | 14   | 15   |
| --------- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- | ---- |
| $P_{hit}$ | 1    | 1    | 1    | 1    | 1    | 1    | 0.75 | 0.5  | 0.25 | 0    |
| $P_{FA}$  | 1    | 1    | 0.9  | 0.7  | 0.5  | 0.3  | 0.1  | 0    | 0    | 0    |

根据上表，我们得到了不同B条件下的ROC。可以看出 A和B的ICI分布分得越开，理想接收者分辨A、B的能力越强（ROC曲线下面积越大）。
![ROC](D:\本科\系统与计算神经\hw2\SCNS2021_HW2\ROC.png)