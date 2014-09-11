clear; clc; close all


% MUSICAL FREQUENCIES

C           = 16.35;
Csharp      = 17.32;
D           = 18.35;
Dsharp      = 19.45;
E           = 20.60;
F           = 21.83;
Fsharp      = 23.12;
G           = 24.50;
Gsharp      = 25.96;
A           = 27.50;
Asharp      = 29.14;
B           = 30.87;

musical_freqs = [C, Csharp, D, Dsharp, E, F, Fsharp, G, Gsharp,...
                A, Asharp, B];
            
notes = {'C'; 'Csharp'; 'D'; 'Dsharp'; 'E'; 'F'; 'Fsharp'; 'G'; 'Gsharp';...
                'A'; 'Asharp'; 'B'};            
            
%%
fs              = 88200;
bits            = 16;

sample_time = 1;
sample_length = sample_time*fs;
N = sample_length
recObj = audiorecorder(fs, bits,1,1)

disp('Start speaking.')
recordblocking(recObj, sample_time);
disp('End of Recording.');

% play(recObj);
signal = getaudiodata(recObj);
% plot(myRecording);

%%
fft_scale = (0:(sample_length-1)/2)*(fs/sample_length); 

ms1         = floor(fs/1000);   
ms2         = floor(fs/200);  
cept_scale  = (ms1:ms2)/fs;

window_signal = signal.*blackman(sample_length);
    fft_window = fft(window_signal);
    
    [FFTval FFTind] = max(abs(fft_window));
    pitchs = fft_scale(FFTind)
    
    cept_signal = ifft(log(abs(fft_window)+eps));
    % cept_signal = cceps(window_signal);
    
    [CEPval CEPind] = max(cept_signal(ms1:ms2));
    peak = cept_scale(CEPind);
    fun = 1/peak
    
    
    fun2 = fun;
    pitchs2 = pitchs;
    
    FFTnum = 0;
    CEPnum = 0;
    
    while(fun > 30.87)
        fun = fun/2;
        FFTnum = FFTnum + 1;
    end;
    
    while(pitchs > 30.87)
        pitchs = pitchs/2;
        CEPnum = CEPnum + 1;
    end;
    
    for i = 1:12
    err_cept(i) = abs(fun - musical_freqs(i));
    err_fft(i)  = abs(pitchs - musical_freqs(i));
    end

    [hey yea] = min(err_fft);
    strfft = ['FFT' notes(yea) ]; disp(strfft);
    %strfft2 = ['FFT2' freq2note(pitchs2)]; disp(strfft2);
    
    
    [what how] = min(err_cept);
    strcept = ['CEPT:', notes(how) ]; disp(strcept);
    
     suptitle(notes(how));
    subplot(3,1,1)
    plot((0:sample_length-1)/fs, window_signal/max(window_signal)); 
%     title('Hamming-Windowed Time-Domain');
    axis([0 .1 -1.5 1.5]);
    
    subplot(3,1,2);
    plot(fft_scale, abs(fft_window(1:ceil(end/2)))/max(abs(fft_window(1:ceil(end/2)))));
    axis([0 N 0 1.2]);
    title('Spectrum');
    
    subplot(3,1,3)
    plot(cept_scale, cept_signal(ms1:ms2)/max(cept_signal(ms1:ms2))); 
    axis([ms1/fs ms2/fs -1.2 1.2]);
    title('Cepstrum');