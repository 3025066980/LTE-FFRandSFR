function cd = cdf( ms1_data )
%CDF Summary of this function goes here
%   ����һά���飬����ͳ�ƺ�������1��Ϊ��ֵ����2��Ϊ��������3��Ϊ����
num=0;
unum=0;
for x=-10:2:50
    unum=0;
    num=num+1;
    cd(1,num)=x;
    for k=1:length(ms1_data)
        if ms1_data(k)<=x
            unum=unum+1;
        end
    end
    cd(2,num)=unum;
    cd(3,num)=unum/length(ms1_data);
end

