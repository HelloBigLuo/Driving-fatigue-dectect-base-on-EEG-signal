function [feature] = get_Feature(data,trail)
%get_Feature()函数获取数据段特征
%input： 
%       data：代处理，代分段的数据
%       trail：划分的trail时间范围,N*2
%output: 
%       feature：该数据提取的特征，每一个trail段可以
%             提取30个特征，N个trial，为N*30

feature = [];   

len = trail(1,2)-trail(1,1);%数据段长度，固定
window=boxcar(len);
Nfft=2^ceil(log2(len)); %fft的点数，2的整数幂
fs = 250;   %采样频率

for i=1:length(trail)  %每个trail段
    averange = [];
    for j = 1:30  %每个通道
        xn = data(j,trail(i,1):trail(i,2)); %数据段
        [Pxx f]=pwelch(xn,window,[],Nfft,fs);%提取功率谱
        Pxxx = 10*log10(Pxx);   %功率谱换成db
        index = find(f>4&f<7);  
        averange = [averange,mean(Pxxx(index))];%4-7Hz平均功率
    end
    feature = [feature;averange];
end

end