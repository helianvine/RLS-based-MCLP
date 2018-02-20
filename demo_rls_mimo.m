clc;
clear;
close all;

% ****************************************************
% Input and Output Configrations
% ****************************************************

sample_name = 'wav_sample/r_a106_20dB_001.wav';
sig_multi_ch = 1;

% sample_name = 'sample_set/r_a106_20dB_001_ch1.wav'
% sig_multi_ch = 0;

output_dir = 'wav_drv/'; 
if ~exist(output_dir, 'dir')
   mkdir(output_dir); 
   disp(['mkdir ', output_dir])
end

% *******************************************************
% Set Parameters
% *******************************************************
% cfg = 'setting/rls_configurations.m';

cfg.mic_num = 3;
cfg.out_num = 2;

cfg.K = 512;                               % the number of subbands
cfg.F = 4;                                 % over-sampling rate
cfg.N = cfg.K / cfg.F;                     % decimation factor

cfg.D1 = 2;                                % subband preditction delay                     
cfg.Lw1 = 40;                              % subband prediction order 

cfg.delta = 1e2;                           % initial conditon for RLS

cfg.lambda = 0.998;

% *******************************************************
% Read data from files
% *******************************************************
if sig_multi_ch
    [x, fs] = audioread(sample_name);
    x = x(:,1:cfg.mic_num);
else
    x = [];
    for m = 1 : cfg.mic_num
        input_name = strrep(sample_name, 'ch1', ['ch',num2str(m)]);
        [s, fs] = audioread(input_name);
        x = [x, s];
    end
end
cfg.fs = fs;

% *******************************************************
% Processing and output
% *******************************************************
tic;
y = rls_mimo_drv(x, cfg);
output_name = [output_dir, 'test.wav'];
audiowrite(output_name, y, fs);
fprintf('%s', ['Processing:', 32, sample_name]);
fprintf('%s\nElapsed time: %.2f\n\n', [32, '=>', 32, output_name], toc);

