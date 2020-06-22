function [result,trail] = get_Trail(data,idsNAN)
%get_Trail()��������˲���ֶ�
%input��
%       data�����������ֶε�����
%       idsNAN�����ݶ��Ƿ���Ч
%output:
%       result�����˲������ݶ�
%       trail�����ֵ�trailʱ�䷶Χ��N*[��ʼ���ݱ�ţ��������ݱ��]��
%           ����N��trail��ʱ�䷶Χ��

fc = 250;                   %����Ƶ��
wn = [1*2 50*2]/fc;         %1-50HZl�˲�
[k,l] = butter (2,wn);      %������˹�˲�����4���˲���
result = filtfilt(k,l,double(data));
trail = [];

len = length(idsNAN)-1;
for i=0:len
    if idsNAN(i+1,1)==0     %������Ч������ӷֶ�
        trail = [trail;i*10*fc+1,(i*10+30)*fc];
    end
end

end
