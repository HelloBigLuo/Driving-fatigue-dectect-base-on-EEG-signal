idsNaN_dir='I:\大三下\人机交互\课设1\驾驶疲劳度估计\驾驶疲劳度估计\train_data\idsNaN';
train_dir ='I:\大三下\人机交互\课设1\驾驶疲劳度估计\驾驶疲劳度估计\train_data\train_data';

;%获取训练数据文件名
file = [];
subdirpath = fullfile( idsNaN_dir, '*.mat' );
dat = dir( subdirpath );
for j = 1 : length( dat )
        datpath = fullfile(dat( j ).name);
        file=strvcat(file,datpath);%获取训练数据文件名
end
file(16,:)=[];
file(3,:)=[];   %去除坏数据

%读取训练数据
standard_loc = [] ;
idsNaN_name= [];%训练数据的名字集合
resTime_name = [];
eeg_data_name = [];
for j = 1:length(file) %读取每一个文件eeg_data，resTime，idsNaN并命名
    datpath = strcat(idsNaN_dir,'\',file(j,:))
    load(datpath);
    name = strcat('idsNaN_',file(j,1:6));
    eval([name,'=idsNaN;'])     %重命名idsNaN
    idsNaN_name= [idsNaN_name;name];
   
    datpath = strcat(train_dir,'\',file(j,:))
    load(datpath);
    name = strcat('resTime_',file(j,1:6));
    eval([name,'=resTime;']);   %重命名resTime
    resTime_name= [resTime_name;name];
    name = strcat('eeg_data_',file(j,1:6));
    eval([name,'=eeg_data;']);  %重命名eeg_data
    eeg_data_name= [eeg_data_name;name];
    if j==1
        standard_loc = eeg_locations;
    end
    if isequal(standard_loc,eeg_locations)~=1   %判断每个训练数据的电极位置是否相同
        erro = "EEG Position Erro!"
    end
end

%训练RR模型
beta_sum = [];%每个用户的RR模型
beta_ss_lamda_sum=[];%每个用户RR模型的方差与岭参数
for i = 1:14        %训练每个用户的数据成RR模型
    eval(['data = ',eeg_data_name(i,:),';']) 
    %eval([eeg_data_name(i,:),'=[];'])%数据量有点大，还数处理完就释放内存吧
    eval(['idsNAN = ',idsNaN_name(i,:),';']);
    [result,trail] = get_Trail(data,idsNAN); %数据滤波与分段
    feature = get_Feature(result,trail); %提取特征
    eval(['lable = ',resTime_name(i,:),';']);
    [beta,ss,lamda] = RR2(feature,lable);%岭回归
    beta_sum = [beta_sum;beta'];
    beta_ss_lamda_sum=[beta_ss_lamda_sum;[ss,lamda]];
end

%迁移学习得到模型来检测目标测试数据
load('I:\大三下\人机交互\课设1\驾驶疲劳度估计\驾驶疲劳度估计\test_data\070207.mat')
load('I:\大三下\人机交互\课设1\驾驶疲劳度估计\驾驶疲劳度估计\train_data\idsNaN\070207.mat')
[result,trail] = get_Trail(eeg_data,idsNaN);%目标数据滤波与分段
feature = get_Feature(result,trail);%目标数据提取特征
 
beta = mean(beta_sum);%迁移学习
test_resTime = feature*beta';%评价目标用户的resTime
%归一化
max1 = max(test_resTime1);
min1 = min(test_resTime1);
test_resTime_1=(test_resTime-min1)./(max1-min1);

plot(test_resTime_1)%查看结果

