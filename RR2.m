function [beta,best_mode_ss,best_mode_lamda] = RR2(data,lable)
% RR2()������ع飬�����ع�ģ�Ͳ��ã������ٴ�ѵ����Σ�ֱ���õ�ģ������Ҫ��
%           ������������������ͷ���
% input��
%     data����������
%     lable��ƣ��ֵ��0-1��
% output��
%     beta���ڻع�ģ���е�beta������
%     best_mode_ss����ǰbeta�µģ������ݵķ����������beta�ĺû�
%     best_mode_lamda���ڻع�ģ���µ�lamdaֵ���������

[beta,best_mode_ss,best_mode_lamda] = RR(data,lable);
for i = 1:5
    if best_mode_ss < 10 %RRģ�ͷ����������˳�
        break;
    end
    [beta,best_mode_ss,best_mode_lamda] = RR(data,lable);
end
end
