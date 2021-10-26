%% Este es un código que plotea lento pero es confiable y fácil

%% Setup del puerto serie
%Busca puerto serie:
serialportlist 
%sí sólo corres esto te dice cómo se llama la salida al micro
%También habrá un BaudRate que será importante

%Asignamos un objeto serial y su tasa de bauidos
%s=serialport("[Lo que salga de serialportlist]" , BaudRate)
configureTerminator(s,"CR/LF")

%% Setup de la captura
%Nombre de la variable
name="analogRead"; %Saca el nombre del lector analógico
figure('Name',name,'NumberTitle','off');

%Crea objeto de línea animada
h=animatedline;

%Coloca líneas paralelas al plot
ax=gca;
ax.YGrid='on';

%Tiempo durante el cual se va a medir
measureTime=seconds(10);
t=seconds(0);

%% Lectura y ploteo
%Libera el buffer para puerto serial
flush(s);
%Obtiene la fecha del sistema y la guarda como el momento inicial
startTime=datetime('now');

while 1 %Grabado infinito  
%while t<=measureTime  %Grabado con tiempo fijo
    
   %Lectura del valor actual del sensor   
   data=readline(s);
   data=str2double(data);%Arduino escupe chars no números. Con esto traducimos
   
   %Tiempo transcurrido
   t=datetime('now')-startTime;   
   addpoints(h,datenum(t),data);
   
   %Ajusta los limites de x  
   ax.XLim=datenum([t-seconds(5) t]);
   
   %Coloca un formato de fechas al eje x
   datetick('x','keeplimits');
   
   %Actualiza toda la información a la linea animada
   drawnow

   %Momento final de la muestra
   endTime=datetime('now');
end
%% Guardado de datos
%Obtención de los datos desde la linea animada
[~,dataPoints] = getpoints(h);

%Vector de tiempo total
time=startTime:(endTime-startTime)/(numel(dataPoints)-1):endTime;

%% Ploteo de la señal capturada
figure
plot(time,dataPoints)
ylabel(name+"[Adim]")
title(name)
grid on

%% Guardar en ASCII
data=table(time',dataPoints','VariableNames',["DateTime" name]);
writetable(data,"./Output/"+datestr(startTime)+"_"+name);
%Checa bien bien donde está la carpeta de output porque no está igual que
%el de Aldo (./Output/)




