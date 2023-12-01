deviceNameSDR = 'Pluto'; % Set SDR Device
radio = sdrdev(deviceNameSDR);           % Create SDR device object

txGain = -1;

% sdrTransmitter = sdrtx(deviceNameSDR); % Transmitter properties
% sdrTransmitter.RadioID = 'usb:0';

fs = 2e6;

tx = sdrtx(deviceNameSDR);
tx.RadioID = 'usb:0';
tx.CenterFrequency = 2.415e9;
tx.BasebandSampleRate = fs;
tx.Gain = 0;


t = linspace(-pi, 2*pi, 121);


sw = 1.15*square(2*t);
% sw.Amplitude = 100;
% sw.Frequency = 100;
% sw.ComplexOutput = false;
% sw.SampleRate = fs;
% sw.SamplesPerFrame = 20000;


txWaveform = sw();

txW = complex(txWaveform)

% transmitRepeat(tx,txW);

plot(real(txW))
hold on;
plot(imag(txW))
hold off;
legend(["Real", "Imag"])

rx = sdrrx(deviceNameSDR)
rx.RadioID = "usb:1",
rx.CenterFrequency = 2.415e9;
rx.BasebandSampleRate = fs;
rx.Gain = 0;

signal = rx();
plot(real(signal));
hold on;
plot(imag(signal));
    legend('Real', 'Imag');
title('RX');
xlim([0 100]);

% L = length(signal);
% Y = fft(signal);
% S = ffshift(Y);
% fshift = ((-L/2):(L/2-1))*(fs/L);
% powershift = abs(S).^2/L;
% plot(fshift,powershift)