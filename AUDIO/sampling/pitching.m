
clear; clc; close all


[native, Fs] = audioread('\native.wav');
[up, Fs] = audioread('\upPF.wav');
[down, Fs] = audioread('\downPF.wav');

N = Fs;

scale = linspace(1,Fs/2,N/2-1);

native_fft = fft(native(1:N,1));
up_fft = fft(up(1:N,1));
down_fft = fft(down(1:N,1));


plot(scale, abs(native_fft(1:N/2-1)));
figure;
plot(scale, abs(up_fft(1:N/2-1)));
figure;
plot(scale, abs(down_fft(1:N/2-1)));
