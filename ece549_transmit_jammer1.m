deviceNameSDR = 'Pluto'; % Set SDR Device
radio = sdrdev(deviceNameSDR);           % Create SDR device object


 sdrTransmitter = sdrtx(deviceNameSDR); % Transmitter properties
 sdrTransmitter.RadioID = 'usb:0';

fs = 2e6;

tx = sdrtx(deviceNameSDR);
tx.RadioID = 'usb:0';
tx.CenterFrequency = 2.4145e9;
tx.BasebandSampleRate = fs;
tx.Gain = -10;



fs = 0.5e6;
sw = dsp.SineWave;
sw.Amplitude = 5;
sw.Frequency = 10;
sw.ComplexOutput = false;
sw.SampleRate = fs;
sw.SamplesPerFrame = 200000;
txWaveform = sw();

txW = complex(txWaveform);
 
transmitRepeat(tx,txW);


 
%L = length(signal);
 %Y = fft(signal);
 %S = ffshift(Y);
 %fshift = ((-L/2):(L/2-1))*(fs/L);
 %powershift = abs(S).^2/L;
% plot(fshift,powershift)
