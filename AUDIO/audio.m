
clear; clc; close all

[data, fs] = audioread('\tone.wav');

% 
% short = data(1:2:end,1);
% Ns = size(short,1);
% ss = (1:Ns/2-1)*2*fs/Ns;
% ffts = fft(short);
data = data(:,1);

N = size(data,1)/2;

%% spectral 
fft_sl = (1:N/2-1)*fs/N;
fft_data = (fft(data));
fft_half = fft_data(1:N/2-1);


for i = 1:2*N
    fft2(2*i) = fft_data(i); 
end


plot(fft_sl, abs(fft_half));
figure; 



%% ceptral 
% cept_sl = (1:N/2-1)/fs;
% cept_data = abs(fft(log(fft_data)));
% 
% ms1         = floor(fs/900);   
% ms2         = floor(fs/25);  
% cept_scale  = (ms1:ms2)/fs;




%% plotting things
% plot(fft_sl, abs(fft_data(1:N/2-1,1)));
% title('FFT');
% 
% figure; 
% plot(cept_scale, cept_data(ms1:ms2,1));
% title('CEPT');






