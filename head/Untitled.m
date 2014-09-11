%% HEAD MODEL STUFF

clear; clc; close all

dir = cd('C:\Users\Micros\Desktop\headCode\code\files\');
delete('C:\Users\Micros\Desktop\headCode\code\files\*')


MRdir = 'C:\Users\Micros\Desktop\headCode\Imaging\MR_original\DICOM\';
P = ls(MRdir);

for i = 1:size(P,1)-2
    q(i,:) = fullfile(MRdir, P(i+2,:));
end

hdr = spm_dicom_headers(q);
img = spm_dicom_convert(hdr, 'all', 'flat', 'img');

% H = spm_orthviews('image',img.files{1,1}, [0 0 10 10])
%%

def_flags.estimate.priors = char(...
        fullfile(spm('Dir'),'apriori','grey.nii'),...
        fullfile(spm('Dir'),'apriori','white.nii'),...
        fullfile(spm('Dir'),'apriori','csf.nii'));
def_flags.estimate.reg    = 0.0001;
def_flags.estimate.cutoff = 25;
def_flags.estimate.samp   = 3;
def_flags.estimate.bb     =  [[-88 88]' [-122 86]' [-60 95]'];
def_flags.estimate.affreg.smosrc = 8;
def_flags.estimate.affreg.regtype = 'mni';
def_flags.estimate.affreg.weight = '';
def_flags.write.cleanup   = 1;
def_flags.write.wrt_cor   = 1;
def_flags.write.wrt_brV   = 0;
def_flags.graphics        = 1;

[VO,M] = pm_segment(img.files{1,1}, img.files{1,1}, def_flags);
%%

job = spm_jobman('serial','','spm.spatial.preproc');
%%
 % job.channel(n).vols{m}
% job.channel(n).biasreg
% job.channel(n).biasfwhm
% job.channel(n).write
% job.tissue(k).tpm
% job.tissue(k).ngaus
% job.tissue(k).native
% job.tissue(k).warped
% job.warp.affreg
% job.warp.reg
% job.warp.samp
% job.warp.write
% job.warp.bb
% job.warp.vox
% 
% varargout = spm_preproc_run(job,arg)
% 
% spm_jobman('initcfg');
% spm_jobman('interactive','spm.spatial.preproc');
%%
P = ls('c1*.img');

spm_surf(P,2,0.1);

gii = ls('*.gii');
g = gifti(gii);
%%
    subject = 1;
    addpath(genpath('..\VisualizationECoG\activeplot'))
    addpath(genpath('..\VisualizationECoG\activeplot\activeBrain'))
    load(['generic_brain.mat']);
    load(['Mayo_Electrodes_subs1-13.mat'])
    
    cmin=0;
    cmax=1; %max(channels{subject});
    
    cortex.tri = g.faces;
    cortex.vert = g.vertices;
    
    cmapstruct.fading=0;
    cmapstruct.ixg2=32;
    cmapstruct.ixg1=-cmapstruct.ixg2;
    cmapstruct.enablecolorbar=0;
    cmapstruct.cmin=cmin;
    cmapstruct.cmax=cmax;
    
    talastruct{1,1}.activations = rand(64,3);
    
    viewstruct.what2view = {'brain'}; %, 'activations'};
    
    viewstruct.enableaxis=0;
    viewstruct.viewvect=view{subject}.viewvect;
    viewstruct.lightpos=view{subject}.lightpos;
    
    set(0,'DefaultFigureRenderer','openGL');
    
    figure
%     subplot(1,2,1)
    activateBrain(cortex, vcontribs, talastruct{subject}, 1, cmapstruct, viewstruct );


% figure; 
% plot(g)

% FV = g; %gifti(spm_select(1,'mesh','Select surface data'));
% FV = export(FV,'patch');
% fg = spm_figure('GetWin','Graphics');
% ax = axes('Parent',fg);
% p  = patch(FV, 'Parent',ax,...
%     'FaceColor', [0.8 0.7 0.7], 'FaceVertexCData', [],...
%     'EdgeColor', 'none',...
%     'FaceLighting', 'phong',...
%     'SpecularStrength' ,0.7, 'AmbientStrength', 0.1,...
%     'DiffuseStrength', 0.7, 'SpecularExponent', 10);
% set(0,'CurrentFigure',fg);
% set(fg,'CurrentAxes',ax);
% l  = camlight(-40, 20);
% axis image;
% rotate3d on;