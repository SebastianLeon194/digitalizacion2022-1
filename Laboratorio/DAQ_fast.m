%% Este es un código que agaara un chingo de datos de trancazo.
%SAcrificamos (dato,fecha) del otro script pero optimizamos procesamiento
%Ahora vamos a tener tiempos de muestreo

%% Setup del puerto serie
%Búsqueda de todos los puertos serie
serialportlist

%Asignar un objeto serial y su tasa de baudios
%s=serialport("/dev/ttyUSB0",115200)
%Entre comillas pon lo que aparezca en serialportlist

configureTerminator(s,"CR/LF")
%% Setup de la captura
%Nombre de la variable
name="analogRead";
figure('Name',name,'NumberTitle','off');

%Crea objeto de línea animada
h=animatedline;

%Coloca líneas paralelas al plot
ax=gca;
ax.YGrid='on';

%Tiempo durante el cual se va a medir
measureTime=seconds(10);
t=seconds(0);

%Longitud de la lectura
numChars=4; %Número de caracters
numReads=100; %cantidad de numeros por lectura
n=0:numReads-1; %Vector de número de muestra

%% Lectura y ploteo
%Libera el buffer de Matlab para puerto serial
flush(s);
%Leerá una linea completa y nos dejará al inicio
%De una nueva línea.
readline(s);

%Obtiene la fecha del sistema y la guarda
startTime=datetime('now');

%while 1 %Grabado infinito  
while t<=measureTime  %Grabado con tiempo fijo
    
   %Lectura del valor actual del sensor
   %El +2 es para los caracteres CR/LF   
   data=read(s,numReads*(numChars+2),'char');%Ojo en el tipo de variable que lees 'char'   
   data=str2num(data);
   n=n+numReads;
    
   %addpoints(h,datenum(t),data);
   addpoints(h,n,data);
   
   %Ajusta los limites de x
   ax.XLim=[n(end)-1000 n(end)];
   
   %Actualiza toda la información a la linea animada
   drawnow

   %Momento final de la muestra
   endTime=datetime('now');
   
   %Tiempo transcurrido
   t=endTime-startTime;   
   title("Elapsed Time: "+seconds(t)+"s");
end
%% Guardado de datos

%Obtención de los datos desde la linea animada
[~,dataPoints] = getpoints(h);

%Vector de tiempo total
time=startTime:(endTime-startTime)/(numel(dataPoints)-1):endTime;
Ts=seconds(endTime-startTime)/numel(dataPoints); %Periodo de muestreo [s]
fs=1/Ts; %Frecuencia de muestreo[Hz]

%% Ploteo de la señal capturada

figure
plot(time,dataPoints)
xlabel('Muestra')
ylabel(name)

%% Guardar en ASCII
%writematrix(dataPoints',"./Output/"+datestr(startTime)+"_fs"+fs+"Hz_"+name+".xlsx");
%Again, ten cuidado con el "./Output" porque probablemente tenga un nombre
%diferente en mi compu.