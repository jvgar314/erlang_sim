clc,clear, close all
trafico_entrante=10; %llamadas entrantes
lambda=3;
u_entrada_llamada=rand(1,trafico_entrante);
t_llamadas_exp=-log(1-u_entrada_llamada)/lambda; %transformacion para tiempo entre llamadas
% figure,stem(t_llamadas_exp,ones(1,trafico_entrante)) %representar los instantes de las llamadas
% xlabel('Tiempo entre llamadas')

nu=2; %1/(duracion media de llamada)
u_duracion_llamada=rand(1,trafico_entrante);
duracion_llamada=-log(1-u_duracion_llamada)/nu;
altura=rand(1,trafico_entrante); %alturas para las deltas

t_ocupado=0;
n_aceptadas=0;
n_aceptadas2=0;
n_cola=0;
n_cola2=0;
n_cola_aceptada=0;
instante_llamada_cola=[];
duracion_llamada_cola=[];
c=1;
instante_llamada=cumsum(t_llamadas_exp);
figure, hold on

for i=1:trafico_entrante
    if isempty(instante_llamada_cola)
        if instante_llamada(i)>t_ocupado
            t_ocupado=instante_llamada(i)+duracion_llamada(i);
            n_aceptadas=n_aceptadas+1;
            plot([instante_llamada(i) instante_llamada(i) t_ocupado t_ocupado],[0 altura(i) altura(i) 0],'b')
            stem(instante_llamada(i),altura(i),'g')
            %Llamadas aceptadas con cola vacía
            %(O que vén sendo funcionar normal)
            
        else
            instante_llamada_cola(c)=t_ocupado+.02;
            duracion_llamada_cola(c)=duracion_llamada(i)
            plot([instante_llamada(i) instante_llamada(i) instante_llamada_cola(c)],[0 .35 0],'c')
            stem(instante_llamada(i),.35,'r')
            c=c+1;
            n_cola=n_cola+1;
            %Llamadas que se meten en la cola estando la misma vacía
            %(Se o aparato está atorado metes na cola o temorio)
            
        end
    else
        t_ocupado=instante_llamada_cola(1)+duracion_llamada_cola(1);
        r=rand;
        plot([instante_llamada_cola(1) instante_llamada_cola(1) t_ocupado t_ocupado],[0 r r 0],'b')
        stem(instante_llamada_cola(1),r,'k')
        instante_llamada_cola=instante_llamada_cola(2:end);
        duracion_llamada_cola=duracion_llamada_cola(2:end);
        c=c-1;
        n_cola_aceptada=n_cola_aceptada+1;
        %Llamadas aceptadas procedentes de la cola
        %(Se hai algo na cola hai que botalo fóra antes de nada para que
        %non toque o carallo)
        
        
        if instante_llamada(i)>t_ocupado
            t_ocupado=instante_llamada(i)+duracion_llamada(i);
            n_aceptadas2=n_aceptadas2+1;
            plot([instante_llamada(i) instante_llamada(i) t_ocupado t_ocupado],[0 altura(i) altura(i) 0],'b')
            stem(instante_llamada(i),altura(i),'g')
            %Llamadas aceptadas revisando previamente la salida de la cola
            %Se libera en primer lugar la cola, si la siguiente llamada
            %llega fuera del tiempo de ocupacion del servidor, esta es atendida
            %(Cando sacas merda da cola estás no instante no que miras a
            %chamada seguinte, entonces hai que procesar esa que entra.
            %Aquí chégache cando o servidor está parado, logo podes
            %atender o tema)
            
        else
            instante_llamada_cola(c)=t_ocupado+.02;
            duracion_llamada_cola(c)=duracion_llamada(i);
            plot([instante_llamada(i) instante_llamada(i) instante_llamada_cola(c)],[0 .35 0],'c')
            stem(instante_llamada(i),.35,'r')
            c=c+1;
            n_cola2=n_cola2+1;
            %Llamadas añadidas a la cola revisando previamente la misma
            %Si la llamada que llega despues de atender la cola esta dentro
            %del tiempo de ocupacion del servidor, la llamada se almacena
            %en la cola.
            %(Igual que no caso anterior, solo que aquí o que pasa é que a
            %chamada que entra aparece cando o aparato está dando gas,
            %entonces tela que meter la cola. Hai que estar)
            
        end
    end
end

for j=1:length(instante_llamada_cola)
    t_ocupado=instante_llamada_cola(1)+duracion_llamada_cola(1);
    plot([instante_llamada_cola(1) instante_llamada_cola(1) t_ocupado t_ocupado],[0 1 1 0],'b')
    stem(instante_llamada_cola(1),1,'k')
    instante_llamada_cola=instante_llamada_cola(2:end);
    duracion_llamada_cola=duracion_llamada_cola(2:end);
    c=c-1;
    n_cola_aceptada=n_cola_aceptada+1;
    %Llamadas aceptadas restantes que quedan en la cola
    %(Sempre queda algo ao final. Hai que botalo fóra.)
    
end
