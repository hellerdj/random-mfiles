% load hald% [pc,score,latent,tsquare] = princomp(ingredients);x1 = [0:.1:4]';s = [1 .4;.4 3]mu = [2 3]x = mvnrnd(mu,s,50);hold off, plot(x(:,1), x(:,2),'o'),hold oncorrcoef(x)sqrtm(cov(x))[pc,score,latent,tsquare] = princomp(x);pchold off% A = [ones(size(x1)) x1];% plot(x1,A*pc(1,:)')   % nope% plot([x1 x1] * pc(:,1))hold off, plot(x(:,1), x(:,2),'o'),hold on% the columns of the pc are the principal componentsline(mean(x(:,1))+latent(1)*[0 pc(1,1)], mean(x(:,2))+latent(1) * [0 pc(2,1)])line(mean(x(:,1))-latent(1)*[0 pc(1,1)], mean(x(:,2))-latent(1) * [0 pc(2,1)])line(mean(x(:,1))+latent(2)*[0 pc(1,2)], mean(x(:,2))+latent(2) * [0 pc(2,2)])line(mean(x(:,1))-latent(2)*[0 pc(1,2)], mean(x(:,2))-latent(2) * [0 pc(2,2)])axis('square')axis('equal')% size(score)% plot(score,'.')size(latent)[xe ye] = ellipse(0,0,latent(1),latent(2));% plot(xe,ye)th = atan2(pc(1,2),pc(1,1));   % thetaq = mean(x);[er] = [xe' ye'] * [cos(th) sin(th); -sin(th) cos(th)] + q(ones(size(xe',1),1),:);plot(er(:,1),er(:,2))