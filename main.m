idsNaN_dir='I:\������\�˻�����\����1\��ʻƣ�Ͷȹ���\��ʻƣ�Ͷȹ���\train_data\idsNaN';
train_dir ='I:\������\�˻�����\����1\��ʻƣ�Ͷȹ���\��ʻƣ�Ͷȹ���\train_data\train_data';

;%��ȡѵ�������ļ���
file = [];
subdirpath = fullfile( idsNaN_dir, '*.mat' );
dat = dir( subdirpath );
for j = 1 : length( dat )
        datpath = fullfile(dat( j ).name);
        file=strvcat(file,datpath);%��ȡѵ�������ļ���
end
file(16,:)=[];
file(3,:)=[];   %ȥ��������

%��ȡѵ������
standard_loc = [] ;
idsNaN_name= [];%ѵ�����ݵ����ּ���
resTime_name = [];
eeg_data_name = [];
for j = 1:length(file) %��ȡÿһ���ļ�eeg_data��resTime��idsNaN������
    datpath = strcat(idsNaN_dir,'\',file(j,:))
    load(datpath);
    name = strcat('idsNaN_',file(j,1:6));
    eval([name,'=idsNaN;'])     %������idsNaN
    idsNaN_name= [idsNaN_name;name];
   
    datpath = strcat(train_dir,'\',file(j,:))
    load(datpath);
    name = strcat('resTime_',file(j,1:6));
    eval([name,'=resTime;']);   %������resTime
    resTime_name= [resTime_name;name];
    name = strcat('eeg_data_',file(j,1:6));
    eval([name,'=eeg_data;']);  %������eeg_data
    eeg_data_name= [eeg_data_name;name];
    if j==1
        standard_loc = eeg_locations;
    end
    if isequal(standard_loc,eeg_locations)~=1   %�ж�ÿ��ѵ�����ݵĵ缫λ���Ƿ���ͬ
        erro = "EEG Position Erro!"
    end
end

%ѵ��RRģ��
beta_sum = [];%ÿ���û���RRģ��
beta_ss_lamda_sum=[];%ÿ���û�RRģ�͵ķ����������
for i = 1:14        %ѵ��ÿ���û������ݳ�RRģ��
    eval(['data = ',eeg_data_name(i,:),';']) 
    %eval([eeg_data_name(i,:),'=[];'])%�������е�󣬻�����������ͷ��ڴ��
    eval(['idsNAN = ',idsNaN_name(i,:),';']);
    [result,trail] = get_Trail(data,idsNAN); %�����˲���ֶ�
    feature = get_Feature(result,trail); %��ȡ����
    eval(['lable = ',resTime_name(i,:),';']);
    [beta,ss,lamda] = RR2(feature,lable);%��ع�
    beta_sum = [beta_sum;beta'];
    beta_ss_lamda_sum=[beta_ss_lamda_sum;[ss,lamda]];
end

%Ǩ��ѧϰ�õ�ģ�������Ŀ���������
load('I:\������\�˻�����\����1\��ʻƣ�Ͷȹ���\��ʻƣ�Ͷȹ���\test_data\070207.mat')
load('I:\������\�˻�����\����1\��ʻƣ�Ͷȹ���\��ʻƣ�Ͷȹ���\train_data\idsNaN\070207.mat')
[result,trail] = get_Trail(eeg_data,idsNaN);%Ŀ�������˲���ֶ�
feature = get_Feature(result,trail);%Ŀ��������ȡ����
 
beta = mean(beta_sum);%Ǩ��ѧϰ
test_resTime = feature*beta';%����Ŀ���û���resTime
%��һ��
max1 = max(test_resTime1);
min1 = min(test_resTime1);
test_resTime_1=(test_resTime-min1)./(max1-min1);

plot(test_resTime_1)%�鿴���

