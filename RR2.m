function [beta,best_mode_ss,best_mode_lamda] = RR2(data,lable)
% RR2()函数岭回归，如果岭回归模型不好，，则再次训练多次，直到得到模型满足要求
%           如果超过最大迭代次数就放弃
% input：
%     data：特征数据
%     lable：疲劳值（0-1）
% output：
%     beta：邻回归模型中的beta列向量
%     best_mode_ss：当前beta下的，总数据的方差，用于评价beta的好坏
%     best_mode_lamda：邻回归模型下的lamda值（岭参数）

[beta,best_mode_ss,best_mode_lamda] = RR(data,lable);
for i = 1:5
    if best_mode_ss < 10 %RR模型方差满足则退出
        break;
    end
    [beta,best_mode_ss,best_mode_lamda] = RR(data,lable);
end
end
