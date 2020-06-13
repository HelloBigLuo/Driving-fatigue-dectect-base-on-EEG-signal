function [feature] = get_Feature(data,trail)

feature = [];

len = trail(1,2)-trail(1,1);
window=boxcar(len);
Nfft=2^ceil(log2(len));
noverlap = len/2;
fs = 250; 

for i=1:length(trail) 
    averange = [];
    for j = 1:30
        xn = data(j,trail(i,1):trail(i,2));
        [Pxx f]=pwelch(xn,window,[],Nfft,fs);
        index = find(f>4&f<7);
        averange = [averange,mean(Pxx(index))];
    end
    feature = [feature;averange];
end

end