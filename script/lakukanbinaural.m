function [itd,ild,campur_kiri,kiri] = lakukanbinaural(suara_target,suara_masker,azimuth_target,azimuth_masker,pow)
% melakukan pencampuran binaural
% suara target/masker = sinyal target/masker, dengan fs 16k Hz
% azimuth_target/azimuth = posisi azimuth target/masker


%% load data hrtf
hrtf_right_t=strcat('R',int2str(azimuth_target));
hrtf_target_right=load(hrtf_right_t);
hrtf_left_t=strcat('L',int2str(azimuth_target));
hrtf_target_left=load(hrtf_left_t);
hrtf_right_m=strcat('R',int2str(azimuth_masker));
hrtf_masker_right=load(hrtf_right_m);
hrtf_left_m=strcat('L',int2str(azimuth_masker));
hrtf_masker_left=load(hrtf_left_m);

%% load data suara
target=suara_target;
masker=suara_masker;

%% data spasial
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

% cgTL=cochleagram(hcTL,320);
% cgTR=cochleagram(hcTR,320);
% cgML=cochleagram(hcML,320);
% cgMR=cochleagram(hcMR,320);
% cgMIXL=cochleagram(hcMIXL,320);
% cgMIXR=cochleagram(hcMIXR,320);

%% ekstrak binaural cue

% itd
% itdchanframeT=itdchanframe(hcTL,hcTR);
itdchanframeM=itdchanframe(hcML,hcMR);
% itdaverageMIX=averageitd(corrMIX); -> corrMIX ada di kumpulkandata.m

% ild
% ildchanframeT = ildchanframe(hcTL,hcTR);
ildchanframeM = ildchanframe(hcML,hcMR);
% ildchanframeMIX = ildchanframe(hcMIXL,hcMIXR);

%% relative strength

% ratioL=ratiochanframe(hcTL,hcML);
% ratioR=ratiochanframe(hcTR,hcMR);

%% tentukan output
campur_kiri = MIXL;
% campur_kanan = MIXR;
itd = caripeakitd( itdchanframeM );
ild = ildchanframeM;
% ratio = ratioL;
kiri = TL;

end

