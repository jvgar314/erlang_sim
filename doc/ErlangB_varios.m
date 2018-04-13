%Erlang B (N servidores)

clc,clear,close all

trafico_entrante=9; %llamadas entrantes
lambda=3;
u_entrada_llamada=rand(1,trafico_entrante);
t_llamadas_exp=-log(1-u_entrada_llamada)/lambda; %transformacion para tiempo entre llamadas
figure,stem(t_llamadas_exp,ones(1,trafico_entrante)) %representar los instantes de las llamadas
title('Tiempo entre llamadas'),xlabel('t')

A=0.6; %trafico en Erlangs
nu=lambda/A; %1/(duracion media de llamada)
u_duracion_llamada=rand(1,trafico_entrante);
duracion_llamada=-log(1-u_duracion_llamada)/nu;

N=2; %nº servidores del sistema
t_ocupacion_serv=zeros(1,N); %inicializamos vector de los instantes hasta el cual está ocupado cada servidor

n_aceptadas=0;
aux=0;
n_block=0;
instantes_llamadas=cumsum(t_llamadas_exp);%acumular instantes de las llamadas
altura=rand(1,trafico_entrante); %alturas para las deltas
figure, hold on
for i=1:trafico_entrante
    aux=n_aceptadas; %igualamos para saber si después del bucle de los servidores se ha aceptado alguna
    for k=1:length(t_ocupacion_serv)
       
        if instantes_llamadas(i)>t_ocupacion_serv(k)
           
            t_ocupacion_serv(k)=instantes_llamadas(i)+duracion_llamada(i); %actualizamos t ocupacion del primer servidor libre
            plot([instantes_llamadas(i) instantes_llamadas(i) t_ocupacion_serv(k) t_ocupacion_serv(k)],[0 altura(i) altura(i) 0],'b')
            stem(instantes_llamadas(i),altura(i),'g')
            n_aceptadas=n_aceptadas+1;
            break; %al encontrar un servidor libre salimos del bucle
        end
    end
    
    if aux==n_aceptadas %si no ha habido cambios al revisar servidores significa que la llamada será bloqueada
        stem(instantes_llamadas(i),-0.5,'r')
        n_block=n_block+1;
    end
end
title('Erlang B')
hold off