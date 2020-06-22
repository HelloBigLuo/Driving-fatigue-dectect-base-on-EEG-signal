function [feature] = get_Feature(data,trail)
%get_Feature()������ȡ���ݶ�����
%input�� 
%       data�����������ֶε�����
%       trail�����ֵ�trailʱ�䷶Χ,N*2
%output: 
%       feature����������ȡ��������ÿһ��trail�ο���
%             ��ȡ30��������N��trial��ΪN*30

feature = [];   

len = trail(1,2)-trail(1,1);%���ݶγ��ȣ��̶�
window=boxcar(len);
Nfft=2^ceil(log2(len)); %fft�ĵ�����2��������
fs = 250;   %����Ƶ��

for i=1:length(trail)  %ÿ��trail��
    averange = [];
    for j = 1:30  %ÿ��ͨ��
        xn = data(j,trail(i,1):trail(i,2)); %���ݶ�
        [Pxx f]=pwelch(xn,window,[],Nfft,fs);%��ȡ������
        Pxxx = 10*log10(Pxx);   %�����׻���db
        index = find(f>4&f<7);  
        averange = [averange,mean(Pxxx(index))];%4-7Hzƽ������
    end
    feature = [feature;averange];
end

end