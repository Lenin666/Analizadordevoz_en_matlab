%grabacion del Audio
request = input('Ingrese los segundos que desea grabar = '); %tiempo de grabado
fs = 44100;
recObj = audiorecorder(fs,24,2);
disp('Empieza a hablar.');
recordblocking(recObj, request);
disp('Fin de la grabacíon.');
y= getaudiodata(recObj);
audiowrite('PruebaAudio.wav',y,fs)
%portada
%myicon = imread('ipn logo.jpg');
%message2 = msgbox({'GARCÍA RUIZ LENIN; VILLEGAS FRANCO ALFREDO; RÍOS LÓPEZ LEONARDO'},"IPN","custom",myicon);

plot(y);


% Importacion de audio
[a, fs]= audioread("PruebaAudio.wav");

%duracion del sonido
d = length(a)/fs;

%cambio a audio monocanal
a_m = 0.5*(a(:,1) + a(:,2)).';

%plot forma de onda (waveform)
t = linspace(0, d, length(a_m));

%plot de la figura
subplot(2,2,1);
plot(t, a_m);
title("Forma de onda del Audio");
xlabel("Tiempo [seg]");
ylabel("Amplitud");
grid on;

%analisis en frecuencia (Fourier)

A_m = fftshift(fft(a_m));

%eje de frecuencias

f = linspace(-fs/2, fs/2, length(A_m)); %por teorema de Nyquist

%magnitud de A_m

mag_A = abs(A_m);

subplot(2,2,2); %graficando en frecuencia
plot(f, mag_A/max(mag_A));  %normalizando la funcion plot(f, mag_A);
title("Espectro de frecuencia del Audio");
xlabel("Frequencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;

%ajustando valores eje x (milis, micros, etc)

ax = gca;
ax.XAxis.Exponent = 3;

%creacion de filtros ideales 
%filtro pasa bajas

lpf = 1.*(abs(f)<=500);
subplot(2,2,3);
plot(f, lpf);
title("Filtro Pasa Bajas");
xlabel("Frequencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;

%ajustando valores eje x (milis, micros, etc)

ax = gca;
ax.XAxis.Exponent = 3;

%%unificando grafico del filtro y espectro de audio
%parte 1 filtro

subplot(2,2,4)
plot(f, mag_A/max(mag_A),'g'); %parte 2 audio
hold on;
plot(f, lpf, 'r');
legend("Audio", "Filtro");
title("Filtro pasa Bajas");
xlabel("Frequencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

%filtrando pasa bajas ideal

A_lpf = A_m .* lpf; %filtrando

%graficando
figure();
plot(f, abs(A_lpf)/max(abs(A_lpf))); 
hold on;
plot(f, lpf, 'r');
legend("Audio Filtrado", "Filtro");
title("Filtro Pasa Bajas");
xlabel("Frequencia [Hz]");
ylabel("Amplitud");
grid on; grid minor;
ax = gca;
ax.XAxis.Exponent = 3;

%%regresando al dominio del tiempo por la inversa de Fourier

a_lpf = ifft(ifftshift(A_lpf));
a_lpf = real(a_lpf);

%graficando para observar lo que esta sucediendo

figure();
plot(a_lpf);
title("Audio filtrado en el Dominio del Tiempo")
xlabel("tiempo [seg]");
ylabel("Amplitud");
grid on; grid minor;

%% reproduccion de audios trabajados 

play(recObj);     %Audio original
pause(d+1);

sound(a_m, fs);   %Audio monocanal
pause(d+1);

sound(a_lpf, fs);  %Audio filtrado
pause(d+1);

%sound(recObj, fs);
%pause(d+1);

%player = audioplayer(recObj); 
%player2 = audioplayer(a_lpf,fs);

audiowrite('Salida Audio Filtrado.wav',a_lpf, fs)

%cierre
message = msgbox('Operación completada');