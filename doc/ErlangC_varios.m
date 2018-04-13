clc,clear, close all
trafico_entrante=100000; %llamadas entrantes
lambda=3;
u_entrada_llamada=rand(1,trafico_entrante);
t_llamadas_exp=-log(1-u_entrada_llamada)/lambda; %transformacion para tiempo entre llamadas
% figure,stem(t_llamadas_exp,ones(1,trafico_entrante)) %representar los instantes de las llamadas
% xlabel('Tiempo entre llamadas')

A=1.3; %trafico en Erlangs
nu=lambda/A; %1/(duracion media de llamada)
u_duracion_llamada=rand(1,trafico_entrante);
duracion_llamada=-log(1-u_duracion_llamada)/nu;
altura=rand(1,trafico_entrante); %alturas para las deltas

N=2; %numero de servidores
t_ocupacion_serv=zeros(1,N);

n_aceptadas=0; %numero de llamadas aceptadas sin ir a la cola
n_aceptadas2=0; %numero de llamadas aceptadas sin ir a la cola 2
n_cola=0; %numero de llamadas que entran en la cola
n_cola2=0; %numero de llamadas que entran en la cola 2
n_cola_aceptada=0; %numero de llamadas aceptadas que van a la cola
n_restantes=0; %numero de llamadas que quedan en la cola tras acabar todas las llamadas
instante_llamada_cola=[]; %instante en el que son atendidas las llamadas que van a la cola
duracion_llamada_cola=[]; %duracion de las llamadas que van a la cola
c=1; %puntero de la cola
instante_llamada=cumsum(t_llamadas_exp);
figure, hold on
title('Erlang C')

for i=1:trafico_entrante
    if isempty(instante_llamada_cola)
        aux=n_aceptadas;
        for k=1:length(t_ocupacion_serv)
            if instante_llamada(i)>t_ocupacion_serv(k)
                t_ocupacion_serv(k)=instante_llamada(i)+duracion_llamada(i);
                n_aceptadas=n_aceptadas+1;
                plot([instante_llamada(i) instante_llamada(i) t_ocupacion_serv(k) t_ocupacion_serv(k)],[0 altura(i) altura(i) 0],'b')
                stem(instante_llamada(i),altura(i),'g')
                break;
                %Llamadas aceptadas con cola vacía
                
            end
        end
        
        if aux==n_aceptadas
            instante_llamada_cola(c)=min(t_ocupacion_serv)+.02;
            duracion_llamada_cola(c)=duracion_llamada(i);
            plot([instante_llamada(i) instante_llamada(i) instante_llamada_cola(c)],[0 -.35 0],'c')
            stem(instante_llamada(i),-.35,'r')
            c=c+1;
            n_cola=n_cola+1;
            %Llamadas que se meten en la cola estando la misma vacía
          
            
        end
    else
        s=find(t_ocupacion_serv==min(t_ocupacion_serv));
        t_ocupacion_serv(s)=instante_llamada_cola(1)+duracion_llamada_cola(1);
        r=rand;
        plot([instante_llamada_cola(1) instante_llamada_cola(1) t_ocupacion_serv(s) t_ocupacion_serv(s)],[0 r r 0],'b')
        stem(instante_llamada_cola(1),r,'k')
        instante_llamada_cola=instante_llamada_cola(2:end);
        duracion_llamada_cola=duracion_llamada_cola(2:end);
        c=c-1;
        n_cola_aceptada=n_cola_aceptada+1;
        %Llamadas aceptadas procedentes de la cola
        
        aux2=n_aceptadas2;
        for k=1:length(t_ocupacion_serv)
            if instante_llamada(i)>t_ocupacion_serv(k)
                t_ocupacion_serv(k)=instante_llamada(i)+duracion_llamada(i);
                n_aceptadas2=n_aceptadas2+1;
                plot([instante_llamada(i) instante_llamada(i) t_ocupacion_serv(k) t_ocupacion_serv(k)],[0 altura(i) altura(i) 0],'b')
                stem(instante_llamada(i),altura(i),'g')
                break;
            end
        end
        %Llamadas aceptadas revisando previamente la salida de la cola
        %Se libera en primer lugar la cola, si la siguiente llamada
        %llega fuera del tiempo de ocupacion del servidor, esta es atendida
        
        if aux2==n_aceptadas2;
            instante_llamada_cola(c)=min(t_ocupacion_serv)+.02;
            duracion_llamada_cola(c)=duracion_llamada(i);
            plot([instante_llamada(i) instante_llamada(i) instante_llamada_cola(c)],[0 -.35 0],'c')
            stem(instante_llamada(i),-.35,'r')
            c=c+1;
            n_cola2=n_cola2+1;
            %Llamadas añadidas a la cola revisando previamente la misma
            %Si la llamada que llega despues de atender la cola esta dentro
            %del tiempo de ocupacion del servidor, la llamada se almacena
            %en la cola.
            
        end
    end
end

for j=1:length(instante_llamada_cola)

    for k=1:length(t_ocupacion_serv)
        t_ocupacion_serv(k)=instante_llamada_cola(1)+duracion_llamada_cola(1);
        plot([instante_llamada_cola(1) instante_llamada_cola(1) t_ocupacion_serv(k) t_ocupacion_serv(k)],[0 1 1 0],'b')
        stem(instante_llamada_cola(1),1,'k')
        instante_llamada_cola=instante_llamada_cola(2:end);
        duracion_llamada_cola=duracion_llamada_cola(2:end);
        c=c-1;
        n_restantes=n_restantes+1;
        break;
    end
    %Llamadas aceptadas restantes que quedan en la cola
    
end

suma=0;%Para acumular
for ii=0:N
	suma = suma + A .^ ii ./ factorial(ii);
end
erlang_B = A .^ N ./ (factorial(N) .* suma);
prob_teorica=N*erlang_B/(N-A*(1-erlang_B));
fprintf('Probabilidad teórica de espera: %2.4f \n',prob_teorica)
prob_exp=(n_cola+n_cola2+n_restantes)/trafico_entrante;
fprintf('Probabilidad empírica de espera: %2.4f \n',prob_exp)
