x1min=min(X(:,1));
x1max=max(X(:,1));
x2min=min(X(:,2));
x2max=max(X(:,2));
x1=x1min:0.01:x1max;
x2=x2min:0.01:x2max;
[Xg,Yg] = meshgrid(x1,x2);
f=teta(1)*Xg+teta(2)*Yg+teta(3);
fp=-ones(size(Xg));
fp(f>=0)=1;
figure
imagesc(x1,x2,fp);
axis xy
colormap('summer')
colorbar