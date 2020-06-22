function [beta,best_mode_ss,best_mode_lamda] = RR(data,lable)
% RR()������ع�
% input��
%     data����������
%     lable��ƣ��ֵ��0-1��
% output��
%     beta���ڻع�ģ���е�beta������
%     best_mode_ss����ǰbeta�µģ������ݵķ����������beta�ĺû�
%     best_mode_lamda���ڻع�ģ���µ�lamdaֵ���������

iterate_max = 10;%����������
lamdas = -50:0.5:50 ;%��ͬ���ڲ���
mode = [];%��ѵ����õ�ģ��  
mode_ss = [];%ģ�ͷ���
mode_lamda = []; %ģ���ڲ���
satisfy_ss = 0.1; %�������
satisfy_mode = [] ;%����ģ��
satisfy_lamda = [];%����ģ�͵�lamda

for i_ = 1:iterate_max
    len = length(lable);
    index = randi(1,len-100+1,1);   %�����100��������������Ϊѵ����
    train_index = index:index+99;
    test_index = [[1:index-1],[(index+100):len]];
    
    train_x = [];%ѵ����X
    train_y = [];%ѵ����Y
    test_x = [];%���Լ�X
    test_y = [];%���Լ�Y
    
    for i=train_index
        x = data(i,:);
        train_x = [train_x;x]; %ѵ����X
        y = lable(i);
        train_y = [train_y;y]; %ѵ����Y
    end
    for i=test_index
        x = data(i,:);
        test_x = [test_x;x]; %���Լ�X
        y = lable(i);
        test_y = [test_y;y]; %���Լ�Y
    end
    
    temp_T = []; %beta������Ĵ�ѡ��
    temp_ss =[];    
    for lamda = lamdas   %���������
        T = (train_x'*train_x + lamda)^-1*train_x'*train_y; %��ȡbeta
        temp_T = [temp_T;T']; %����beta��ѡ��
        %test
        erro = test_y - test_x*T;
        ss = sum(erro.^2)/length(test_y);   %��ģ�Ͳ��Է���
        temp_ss =[temp_ss;ss];  %�����ѡ��
    end
    
    %������������У��ҵ��ﵽ��С�����Ǹ���������Լ���Ӧ��beta������С���
    [min_temp_ss,min_temp_index] = min(temp_ss);
    best_T = temp_T(min_temp_index,:);
    best_lamda = lamdas(min_temp_index);
    
    mode = [mode;best_T];%��ѵ����õ�ģ��  
    mode_ss = [mode_ss;min_temp_ss];%ģ�ͷ���
    mode_lamda = [mode_lamda;best_lamda];%ģ���ڲ���
    
    if min_temp_ss < satisfy_ss %��ģ�ͷ����С��������ʱ
        satisfy_mode = best_T;
        satisfy_lamda = best_lamda;
        break
    end
end

if ~isempty(satisfy_mode)   %�����������
    best_mode = satisfy_mode;
    best_mode_ss = min_temp_ss;
    best_mode_lamda = satisfy_lamda;
else
    %���������������£�ѡ��С��
    [min_mode_ss,min_index] = min(mode_ss);
    best_mode = mode(min_index,:);
    best_mode_ss = min_mode_ss;
    best_mode_lamda = mode_lamda(min_index);
end
beta = best_mode';

end