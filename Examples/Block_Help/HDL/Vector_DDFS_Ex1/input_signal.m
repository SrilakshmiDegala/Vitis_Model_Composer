clc
clear

fs = 500e6;
% j = sqrt(-1);
FFT_SIZE = 1024;

%---------------
%--TFA Signals--
%---------------

%different frequencies to test out
frequencies = [10e6, 20e6, 30e6];
t = 0:1/fs:0.00005;
signal_1 = cos(2*pi*(frequencies(1))*t)+j*sin(2*pi*(frequencies(1))*t);
signal_2 = cos(2*pi*(frequencies(2))*t)+j*sin(2*pi*(frequencies(2))*t);
signal_3 = cos(2*pi*(frequencies(3))*t)+j*sin(2*pi*(frequencies(3))*t);

%Plot real and imaginary parts of each signal
figure;
subplot(3, 1, 1);
plot(t, imag(signal_1));
hold on
plot(t, real(signal_1));
%xlim([0 2e-3])
xlabel('Time (s)');
ylabel('Magnitude');
subplot(3, 1, 2)
plot(t, real(signal_2));
hold on
plot(t, imag(signal_2));
%xlim([0 2e-3])
xlabel('Time (s)');
ylabel('Magnitude');
subplot(3, 1, 3)
plot(t, real(signal_3));
hold on
plot(t, imag(signal_3));
%xlim([0 2e-3])
xlabel('Time (s)');
ylabel('Magnitude');

% Create wideband signal with all 3 frequency components
% Need to make samples to send into block rather than just try
% and input whole signal into workspace at one time
wideband = [signal_1 signal_2 signal_3];
wbreal = real(wideband);
wbimag = imag(wideband);
bigT = 0:(1/(length(wideband)-1)):1;
lW = length(wideband);

figure;
plot(bigT, real(wideband))

% Plotting in time domain isnt really the best
% the frequencies are so high you cant tell the difference
% (spectrogram?)

% FFT plot
x_real = fft(real(wideband));
z_real = fftshift(x_real);
x_imag = fft(imag(wideband));
z_imag = fftshift(x_imag);
faxis = (-lW/2:lW/2-1)/lW*fs;
figure;
subplot(2, 1, 1)
plot(faxis, abs(z_real)/1000);
grid on
%xlim([-1e4 1e4])
subplot(2, 1, 2)
plot(faxis, abs(z_imag)/1000);
grid on
%xlim([-1e4 1e4])
hold off

% Spectrogram plot - Best way of visualising TFA signals
window = 75;
noverlap = 20;
nfft = 128;
figure;
spectrogram(wideband, window, noverlap, nfft, fs, 'yaxis')

%-----------------
%--Chirp signals--
%-----------------

fStart = 10e6;
fStop = 100e6;
chirpInput = chirp(t,fStart, 0.00005, fStop, "quadratic", 'complex');

figure;
spectrogram(chirpInput, window, noverlap, nfft, fs, 'yaxis')

chirpfft = fft(chirpInput);
lC = length(chirpInput);
faxis1 = (-lC/2:lC/2-1)/lC*fs;

figure;
subplot(2, 1, 1)
plot(faxis1, angle((chirpfft)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on
subplot(2, 1, 2)
plot(faxis1, angle(real(chirpfft)));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
grid on

%% Signal loading for FFT



num_chan = 1;
control = [0 0 0];
wideband_tdata_sample_real_0 = [zeros(1,length(control)) 0 0 0];
wideband_tdata_sample_imag_0 = [zeros(1,length(control)) 0 0 0];
for i = 1:length(wideband)
    for k = 1:num_chan
        wideband_tdata_sample_real_0 = [wideband_tdata_sample_real_0 real(wideband(i))];
        wideband_tdata_sample_imag_0 = [wideband_tdata_sample_imag_0 imag(wideband(i))];
    end
end
wideband_tdata_sample_real_0 = [wideband_tdata_sample_real_0 0];
wideband_tdata_sample_imag_0 = [wideband_tdata_sample_imag_0 0];

figure;
spectrogram(wideband_tdata_sample_imag_0, window, noverlap, nfft, fs, 'yaxis')