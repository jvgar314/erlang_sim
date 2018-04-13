% Erlang B (1 servidor)

clc,clear, close all
trafico_entrante=5; %llamadas entrantes
lambda=3;
u_entrada_llamada=rand(1,trafico_entrante);
t_llamadas_exp=-log(1-u_entrada_llamada)/lambda; %transformacion para tiempo entre llamadas
figure,stem(t_llamadas_exp,ones(1,trafico_entrante)) %representar los instantes de las llamadas
xlabel('Tiempo entre llamadas')

nu=2; %1/(duracion media de llamada)
u_duracion_llamada=rand(1,trafico_entrante);
duracion_llamada=-log(1-u_duracion_llamada)/nu;

t_ocupado=0;
n_aceptadas=0;
n_block=0;
instantes_llamadas=cumsum(t_llamadas_exp);%acumular instantes de las llamadas
figure, hold on
for i=1:trafico_entrante
    if instantes_llamadas(i)>t_ocupado
       t_ocupado=instantes_llamadas(i)+duracion_llamada(i);
       plot([instantes_llamadas(i) instantes_llamadas(i) t_ocupado t_ocupado],[0 1 1 0],'b')
       stem(instantes_llamadas(i),1,'g')
       n_aceptadas=n_aceptadas+1;
    else
        stem(instantes_llamadas(i),-1,'r')
        n_block=n_block+1;
    end
end
hold off