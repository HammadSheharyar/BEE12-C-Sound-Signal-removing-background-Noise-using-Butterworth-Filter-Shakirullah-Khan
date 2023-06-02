% Read the audio file containing the noisy signal and obtain the sampling frequency
[noised_signal, fs1] = audioread('Voice-for-detection.wav');

% Set the cutoff frequency for the Butterworth filter
f_cutoff = 1000;

% Normalize the cutoff frequency with respect to the Nyquist frequency
f_norm = f_cutoff / (fs1 / 2);

% Design a Butterworth filter of order 7 and lowpass characteristics
[b,a] = butter(7, f_norm, 'low');

% Apply the Butterworth filter to the noisy signal
filtered_signal = filter(b, a, noised_signal);

% Compute the frequency response of the filtered signal
[f2, P2] = FreqRes(filtered_signal, fs1);

% Amplify the filtered signal by a factor of 2
amplified_signal = filtered_signal .* 2;

% Compute the frequency response of the amplified noisy signal
[f1, P1] = FreqRes(noised_signal * 2, fs1);

% Plot the frequency responses
figure(1);
subplot(211);
plot(f1, P1);
subplot(212);
plot(f2, P2);

% Save the amplified signal as a new audio file
audiowrite('filtered-signal-4.wav', amplified_signal, fs1)

% Function that returns the frequency response of a signal
function [f, P1] = FreqRes(y, fs)
% Compute the single-sided amplitude spectrum using FFT
Y1 = fft(y);
L = length(y);
P2 = abs(Y1 / L);
P1 = P2(1:L / 2 + 1);
P1(2:end-1) = 2 * P1(2:end-1);
% Define the frequency axis
f = fs * (0:(L / 2)) / L;
end