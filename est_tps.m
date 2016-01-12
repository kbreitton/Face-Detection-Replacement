function [a1,ax,ay,w]=est_tps(ctr_pts,target_value)

lambda=0;
i=length(ctr_pts(:,1));
I=eye(i+3);
P=[ctr_pts(:,1),ctr_pts(:,2),ones(i,1)];
Pt=P.';
O=zeros(3,3);

r=pdist2(ctr_pts(:,1:2),ctr_pts(:,1:2));
r=r.^2;
K=r.*log(r);

K(isnan(K))=0;

w=([K,P;Pt,O] + lambda*I)\[target_value;0;0;0];
a1=w(end);
ay=w(end-1);
ax=w(end-2);
w=w(1:end-3);
w(isnan(w))=0;

end