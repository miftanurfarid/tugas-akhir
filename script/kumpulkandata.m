function [ITD,ILD,RATIO]=kumpulkandata(azimuth_target,azimuth_masker,pow)
% kumpulkandata.m -> melakukan pencampuran binaural sebagai data
% training dan melakukan ekstrak itd, ild dan ratio.

temp_ITD=[];
temp_ILD=[];
temp_RATIO=[];

hrtf_right_t=strcat('R',int2str(azimuth_target));
hrtf_target_right=load(hrtf_right_t);
hrtf_left_t=strcat('L',int2str(azimuth_target));
hrtf_target_left=load(hrtf_left_t);
hrtf_right_m=strcat('R',int2str(azimuth_masker));
hrtf_masker_right=load(hrtf_right_m);
hrtf_left_m=strcat('L',int2str(azimuth_masker));
hrtf_masker_left=load(hrtf_left_m);

fprintf('Proses data TA Mifta\nPengumpulan data training...');
for T=1:5;
    for N=6:10;
        fprintf('%02d%%',floor(((T-1)*5+(N-5))/(5*5)*100));
        name_target=strcat('T',int2str(T));
        target=load(name_target);

        name_masker=strcat('T',int2str(N));   
        masker=load(name_masker);
        %% Data Spasial
        target=pow2(target,15);
        masker=pow2(masker,15);
        
        target = target*10^(pow/20);
        
        if length(target)>length(masker)
            target=target(1:length(masker),:);
        elseif length(target)<length(masker)
            masker=masker(1:length(target),:);
        end

        TL=conv(target,hrtf_target_left);
        TR=conv(target,hrtf_target_right);
        ML=conv(masker,hrtf_masker_left);
        MR=conv(masker,hrtf_masker_right);
        MIXL=TL+ML;
        MIXR=TR+MR;

        %% gammatone filterbank

        gfTL=gammatone(TL,128,[80,5000],16000);
        gfTR=gammatone(TR,128,[80,5000],16000);
        gfML=gammatone(ML,128,[80,5000],16000);
        gfMR=gammatone(MR,128,[80,5000],16000);
        gfMIXL=gammatone(MIXL,128,[80,5000],16000);
        gfMIXR=gammatone(MIXR,128,[80,5000],16000);

        %% hair cell filter

        hcTL=meddis(gfTL,16000);
        hcTR=meddis(gfTR,16000);
        hcML=meddis(gfML,16000);
        hcMR=meddis(gfMR,16000);
        hcMIXL=meddis(gfMIXL,16000);
        hcMIXR=meddis(gfMIXR,16000);

        %% cochleagram

        cgTL=cochleagram(hcTL,320);
        cgTR=cochleagram(hcTR,320);
        cgML=cochleagram(hcML,320);
        cgMR=cochleagram(hcMR,320);
        cgMIXL=cochleagram(hcMIXL,320);
        cgMIXR=cochleagram(hcMIXR,320);

        %% itd
%         [itd_T,corrT]=meancrosscorrelogram(hcTL,hcTR,-3500,3500,16000);
        itdchanframeT=itdchanframe(hcTL,hcTR);
%         itdaverageT=averageitd(corrT);
%         [itd_M,corrM]=meancrosscorrelogram(hcML,hcMR,-3500,3500,16000);
        itdchanframeM=itdchanframe(hcML,hcMR);
%         itdaverageM=averageitd(corrM);
%         [itd_MIX,corrMIX]=meancrosscorrelogram(hcMIXL,hcMIXR,-3500,3500,16000);
        itdchanframeMIX=itdchanframe(hcMIXL,hcMIXR);
%         itdaverageMIX=averageitd(corrMIX);

        %% ild
        ildchanframeT = ildchanframe(hcTL,hcTR);
%         ild_T= meanild(hcTL,hcTR);
        ildchanframeM = ildchanframe(hcML,hcMR);
%         ild_M= meanild(hcML,hcMR);
        ildchanframeMIX = ildchanframe(hcMIXL,hcMIXR);
%         ild_MIX= meanild(hcMIXL,hcMIXR);

        %% ratio
        ratioL=ratiochanframe(hcTL,hcML);
        ratioR=ratiochanframe(hcTR,hcMR);
        
        %% save all data
%         nama_data=strcat('dataT',int2str(T),'N',int2str(N));
%         save(nama_data);
%         disp(nama_data);
        
        %% simpan ITD ILD RATIO
%         namadata=strcat('T',int2str(T),'N',int2str(N));
%         load(namadata);
%         ITDt=[ITD itdchanframeT];
%         ILDt=[ILD ildchanframeT];
        temp_itd = caripeakitd(itdchanframeM);
        temp_ITD    = [temp_ITD temp_itd];
        temp_ILD    = [temp_ILD ildchanframeM];
        temp_RATIO  = [temp_RATIO ratioL];
        fprintf('\b\b\b');
    end
end

ITD=temp_ITD;
ILD=temp_ILD;
RATIO=temp_RATIO;

fprintf('\bSelesai!\n');
end