% Put this in the postloadfcn inside of the VMC model so this will run once
% the simulink model has ran

% Data from simulink workspace
data = out.fft.Data;
simulink = out.simulink.Data;



% Variables for loop
numDatasets = size(data, 3); 
data_TOT = zeros(size(data(:,:,1)));  
simdata = zeros(size(data(:,:,1)));
lC = length(data_TOT);
freq_axis = (-lC/2:lC/2-1)/lC*fs;

% loop through data and accumulate to fix data format since its a 1024x1xN
% vector (N 1024 point FFTs) (Depending on how long the sim is)
for i = 1:numDatasets
    data_TOT = data_TOT + data(:,:,i);
    simdata = simdata + simulink(:,:,i);
end


    
% Plotting Frequency domain
figure;
subplot(2, 1, 1);
plot(freq_axis, data_TOT, LineWidth=1.5);
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title("Versal RF FFT Output (N=1024)");
xlim([0.25e8 1.575e8])
subplot(2, 1, 2);
plot(freq_axis, simdata, LineWidth=1.5);
xlabel("Frequency (Hz)");
ylabel("Amplitude");
title("Simulink FFT Output (N=1024)");


%%
simout = out.simout1.Data;
% --- Inputs you already have -----------------------------------------
X  = simout;      % your FFT coefficients (complex)
Fs = 500e6;           % <-- supply the true sampling rate (Hz)

% --- Basic bookkeeping -----------------------------------------------
N  = length(X);       % FFT size

% 1)  Single-sided (0 ... Fs/2) magnitude spectrum --------------------
% MATLAB's FFT returns bins 0…N-1 that represent 0…Fs*(1-1/N).
f = Fs*(0:(N/2))/N;           % positive-frequency axis, length N/2+1

Xmag = abs(X)/N;              % scale by N if you want true amplitude
P1   = Xmag(1:N/2+1);         % keep only the positive frequencies
P1(2:end-1) = 2*P1(2:end-1);  % compensate for energy in negative freqs

figure;
plot(f, P1);
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('Single-sided magnitude spectrum');

% 2)  Double-sided, zero-centered spectrum ----------------------------
Xshift = fftshift(X);                   % move DC to the center
fshift  = (-N/2 : N/2-1) * (Fs/N);      % frequency axis, length N

figure;
plot(fshift, abs(Xshift)/N);            % or 20*log10(abs(...)) for dB
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('Double-sided (centered) magnitude spectrum');
grid on;
