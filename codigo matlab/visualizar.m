load muestras_hola.mat

norm1=[]
norm1(:,1)= muestras(15).v_tiempo
norm1(:,2)= muestras(15).amplitud
norm1(:,2)=norm1(:,2)/max(norm1(:,2))
plot(norm1(:,1),norm1(:,2))

figure
 norm2=[]
norm2(:,1)= muestras(15).v_tiempo
norm2(:,2)= muestras(15).amplitud
norm2(:,2)=norm2(:,2)/max(norm2(:,2))
plot(norm2(:,1),norm2(:,2))