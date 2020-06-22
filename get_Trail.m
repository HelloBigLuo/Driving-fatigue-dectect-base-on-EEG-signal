function [result,trail] = get_Trail(data,idsNAN)
%get_Trail()函数完成滤波与分段
%input：
%       data：代处理，代分段的数据
%       idsNAN：数据段是否有效
%output:
%       result：已滤波的数据段
%       trail：划分的trail时间范围，N*[起始数据标号，最终数据标号]，
%           代表N个trail的时间范围。

fc = 250;                   %采样频率
wn = [1*2 50*2]/fc;         %1-50HZl滤波
[k,l] = butter (2,wn);      %巴特沃斯滤波器，4阶滤波器
result = filtfilt(k,l,double(data));
trail = [];

len = length(idsNAN)-1;
for i=0:len
    if idsNAN(i+1,1)==0     %数据有效，则添加分段
        trail = [trail;i*10*fc+1,(i*10+30)*fc];
    end
end

end
