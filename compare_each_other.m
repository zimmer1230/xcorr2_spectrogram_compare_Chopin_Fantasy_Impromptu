clear;



[D, Fs] = audioread('Dmitry Shishkin.wav');
[M, Fs] = audioread('Miroslav Kultyshev.wav');
[R, Fs] = audioread('Rubinstein.wav');
% [V, Fs] = audioread('Valentina Lisitsa.wav');
% [Y, Fs] = audioread('Yundi Li.wav');
% [Z, Fs] = audioread('Zhi Chao Julian Jia.wav');

% [y, Fs] = audioread('Tones2.wav'); % five second ver.
% sound(D, Fs); 

fmin = 27.5;
fmax = 4186;
Fpass = [fmin fmax];
% filt = designfilt(y, Fpass, Fs);
% y_filt = filter(filt, y);

D_filt = bandpass(D, Fpass, Fs);
M_filt = bandpass(M, Fpass, Fs);
R_filt = bandpass(R, Fpass, Fs);
% V_filt = bandpass(V, Fpass, Fs);
% Y_filt = bandpass(Y, Fpass, Fs);
% Z_filt = bandpass(Z, Fpass, Fs);


% Define the parameters for the spectrogram
window = hamming(round(0.05*Fs), 'periodic'); % window function
noverlap = round(0.025*Fs); % number of samples to overlap between segments
nfft = 4096; % number of FFT points

[Sd, F, T] = spectrogram(D_filt, window, noverlap, nfft, Fs);
MagD = abs(Sd); 
size_D = size(MagD);

[Sm, F, T] = spectrogram(M_filt, window, noverlap, nfft, Fs);
MagM = abs(Sm);
size_M = size(MagM);

[Sr, F, T] = spectrogram(R_filt, window, noverlap, nfft, Fs);
MagR = abs(Sr);
size_R = size(MagR);

% Compute cross-correlation
if (size_D(2)>size_M(2))
    C_DM = normxcorr2(MagM, MagD);
else
    C_DM = normxcorr2(MagD,MagM);
end
Max_C_DM = max( C_DM(:) );

if (size_M(2)>size_R(2))
    C_MR = normxcorr2(MagR, MagM);
else
    C_MR = normxcorr2(MagM,MagR);
end
Max_C_MR = max( C_MR(:) );

if (size_R(2)>size_D(2))
    C_RD = normxcorr2(MagD, MagR);
else
    C_RD = normxcorr2(MagR,MagD);
end
Max_C_RD = max( C_RD(:) );

disp('D and M are correlated with');
disp(Max_C_DM);

disp('M and R are correlated with');
disp(Max_C_MR);

disp('R and D are correlated with');
disp(Max_C_RD);

% imagesc(T, F, Mag);
% axis xy; colormap(jet); colorbar;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% ylim([fmin fmax]);