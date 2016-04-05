%========��ʼ������=========
clear;
close all;
%========================

%=========�û������趨��==========
%-------------��������趨��----------------
true_length=500;%��ʵ���������趨����λm
axis_bs_loop=2;%���㿪ʼ����������Ȧ��ȷ��
axis_bs_num=6;%���㿪ʼ��ÿȦ�������������ȣ�����6
%--------------------------------------------

%--------------ms�趨��-------------------
ms_pernum=1000;%ÿ������С�����û�����
%------------------------------------------

%----------------�����趨��---------------
bs_power=40;%��վ�����ܹ��ʣ���λW
bs_SINR=3;%���ֻ�վ���ı�Ե����λdB
bs_connect_SINR=-30;%ȷ�����ӵ�SINRֵ
%------------------------------------------

%----------------��Դ���趨��---------------
bs_bandwidth=10;%MHz
tape_allnum=50;%50����Դ��
tape_slot=12;%����12�����ز�
tape_time=1;%ms
tape_alltime=1000;%ms
tape_do_num=tape_alltime/tape_time;
tpf=20;
%--------------------------------------------
%============================

%====================������ѹ������û�������========================
%--------------------��Ҫ������----------------------------------
bs_coordinate=0;%���ػ�վ����
ms_coordinate=0;%�����û�����
ms_allnum=0;
%-----------------------------------------------------------------

%--------------------����������----------------------------------
A=pi/3*[0:6];%������Ե����6����Ƕ��������
At=-pi/2-pi/3*[0:6];%6��С����Χ1��
aa=linspace(0,pi*2,80);%������Ե
bs_border_r=true_length;
bs_num=1;
bottle_bs_coordinate=0;
bottle_ms_num=1;
%-----------------------------------------------------------------

%-----------------------������------------------------------------
%����С����վ���괴��
for k=1:axis_bs_loop
    bottle_bs_coordinate=bottle_bs_coordinate+sqrt(3)*bs_border_r*exp(i*pi/6);
    for pp=1:axis_bs_num
        for p=1:k
            bs_num=bs_num+1;
            bs_coordinate(1,bs_num)=bottle_bs_coordinate;
            bottle_bs_coordinate=bottle_bs_coordinate+sqrt(3)*bs_border_r*exp(i*At(pp));
        end
    end
end

%�û����괴��
for k=1:bs_num
    ms_coordinate(1,bottle_ms_num:bottle_ms_num+ms_pernum-1)=bs_coordinate(1,k)+putuser(ms_pernum,bs_border_r);
    bottle_ms_num=bottle_ms_num+ms_pernum;
    ms_allnum=bottle_ms_num-1;
end
%-------------------------------------------------------------------
%===========================================================

%==================�û����ǹ��ʼ��㼰�����ж�========================
%��Ƹ���Ϊ��������źţ�ȡ���Ǹ�������߽������ӡ���ֻ�迼��������С���û����������ݲ��财��
%-------------------��Ҫ������------------------------
ms_test_coordinate=0;%�������ms������Ϣ
ms_test_power=0;%�������ms�ڲ�ͬbs�����µĹ���ֵ����Ϊ��ͬ��վ
ms_test_distance=0;%�������ms�಻ͬ��վ�ľ��룬��Ϊ��ͬ��վ
ms_test_SINR=0;%�������ms��SINR
ms_test_num=0;
ms_test_loss=0;
ms_distance=0;
ms_power=0;
ms_loss=0;
ms_test_center_SINR=0;%С�������û���Ϣ
ms_test_center_power=0;
ms_test_center_loss=0;
ms_test_center_distance=0;
ms_test_border_SINR=0;%С����Ե�û���Ϣ
ms_test_border_power=0;
ms_test_border_loss=0;
ms_test_border_distance=0;
ms_test_center_num=0;
ms_test_border_num=0;
%------------------------------------------------------

%---------------------����������----------------------
bs_dbm=ptodbm(bs_power);
min_ms_power=0;
bottle_ms_test_coordinate=0;
bottle_ms_test_SINR=0;
bottle_ms_test_power=0;
bottle_ms_test_distance=0;
test_rc=0;
test_bc=0;
%------------------------------------------------------

%------------------------RB������--------------------------------
ms_test_tape_power=bs_power/tape_allnum;%��λW
ms_test_tape_dbm=ptodbm(ms_test_tape_power);
ms_test_tape_num=tape_allnum;
%------------------------------------------------------------------

%----------------------�����źŸ���������------------------------
for k=1:ms_allnum
    ms_x=real(ms_coordinate(k));
    ms_y=imag(ms_coordinate(k));
    for p=1:bs_num
        bs_x=real(bs_coordinate(p));
        bs_y=imag(bs_coordinate(p));
        ms_distance(p,k)=distance(ms_x,ms_y,bs_x,bs_y);%��λm
        ms_loss(p,k)=loss(ms_distance(p,k));
        ms_power(p,k)=ms_test_tape_dbm-loss(ms_distance(p,k));%��λdBm
    end
end
%-------------------------------------------------------------------

%------------------------����ȷ��������-----------------------------
[max_ms_power,max_ms_index]=max(ms_power);
for k=1:ms_allnum
    if max_ms_index(k)==1
        ms_test_num=ms_test_num+1;
        ms_test_coordinate(1,ms_test_num)=ms_coordinate(k);
        ms_test_loss(1:bs_num,ms_test_num)=ms_loss(1:bs_num,k);
        ms_test_power(1:bs_num,ms_test_num)=ms_power(1:bs_num,k);
        ms_test_distance(1:bs_num,ms_test_num)=ms_distance(1:bs_num,k);
    end
end
%plot(ms_test_coordinate,'*');
%--------------------------------------------------------------------

%-------------------------SINR������-------------------------------
for k=1:length(ms_test_coordinate)
    ms_test_SINR(1,k)=sinr(ms_test_power(1:bs_num,k));
end
%--------------------------------------------------------------------

%---------------------------��������ȷ����--------------------------
%bottle_ms_test_num=0;
%for k=1:length(ms_test_coordinate)
%  if ms_test_SINR(1,k)>=bs_connect_SINR
%        bottle_ms_test_num=bottle_ms_test_num+1;
%        bottle_ms_test_coordinate(1,bottle_ms_test_num)=ms_test_coordinate(1,k);
%        bottle_ms_test_loss(1:bs_num,bottle_ms_test_num)=ms_test_loss(1:bs_num,k);
%        bottle_ms_test_power(1:bs_num,bottle_ms_test_num)=ms_test_power(1:bs_num,k);
%        bottle_ms_test_distance(1:bs_num,bottle_ms_test_num)=ms_test_distance(1:bs_num,k);
%        bottle_ms_test_SINR(1,bottle_ms_test_num)=ms_test_SINR(1,k);
%    end
%end
%ms_test_coordinate=bottle_ms_test_coordinate;
%ms_test_loss=bottle_ms_test_loss;
%ms_test_power=bottle_ms_test_power;
%ms_test_distance=bottle_ms_test_distance;
%ms_test_SINR=bottle_ms_test_SINR;
%--------------------------------------------------------------------

%--------------------------------RR������----------------------------------------------
ms_test_rr_num(1,1:ms_test_num)=0;
bottle_test_rr_num=0;
if ms_test_num>=ms_test_tape_num
    for k=1:tape_do_num
        for p=1:ms_test_tape_num
            bottle_test_rr_num=bottle_test_rr_num+1;
            ms_test_rr_num(1,bottle_test_rr_num)=ms_test_rr_num(1,bottle_test_rr_num)+1;
            if bottle_test_rr_num==ms_test_num
                bottle_test_rr_num=0;
            end
        end
    end
else
    for k=1:tape_do_num
        for p=1:ms_test_num
            ms_test_rr_num(1,p)=ms_test_rr_num(1,p)+1;
        end
    end
end
%---------------------------------------------------------------------------------------

%------------------------------PF������--------------------------------
ms_test_pf_num(1,1:ms_test_num)=0;
bottle_test_pf_tout(1,1:ms_test_num)=0;
for k=1:ms_test_num
    bottle_test_pf_tout(1,k)=throughout(ms_test_SINR(1,k),tape_slot,tape_time);
end
ms_test_pf_level(1,1:ms_test_num)=(1-1/tpf)*sum(bottle_test_pf_tout(1,:))/length(bottle_test_pf_tout(1,:));
if ms_test_num>=ms_test_tape_num
    for k=1:tape_do_num
        ms_test_pf_level(2,1:ms_test_num)=0;
        for p=1:ms_test_tape_num
            bottle_index=findpf(ms_test_pf_num,ms_test_pf_level,bottle_test_pf_tout,tpf);
            ms_test_pf_num=bottle_index(1,:);
            ms_test_pf_level=bottle_index(2:3,:);
        end
    end
else
    for k=1:tape_do_num
        ms_test_pf_level(2,1:ms_test_num)=0;
        for p=1:ms_test_num
            bottle_index=findpf(ms_test_pf_num,ms_test_pf_level,bottle_test_pf_tout,tpf);
            ms_test_pf_num=bottle_index(1,:);
            ms_test_pf_level=bottle_index(2:3,:);
        end
    end
end
%-----------------------------------------------------------------------

%--------------------------------MCI������-------------------------------------
if ms_test_num>=round(ms_test_tape_num/10)
    ms_test_mci_position=findmci(ms_test_SINR,round(ms_test_tape_num/10));
else
    ms_test_mci_position=findmci(ms_test_SINR,ms_test_num);
end
ms_test_mci_num(1,1:ms_test_num)=0;
ms_test_mci_num(1,ms_test_mci_position(:))=tape_do_num;
%--------------------------------------------------------------------------------

%----------------------------���ı�Ե�û�������------------------------------
for k=1:length(ms_test_SINR)
    if ms_test_SINR(k)>=bs_SINR
        ms_test_center_num=ms_test_center_num+1;
        ms_test_center_SINR(1,ms_test_center_num)=ms_test_SINR(1,k);
        ms_test_center_loss(1:bs_num,ms_test_center_num)=ms_test_loss(1:bs_num,k);
        ms_test_center_power(1:bs_num,ms_test_center_num)=ms_test_power(1:bs_num,k);
        ms_test_center_distance(1:bs_num,ms_test_center_num)=ms_test_distance(1:bs_num,k);
    else
        ms_test_border_num=ms_test_border_num+1;
        ms_test_border_SINR(1,ms_test_border_num)=ms_test_SINR(1,k);
        ms_test_border_loss(1:bs_num,ms_test_border_num)=ms_test_loss(1:bs_num,k);
        ms_test_border_power(1:bs_num,ms_test_border_num)=ms_test_power(1:bs_num,k);
        ms_test_border_rr_num(1,ms_test_border_num)=ms_test_rr_num(1,k);
        ms_test_border_pf_num(1,ms_test_border_num)=ms_test_pf_num(1,k);
        ms_test_border_mci_num(1,ms_test_border_num)=ms_test_mci_num(1,k);
    end
end
%test_rc=max(ms_test_center_distance(1,:));
%------------------------------------------------------------------------------

%---------------------------------������������------------------------------------
%RR
ms_test_rr_tout(1,1:ms_test_num)=0;
for k=1:ms_test_num
    ms_test_rr_tout(1,k)=throughout(ms_test_SINR(1,k),tape_slot,tape_time)*ms_test_rr_num(1,k);
end
for k=1:ms_test_border_num
    ms_test_border_rr_tout(1,k)=throughout(ms_test_border_SINR(1,k),tape_slot,tape_time)*ms_test_border_rr_num(1,k);
end
test_rr_tout=sum(ms_test_rr_tout(:));%/ms_test_num;
test_border_rr_tout=sum(ms_test_border_rr_tout(:));%/ms_test_border_num;
test_rr_efficiency=test_rr_tout/ms_test_tape_num;
test_rr_cover=cover(ms_test_rr_tout);
ms_test_rr_fair=fair(ms_test_rr_tout);

%PF
ms_test_pf_tout(1,1:ms_test_num)=0;
for k=1:ms_test_num
    ms_test_pf_tout(1,k)=throughout(ms_test_SINR(1,k),tape_slot,tape_time)*ms_test_pf_num(1,k);
end
for k=1:ms_test_border_num
    ms_test_border_pf_tout(1,k)=throughout(ms_test_border_SINR(1,k),tape_slot,tape_time)*ms_test_border_pf_num(1,k);
end
test_pf_tout=sum(ms_test_pf_tout(:));
test_border_pf_tout=sum(ms_test_border_pf_tout(:));
test_pf_efficiency=test_pf_tout/ms_test_tape_num;
test_pf_cover=cover(ms_test_pf_tout);
ms_test_pf_fair=fair(ms_test_pf_tout);

%Max C/I
ms_test_mci_tout(1,1:ms_test_num)=0;
for k=1:ms_test_num
    ms_test_mci_tout(1,k)=throughout(ms_test_SINR(1,k),tape_slot,tape_time)*ms_test_mci_num(1,k);
end
for k=1:ms_test_border_num
    ms_test_border_mci_tout(1,k)=throughout(ms_test_border_SINR(1,k),tape_slot,tape_time)*ms_test_border_mci_num(1,k);
end
test_mci_tout=sum(ms_test_mci_tout(:));
test_border_mci_tout=sum(ms_test_border_mci_tout(:));
test_mci_efficiency=test_mci_tout/round(ms_test_tape_num/10);
test_mci_cover=cover(ms_test_mci_tout);
ms_test_mci_fair=fair(ms_test_mci_tout);
%-----------------------------------------------------------------------------------
%===========================================================

%======================FFR3��================================
%Ŀ��Ϊ���ò���FFR����������Ϊ3�ķ���С��
%-----------------------��Ҫ������------------------------
%��Ϊ���ø�������Ϊ3��FFR������������������Ϊ
%19������С����ɵķ��Ѵ�
ms_ffr3_center_loss=ms_test_center_loss;
ms_ffr3_border_loss=ms_test_border_loss(1,:);
ms_ffr3_center_SINR=0;
ms_ffr3_border_SINR=0;
%----------------------------------------------------------

%-------------------------����������---------------------------

%---------------------------------------------------------------

%-----------------------------RB������----------------------------------
ms_ffr3_tape_border_num=round(tape_allnum/6);
ms_ffr3_tape_center_num=tape_allnum-3*ms_ffr3_tape_border_num;
ms_ffr3_tape_power=bs_power/(ms_ffr3_tape_center_num+ms_ffr3_tape_border_num);
ms_ffr3_tape_dbm=ptodbm(ms_ffr3_tape_power);
%-------------------------------------------------------------------------

%--------------------------���չ��ʼ�����--------------------------------
for k=1:6
    ms_ffr3_border_loss(k+1,1:ms_test_border_num)=ms_test_border_loss(7+2*k,:);
end
ms_ffr3_center_power=ms_ffr3_tape_dbm-ms_ffr3_center_loss;
ms_ffr3_border_power=ms_ffr3_tape_dbm-ms_ffr3_border_loss;
%-------------------------------------------------------------------------

%----------------------------SINR������-----------------------------------
for k=1:ms_test_center_num
    ms_ffr3_center_SINR(1,k)=sinr(ms_ffr3_center_power(:,k));
end
for k=1:ms_test_border_num
    ms_ffr3_border_SINR(1,k)=sinr(ms_ffr3_border_power(1:7,k));
end
ms_ffr3_SINR=[ms_ffr3_center_SINR,ms_ffr3_border_SINR];
%---------------------------------------------------------------------------

%-----------------------------RR������-----------------------------------
ms_ffr3_center_rr_num(1,1:ms_test_center_num)=0;
ms_ffr3_border_rr_num(1,1:ms_test_border_num)=0;
bottle_ffr3_center_rr_num=0;
bottle_ffr3_border_rr_num=0;
if ms_test_center_num>=ms_ffr3_tape_center_num
    for k=1:tape_do_num
        for p=1:ms_ffr3_tape_center_num
            bottle_ffr3_center_rr_num=bottle_ffr3_center_rr_num+1;
            ms_ffr3_center_rr_num(1,bottle_ffr3_center_rr_num)=ms_ffr3_center_rr_num(1,bottle_ffr3_center_rr_num)+1;
            if bottle_ffr3_center_rr_num==ms_test_center_num
                bottle_ffr3_center_rr_num=0;
            end
        end
    end
else
    for k=1:tape_do_num
        for p=1:ms_test_center_num
            ms_ffr3_center_rr_num(1,p)=ms_ffr3_center_rr_num(1,p)+1;
        end
    end
end

if ms_test_border_num>=ms_ffr3_tape_border_num
    for k=1:tape_do_num
        for p=1:ms_ffr3_tape_border_num
            bottle_ffr3_border_rr_num=bottle_ffr3_border_rr_num+1;
            ms_ffr3_border_rr_num(1, bottle_ffr3_border_rr_num)=ms_ffr3_border_rr_num(1, bottle_ffr3_border_rr_num)+1;
            if bottle_ffr3_border_rr_num==ms_test_border_num
                bottle_ffr3_border_rr_num=0;
            end
        end
    end
else
    for k=1:tape_do_num
        for p=1:ms_test_border_num
            ms_ffr3_border_rr_num(1,p)=ms_ffr3_border_rr_num(1,p)+1;
        end
    end
end
ms_ffr3_rr_num=[ms_ffr3_center_rr_num,ms_ffr3_border_rr_num];
%-------------------------------------------------------------------------

%------------------------------PF������--------------------------------
ms_ffr3_center_pf_num(1,1:ms_test_center_num)=0;
bottle_ffr3_center_pf_tout(1,1:ms_test_center_num)=0;
for k=1:ms_test_center_num
    bottle_ffr3_center_pf_tout(1,k)=throughout(ms_ffr3_center_SINR(1,k),tape_slot,tape_time);
end
ms_ffr3_center_pf_level(1,1:ms_test_center_num)=(1-1/tpf)*sum(bottle_ffr3_center_pf_tout(1,:))/ms_test_center_num;
if ms_test_center_num>=ms_ffr3_tape_center_num
    for k=1:tape_do_num
        ms_ffr3_center_pf_level(2,1:ms_test_center_num)=0;
        for p=1:ms_ffr3_tape_center_num
            bottle_index=findpf(ms_ffr3_center_pf_num,ms_ffr3_center_pf_level,bottle_ffr3_center_pf_tout,tpf);
            ms_ffr3_center_pf_num=bottle_index(1,:);
            ms_ffr3_center_pf_level=bottle_index(2:3,:);
        end
    end
else
    for k=1:tape_do_num
        ms_ffr3_center_pf_level(2,1:ms_test_center_num)=0;
        for p=1:ms_test_center_num
            bottle_index=findpf(ms_ffr3_center_pf_num,ms_ffr3_center_pf_level,bottle_ffr3_center_pf_tout,tpf);
            ms_ffr3_center_pf_num=bottle_index(1,:);
            ms_ffr3_center_pf_level=bottle_index(2:3,:);
        end
    end
end

ms_ffr3_border_pf_num(1,1:ms_test_border_num)=0;
bottle_ffr3_border_pf_tout(1,1:ms_test_border_num)=0;
for k=1:ms_test_border_num
    bottle_ffr3_border_pf_tout(1,k)=throughout(ms_ffr3_border_SINR(1,k),tape_slot,tape_time);
end
ms_ffr3_border_pf_level(1,1:ms_test_border_num)=(1-1/tpf)*sum(bottle_ffr3_border_pf_tout(1,:))/ms_test_border_num;
if ms_test_border_num>=ms_ffr3_tape_border_num
    for k=1:tape_do_num
        ms_ffr3_border_pf_level(2,1:ms_test_border_num)=0;
        for p=1:ms_ffr3_tape_border_num
            bottle_index=findpf(ms_ffr3_border_pf_num,ms_ffr3_border_pf_level,bottle_ffr3_border_pf_tout,tpf);
            ms_ffr3_border_pf_num=bottle_index(1,:);
            ms_ffr3_border_pf_level=bottle_index(2:3,:);
        end
    end
else
    for k=1:tape_do_num
        ms_ffr3_border_pf_level(2,1:ms_test_border_num)=0;
        for p=1:ms_test_border_num
            bottle_index=findpf(ms_ffr3_border_pf_num,ms_ffr3_border_pf_level,bottle_ffr3_border_pf_tout,tpf);
            ms_ffr3_border_pf_num=bottle_index(1,:);
            ms_ffr3_border_pf_level=bottle_index(2:3,:);
        end
    end
end
ms_ffr3_pf_num=[ms_ffr3_center_pf_num,ms_ffr3_border_pf_num];
%-----------------------------------------------------------------------

%--------------------------------MCI������-------------------------------------
ffr3_mci_tape_num=ms_ffr3_tape_center_num+ms_ffr3_tape_border_num;
if ms_test_num>=round(ffr3_mci_tape_num/10)
    ms_ffr3_mci_position=findmci(ms_ffr3_SINR,round(ffr3_mci_tape_num/10));
else
    ms_ffr3_mci_position=findmci(ms_ffr3_SINR,ms_test_num);
end
ms_ffr3_mci_num(1,1:ms_test_num)=0;
ms_ffr3_mci_num(1,ms_ffr3_mci_position(:))=tape_do_num;
%--------------------------------------------------------------------------------

%----------------------------------������������------------------------------------
%RR
ms_ffr3_center_rr_tout(1,1:ms_test_center_num)=0;
ms_ffr3_border_rr_tout(1,1:ms_test_border_num)=0;
for k=1:ms_test_center_num
    ms_ffr3_center_rr_tout(1,k)=throughout(ms_ffr3_center_SINR(1,k),tape_slot,tape_time)*ms_ffr3_center_rr_num(1,k);
end
for k=1:ms_test_border_num
    ms_ffr3_border_rr_tout(1,k)=throughout(ms_ffr3_border_SINR(1,k),tape_slot,tape_time)*ms_ffr3_border_rr_num(1,k);
end
ms_ffr3_rr_tout=[ms_ffr3_center_rr_tout,ms_ffr3_border_rr_tout];
ffr3_rr_tout=sum(ms_ffr3_rr_tout(:));%/ms_test_num;
ffr3_border_rr_tout=sum(ms_ffr3_border_rr_tout(:));%/ms_test_border_num;
ffr3_rr_efficiency=ffr3_rr_tout/(ms_ffr3_tape_center_num+ms_ffr3_tape_border_num);
ffr3_rr_cover=cover(ms_ffr3_rr_tout);
ms_ffr3_rr_fair=fair(ms_ffr3_rr_tout);

%PF
ms_ffr3_center_pf_tout(1,1:ms_test_center_num)=0;
ms_ffr3_border_pf_tout(1,1:ms_test_border_num)=0;
for k=1:ms_test_center_num
    ms_ffr3_center_pf_tout(1,k)=throughout(ms_ffr3_center_SINR(1,k),tape_slot,tape_time)*ms_ffr3_center_pf_num(1,k);
end
for k=1:ms_test_border_num
    ms_ffr3_border_pf_tout(1,k)=throughout(ms_ffr3_border_SINR(1,k),tape_slot,tape_time)*ms_ffr3_border_pf_num(1,k);
end
ms_ffr3_pf_tout=[ms_ffr3_center_pf_tout,ms_ffr3_border_pf_tout];
ffr3_pf_tout=sum(ms_ffr3_pf_tout(:));%/ms_test_num;
ffr3_border_pf_tout=sum(ms_ffr3_border_pf_tout(:));%/ms_test_border_num;
ffr3_pf_efficiency=ffr3_pf_tout/(ms_ffr3_tape_center_num+ms_ffr3_tape_border_num);
ffr3_pf_cover=cover(ms_ffr3_pf_tout);
ms_ffr3_pf_fair=fair(ms_ffr3_pf_tout);

%Mac C/I
ms_ffr3_mci_tout(1,1:ms_test_num)=0;
for k=1:ms_test_num
    ms_ffr3_mci_tout(1,k)=throughout(ms_ffr3_SINR(1,k),tape_slot,tape_time)*ms_ffr3_mci_num(1,k);
end
ms_ffr3_border_mci_tout=ms_ffr3_mci_tout(1,ms_test_center_num+1:end);
ffr3_mci_tout=sum(ms_ffr3_mci_tout(:));
ffr3_border_mci_tout=sum(ms_ffr3_border_mci_tout(:));
ffr3_mci_efficiency=ffr3_mci_tout/round(ffr3_mci_tape_num/10);
ffr3_mci_cover=cover(ms_ffr3_mci_tout);
ms_ffr3_mci_fair=fair(ms_ffr3_mci_tout);
%------------------------------------------------------------------------------------
%===========================================================

%============================SFR3��==========================
%--------------------------��Ҫ������--------------------------------
ms_sfr3_center_power=0;
ms_sfr3_border_power=0;
ms_sfr3_center_SINR=0;
ms_sfr3_border_SINR=0;
%---------------------------------------------------------------------

%----------------------------����������---------------------------------
ms_sfr3_center_loss=ms_test_center_loss;
ms_sfr3_border_loss=ms_test_border_loss;
%------------------------------------------------------------------------

%----------------------------RB������-------------------------------
ms_sfr3_tape_center_num=round(2*tape_allnum/3);
ms_sfr3_tape_border_num=tape_allnum-ms_sfr3_tape_center_num;
ms_sfr3_tape_center_power=bs_power/(ms_sfr3_tape_center_num+2*ms_sfr3_tape_border_num);
ms_sfr3_tape_border_power=(bs_power-ms_sfr3_tape_center_power*ms_sfr3_tape_center_num)/ms_sfr3_tape_border_num;
ms_sfr3_tape_center_dbm(1:bs_num,1)=ptodbm(ms_sfr3_tape_border_power);%�����⣬�Ǵ���
ms_sfr3_tape_border_dbm(1:bs_num,1)=ptodbm(ms_sfr3_tape_center_power);%
%---------------------------------------------------------------------

%-------------------------�û����ʼ�����----------------------------
for k=1:2:19
    ms_sfr3_tape_center_dbm(k,1)=ptodbm(ms_sfr3_tape_center_power);
end
for k=8:4:16
    ms_sfr3_tape_center_dbm(k,1)=ptodbm(ms_sfr3_tape_center_power);
end
ms_sfr3_tape_border_dbm(1,1)=ptodbm(ms_sfr3_tape_border_power);
for k=9:2:19
    ms_sfr3_tape_border_dbm(k,1)=ptodbm(ms_sfr3_tape_border_power);
end
for k=1:ms_test_center_num
    ms_sfr3_center_power(1:bs_num,k)=ms_sfr3_tape_center_dbm(:,1)-ms_sfr3_center_loss(:,k);
end
for k=1:ms_test_border_num
    ms_sfr3_border_power(1:bs_num,k)=ms_sfr3_tape_border_dbm(:,1)-ms_sfr3_border_loss(:,k);
end
%--------------------------------------------------------------------

%----------------------------�û�SINR������------------------------------
for k=1:ms_test_center_num
    ms_sfr3_center_SINR(1,k)=sinr(ms_sfr3_center_power(:,k));
end
for k=1:ms_test_border_num
    ms_sfr3_border_SINR(1,k)=sinr(ms_sfr3_border_power(:,k));
end
ms_sfr3_SINR=[ms_sfr3_center_SINR,ms_sfr3_border_SINR];
%---------------------------------------------------------------------------

%-----------------------------RR������-----------------------------------
ms_sfr3_center_rr_num(1,1:ms_test_center_num)=0;
ms_sfr3_border_rr_num(1,1:ms_test_border_num)=0;
bottle_sfr3_center_rr_num=0;
bottle_sfr3_border_rr_num=0;
if ms_test_center_num>=ms_sfr3_tape_center_num
    for k=1:tape_do_num
        for p=1:ms_sfr3_tape_center_num
            bottle_sfr3_center_rr_num=bottle_sfr3_center_rr_num+1;
            ms_sfr3_center_rr_num(1,bottle_sfr3_center_rr_num)=ms_sfr3_center_rr_num(1,bottle_sfr3_center_rr_num)+1;
            if bottle_sfr3_center_rr_num==ms_test_center_num
                bottle_sfr3_center_rr_num=0;
            end
        end
    end
else
    for k=1:tape_do_num
        for p=1:ms_test_center_num
            ms_sfr3_center_rr_num(1,p)=ms_sfr3_center_rr_num(1,p)+1;
        end
    end
end

if ms_test_border_num>=ms_sfr3_tape_border_num
    for k=1:tape_do_num
        for p=1:ms_sfr3_tape_border_num
            bottle_sfr3_border_rr_num=bottle_sfr3_border_rr_num+1;
            ms_sfr3_border_rr_num(1, bottle_sfr3_border_rr_num)=ms_sfr3_border_rr_num(1, bottle_sfr3_border_rr_num)+1;
            if bottle_sfr3_border_rr_num==ms_test_border_num
                bottle_sfr3_border_rr_num=0;
            end
        end
    end
else
    for k=1:tape_do_num
        for p=1:ms_test_border_num
            ms_sfr3_border_rr_num(1,p)=ms_sfr3_border_rr_num(1,p)+1;
        end
    end
end
ms_sfr3_rr_num=[ms_sfr3_center_rr_num,ms_sfr3_border_rr_num];
%-------------------------------------------------------------------------

%------------------------------PF������--------------------------------
ms_sfr3_center_pf_num(1,1:ms_test_center_num)=0;
bottle_sfr3_center_pf_tout(1,1:ms_test_center_num)=0;
for k=1:ms_test_center_num
    bottle_sfr3_center_pf_tout(1,k)=throughout(ms_sfr3_center_SINR(1,k),tape_slot,tape_time);
end
ms_sfr3_center_pf_level(1,1:ms_test_center_num)=(1-1/tpf)*sum(bottle_sfr3_center_pf_tout(1,:))/ms_test_center_num;
if ms_test_center_num>=ms_sfr3_tape_center_num
    for k=1:tape_do_num
        ms_sfr3_center_pf_level(2,1:ms_test_center_num)=0;
        for p=1:ms_sfr3_tape_center_num
            bottle_index=findpf(ms_sfr3_center_pf_num,ms_sfr3_center_pf_level,bottle_sfr3_center_pf_tout,tpf);
            ms_sfr3_center_pf_num=bottle_index(1,:);
            ms_sfr3_center_pf_level=bottle_index(2:3,:);
        end
    end
else
    for k=1:tape_do_num
        ms_sfr3_center_pf_level(2,1:ms_test_center_num)=0;
        for p=1:ms_test_center_num
            bottle_index=findpf(ms_sfr3_center_pf_num,ms_sfr3_center_pf_level,bottle_sfr3_center_pf_tout,tpf);
            ms_sfr3_center_pf_num=bottle_index(1,:);
            ms_sfr3_center_pf_level=bottle_index(2:3,:);
        end
    end
end

ms_sfr3_border_pf_num(1,1:ms_test_border_num)=0;
bottle_sfr3_border_pf_tout(1,1:ms_test_border_num)=0;
for k=1:ms_test_border_num
    bottle_sfr3_border_pf_tout(1,k)=throughout(ms_sfr3_border_SINR(1,k),tape_slot,tape_time);
end
ms_sfr3_border_pf_level(1,1:ms_test_border_num)=(1-1/tpf)*sum(bottle_sfr3_border_pf_tout(1,:))/ms_test_border_num;
if ms_test_border_num>=ms_sfr3_tape_border_num
    for k=1:tape_do_num
        ms_sfr3_border_pf_level(2,1:ms_test_border_num)=0;
        for p=1:ms_sfr3_tape_border_num
            bottle_index=findpf(ms_sfr3_border_pf_num,ms_sfr3_border_pf_level,bottle_sfr3_border_pf_tout,tpf);
            ms_sfr3_border_pf_num=bottle_index(1,:);
            ms_sfr3_border_pf_level=bottle_index(2:3,:);
        end
    end
else
    for k=1:tape_do_num
        ms_sfr3_border_pf_level(2,1:ms_test_border_num)=0;
        for p=1:ms_test_border_num
            bottle_index=findpf(ms_sfr3_border_pf_num,ms_sfr3_border_pf_level,bottle_sfr3_border_pf_tout,tpf);
            ms_sfr3_border_pf_num=bottle_index(1,:);
            ms_sfr3_border_pf_level=bottle_index(2:3,:);
        end
    end
end
ms_sfr3_pf_num=[ms_sfr3_center_pf_num,ms_sfr3_border_pf_num];
%-----------------------------------------------------------------------

%--------------------------------MCI������-------------------------------------
sfr3_mci_tape_num=ms_sfr3_tape_center_num+ms_sfr3_tape_border_num;
if ms_test_num>=round(sfr3_mci_tape_num/10)
    ms_sfr3_mci_position=findmci(ms_sfr3_SINR,round(sfr3_mci_tape_num/10));
else
    ms_sfr3_mci_position=findmci(ms_sfr3_SINR,ms_test_num);
end
ms_sfr3_mci_num(1,1:ms_test_num)=0;
ms_sfr3_mci_num(1,ms_sfr3_mci_position(:))=tape_do_num;
%--------------------------------------------------------------------------------

%----------------------------------������������------------------------------------
%RR
ms_sfr3_center_rr_tout(1,1:ms_test_center_num)=0;
ms_sfr3_border_rr_tout(1,1:ms_test_border_num)=0;
for k=1:ms_test_center_num
    ms_sfr3_center_rr_tout(1,k)=throughout(ms_sfr3_center_SINR(1,k),tape_slot,tape_time)*ms_sfr3_center_rr_num(1,k);
end
for k=1:ms_test_border_num
    ms_sfr3_border_rr_tout(1,k)=throughout(ms_sfr3_border_SINR(1,k),tape_slot,tape_time)*ms_sfr3_border_rr_num(1,k);
end
ms_sfr3_rr_tout=[ms_sfr3_center_rr_tout,ms_sfr3_border_rr_tout];
sfr3_rr_tout=sum(ms_sfr3_rr_tout(:));
sfr3_border_rr_tout=sum(ms_sfr3_border_rr_tout(:));
sfr3_rr_efficiency=sfr3_rr_tout/(ms_sfr3_tape_center_num+ms_sfr3_tape_border_num);
sfr3_rr_cover=cover(ms_sfr3_rr_tout);
ms_sfr3_rr_fair=fair(ms_sfr3_rr_tout);

%PF
ms_sfr3_center_pf_tout(1,1:ms_test_center_num)=0;
ms_sfr3_border_pf_tout(1,1:ms_test_border_num)=0;
for k=1:ms_test_center_num
    ms_sfr3_center_pf_tout(1,k)=throughout(ms_sfr3_center_SINR(1,k),tape_slot,tape_time)*ms_sfr3_center_pf_num(1,k);
end
for k=1:ms_test_border_num
    ms_sfr3_border_pf_tout(1,k)=throughout(ms_sfr3_border_SINR(1,k),tape_slot,tape_time)*ms_sfr3_border_pf_num(1,k);
end
ms_sfr3_pf_tout=[ms_sfr3_center_pf_tout,ms_sfr3_border_pf_tout];
%ms_sfr3_pf_num=[ms_sfr3_center
sfr3_pf_tout=sum(ms_sfr3_pf_tout(:));%/ms_test_num;%Mbps
sfr3_border_pf_tout=sum(ms_sfr3_border_pf_tout(:));%/ms_test_border_num;
sfr3_pf_efficiency=sfr3_pf_tout/(ms_sfr3_tape_center_num+ms_sfr3_tape_border_num);
sfr3_pf_cover=cover(ms_sfr3_pf_tout);
ms_sfr3_pf_fair=fair(ms_sfr3_pf_tout);

%Max C/I
ms_sfr3_mci_tout(1,1:ms_test_num)=0;
for k=1:ms_test_num
    ms_sfr3_mci_tout(1,k)=throughout(ms_sfr3_SINR(1,k),tape_slot,tape_time)*ms_sfr3_mci_num(1,k);
end
ms_sfr3_border_mci_tout=ms_sfr3_mci_tout(1,ms_test_center_num+1:end);
sfr3_mci_tout=sum(ms_sfr3_mci_tout(:));
sfr3_border_mci_tout=sum(ms_sfr3_border_mci_tout(:));
sfr3_mci_efficiency=sfr3_mci_tout/round(sfr3_mci_tape_num/10);
sfr3_mci_cover=cover(ms_sfr3_mci_tout);
ms_sfr3_mci_fair=fair(ms_sfr3_mci_tout);
%------------------------------------------------------------------------------------
%===========================================================

%==========================ͼ������===========================
%-----------------����С����ͼ��----------------------
figure;
hold on;
axis square;
plot(bs_border_r*exp(i*A),'k','linewidth',2);
for k=1:bs_num
    zp=bs_coordinate(1,k)+bs_border_r*exp(i*A);
    g1=fill(real(zp),imag(zp),'k');
    set(g1,'FaceColor',[1,0.5,0],'edgecolor',[1,0,0]);
    text(real(bs_coordinate(1,k)),imag(bs_coordinate(1,k)),num2str(k),'fontsize',10);
end
%test_rc=500*0.7;
%zr=test_rc*exp(i*aa);
%g2=fill(real(zr),imag(zr),'k');
%set(g2,'FaceColor',[1,0.5,0],'edgecolor',[1,0.5,0],'EraseMode','xor');
%------------------------------------------------------

%-----------------�û�������ͼ��------------------------
plot(ms_test_coordinate,'*');
%--------------------------------------------------------

%-------------------�û�SINR�Ƚ���----------------------
figure;
hold on;
grid on;
%��������Ϊ1����ͨȫ��
ms_test_SINR_cdf=cdf(ms_test_SINR);
cdf_x=ms_test_SINR_cdf(1,:);
cdf_y=ms_test_SINR_cdf(3,:);
plot(cdf_x,cdf_y,'b-^','LineWidth',1.3);
%��������Ϊ3����ͨȫ��
%ms_nor3_SINR_cdf=cdf(ms_nor3_SINR);
%cdf_x=ms_nor3_SINR_cdf(1,:);
%cdf_y=ms_nor3_SINR_cdf(3,:);
%plot(cdf_x,cdf_y,'m:>');
%��������Ϊ3��ffr3ȫ��
ms_ffr3_SINR_cdf=cdf(ms_ffr3_SINR);
cdf_x=ms_ffr3_SINR_cdf(1,:);
cdf_y=ms_ffr3_SINR_cdf(3,:);
plot(cdf_x,cdf_y,'r:x','LineWidth',1.3);
%��������Ϊ3,sfr3ȫ��
ms_sfr3_SINR_cdf=cdf(ms_sfr3_SINR);
cdf_x=ms_sfr3_SINR_cdf(1,:);
cdf_y=ms_sfr3_SINR_cdf(3,:);
plot(cdf_x,cdf_y,'k-.v','LineWidth',1.3);
xlabel('�û�ƽ��SINRֵ(db)');
ylabel('ͳ��ˮƽ');
title('����С��ȫ���û�SINRֵͳ��');
legend('��������Ϊ1,��ͨ','��������Ϊ3,FFR','��������Ϊ3,SFR',4);

figure;
hold on;
grid on;
axis([-10 20 0 1]);
%��������Ϊ1����ͨ��Ե
ms_test_border_SINR_cdf=cdf(ms_test_border_SINR);
cdf_x=ms_test_border_SINR_cdf(1,:);
cdf_y=ms_test_border_SINR_cdf(3,:);
plot(cdf_x,cdf_y,'b-^','LineWidth',1.3);
%��������Ϊ3����ͨ��Ե
%ms_nor3_border_SINR_cdf=cdf(ms_nor3_border_SINR);
%cdf_x=ms_nor3_border_SINR_cdf(1,:);
%cdf_y=ms_nor3_border_SINR_cdf(3,:);
%plot(cdf_x,cdf_y,'m:>');
%��������Ϊ3��ffr3��Ե
ms_ffr3_border_SINR_cdf=cdf(ms_ffr3_border_SINR);
cdf_x=ms_ffr3_border_SINR_cdf(1,:);
cdf_y=ms_ffr3_border_SINR_cdf(3,:);
plot(cdf_x,cdf_y,'r:x','LineWidth',1.3);
%��������Ϊ3,sfr3��Ե
ms_sfr3_border_SINR_cdf=cdf(ms_sfr3_border_SINR);
cdf_x=ms_sfr3_border_SINR_cdf(1,:);
cdf_y=ms_sfr3_border_SINR_cdf(3,:);
plot(cdf_x,cdf_y,'k-.v','LineWidth',1.3);
xlabel('�û�ƽ��SINRֵ(db)');
ylabel('ͳ��ˮƽ');
title('����С����Ե�û�SINRֵͳ��');
legend('��������Ϊ1,��ͨ','��������Ϊ3,FFR','��������Ϊ3,SFR',4);
%------------------------------------------------------------

%-----------------------�������Ƚ���--------------------------
figure;
all_tout_bar=[test_rr_tout,ffr3_rr_tout,sfr3_rr_tout;
    test_pf_tout,ffr3_pf_tout,sfr3_pf_tout;
    test_mci_tout,ffr3_mci_tout,sfr3_mci_tout];
bar(all_tout_bar,1);
set(gca,'xticklabel',{'RR','PF','MAX C/I'},'Xgrid','off','Ygrid','on');
xlabel('��Դ���ȷ�ʽ');
ylabel('��������(Mbps)');
title('С���û���������ͳ��');
legend('��������Ϊ1,��ͨ','��������Ϊ3,FFR','��������Ϊ3,SFR',0);

figure;
border_tout_bar=[test_border_rr_tout,ffr3_border_rr_tout,sfr3_border_rr_tout;
    test_border_pf_tout,ffr3_border_pf_tout,sfr3_border_pf_tout;
    test_border_mci_tout,ffr3_border_mci_tout,sfr3_border_mci_tout];
bar(border_tout_bar,1);
set(gca,'xticklabel',{'RR','PF','MAX C/I'},'Xgrid','off','Ygrid','on');
xlabel('��Դ���ȷ�ʽ');
ylabel('��������(Mbps)');
title('С����Ե�û���������ͳ��');
legend('��������Ϊ1,��ͨ','��������Ϊ3,FFR','��������Ϊ3,SFR',0);
%--------------------------------------------------------------

%----------------------------��ƽ�ԱȽ���--------------------------------
figure;
fair1_bar=[ms_test_rr_fair,ms_test_pf_fair,ms_test_mci_fair;
    ms_ffr3_rr_fair,ms_ffr3_pf_fair,ms_ffr3_mci_fair;
    ms_sfr3_rr_fair,ms_sfr3_pf_fair,ms_sfr3_mci_fair];
bar(fair1_bar,1);
set(gca,'xticklabel',{'COM1','FFR3','SFR3'},'Xgrid','off','Ygrid','on');
xlabel('����Э����ʽ');
ylabel('��ƽ��');
title('С���û���ƽ�ԱȽ�');
legend('RR','PF','MAX C/I',0);

figure;
fair2_bar=[ms_test_rr_fair,ms_ffr3_rr_fair,ms_sfr3_rr_fair;
    ms_test_pf_fair,ms_ffr3_pf_fair,ms_sfr3_pf_fair;
    ms_test_mci_fair,ms_ffr3_mci_fair,ms_sfr3_mci_fair];
bar(fair2_bar,1);
set(gca,'xticklabel',{'RR','PF','MAX C/I'},'Xgrid','off','Ygrid','on');
xlabel('��Դ���ȷ�ʽ');
ylabel('��ƽ��');
title('С���û���ƽ�ԱȽ�');
legend('��������Ϊ1,��ͨ','��������Ϊ3,FFR','��������Ϊ3,SFR',0);
%-------------------------------------------------------------------------

%-----------------------------Ƶ��Ч�ʱȽ���-------------------------------
figure;
effi1_bar=[test_rr_efficiency,test_pf_efficiency,test_mci_efficiency;
    ffr3_rr_efficiency,ffr3_pf_efficiency,ffr3_mci_efficiency;
    sfr3_rr_efficiency,sfr3_pf_efficiency,sfr3_mci_efficiency];
bar(effi1_bar,1);
set(gca,'xticklabel',{'COM1','FFR3','SFR3'},'Xgrid','off','Ygrid','on');
xlabel('����Э����ʽ');
ylabel('Ƶ��Ч��');
title('С���û�Ƶ��Ч�ʱȽ�');
legend('RR','PF','MAX C/I',0);

figure;
effi2_bar=effi1_bar';
bar(effi2_bar,1);
set(gca,'xticklabel',{'RR','PF','MAX C/I'},'Xgrid','off','Ygrid','on');
xlabel('��Դ���ȷ�ʽ');
ylabel('Ƶ��Ч��');
title('С���û�Ƶ��Ч�ʱȽ�');
legend('��������Ϊ1,��ͨ','��������Ϊ3,FFR','��������Ϊ3,SFR',0);
%---------------------------------------------------------------------------

%-------------------------------�����ʷ�����---------------------------------
figure;
pe_cover=[test_rr_cover,test_pf_cover,test_mci_cover,ffr3_rr_cover,ffr3_pf_cover,ffr3_mci_cover,sfr3_rr_cover,sfr3_pf_cover,sfr3_mci_cover];
pe_t={'COM1,RR','COM1,PF','COM1,MAX C/I','FFR3,RR','FFR3,PF','FFR3,MAX C/I','SFR3,RR','SFR3,PF','SFR3,MAX C/I'};
for k=1:9
    subplot(3,3,k)
    pie(pe_cover(1,k));
    title(pe_t(k));
end
%-----------------------------------------------------------------------------
%============================================================