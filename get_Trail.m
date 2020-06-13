function [result,trail] = get_Trail(data,idsNAN)

fc = 250;
wn = [1*2 50*2]/fc;                  %1-50HZlÂË²¨
[k,l] = butter (2,wn);
result = filtfilt(k,l,double(data));
trail = [];

len = length(idsNAN)-1
for i=0:len
    if idsNAN(i+1,1)==0
        trail = [trail;i*10*fc+1,(i*10+30)*fc];
    end
end

end
