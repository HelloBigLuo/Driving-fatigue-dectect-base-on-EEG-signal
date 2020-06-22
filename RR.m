function [beta,best_mode_ss,best_mode_lamda] = RR(data,lable)
% RR()函数岭回归
% input：
%     data：特征数据
%     lable：疲劳值（0-1）
% output：
%     beta：邻回归模型中的beta列向量
%     best_mode_ss：当前beta下的，总数据的方差，用于评价beta的好坏
%     best_mode_lamda：邻回归模型下的lamda值（岭参数）

iterate_max = 10;%最大迭代次数
lamdas = -50:0.5:50 ;%不同的邻参数
mode = [];%已训练获得的模型  
mode_ss = [];%模型方差
mode_lamda = []; %模型邻参数
satisfy_ss = 0.1; %满意误差
satisfy_mode = [] ;%满意模型
satisfy_lamda = [];%满意模型的lamda

for i_ = 1:iterate_max
    len = length(lable);
    index = randi(1,len-100+1,1);   %随机挑100个连续的数据作为训练集
    train_index = index:index+99;
    test_index = [[1:index-1],[(index+100):len]];
    
    train_x = [];%训练集X
    train_y = [];%训练集Y
    test_x = [];%测试集X
    test_y = [];%测试集Y
    
    for i=train_index
        x = data(i,:);
        train_x = [train_x;x]; %训练集X
        y = lable(i);
        train_y = [train_y;y]; %训练集Y
    end
    for i=test_index
        x = data(i,:);
        test_x = [test_x;x]; %测试集X
        y = lable(i);
        test_y = [test_y;y]; %测试集Y
    end
    
    temp_T = []; %beta，方差的待选集
    temp_ss =[];    
    for lamda = lamdas   %岭参数迭代
        T = (train_x'*train_x + lamda)^-1*train_x'*train_y; %求取beta
        temp_T = [temp_T;T']; %放入beta待选集
        %test
        erro = test_y - test_x*T;
        ss = sum(erro.^2)/length(test_y);   %求模型测试方差
        temp_ss =[temp_ss;ss];  %放入待选集
    end
    
    %在所有岭参数中，找到达到最小误差的那个岭参数，以及相应的beta，与最小误差
    [min_temp_ss,min_temp_index] = min(temp_ss);
    best_T = temp_T(min_temp_index,:);
    best_lamda = lamdas(min_temp_index);
    
    mode = [mode;best_T];%已训练获得的模型  
    mode_ss = [mode_ss;min_temp_ss];%模型方差
    mode_lamda = [mode_lamda;best_lamda];%模型邻参数
    
    if min_temp_ss < satisfy_ss %当模型方差很小，很满意时
        satisfy_mode = best_T;
        satisfy_lamda = best_lamda;
        break
    end
end

if ~isempty(satisfy_mode)   %如果存在满意
    best_mode = satisfy_mode;
    best_mode_ss = min_temp_ss;
    best_mode_lamda = satisfy_lamda;
else
    %不存在满意的情况下，选最小的
    [min_mode_ss,min_index] = min(mode_ss);
    best_mode = mode(min_index,:);
    best_mode_ss = min_mode_ss;
    best_mode_lamda = mode_lamda(min_index);
end
beta = best_mode';

end