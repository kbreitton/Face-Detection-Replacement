function morphed_im=morph_tsp(im_source,a1_x,ax_x,ay_x,w_x,a1_y,ax_y,ay_y,w_y,ctr_pts)

[row,col,~]=size(im_source);

f=(1:col)';
f=repmat(f,1,row)';
f=f(:);

g=(1:row)';
g=repmat(g,col,1);

fg=[f,g];

r_2d=pdist2(fg,ctr_pts);
r_2d=r_2d';
r=r_2d(:);
r=r.^2;
U=r.*log(r);
U(isnan(U))=0;

w_xR=repmat(w_x,row*col,1);
w_yR=repmat(w_y,row*col,1);
w_xU=w_xR.*U;
w_yU=w_yR.*U;
% summation1=sum(w_xU,2);
% summation2=sum(w_yU,2);
summation1=sum(reshape(w_xU,length(w_x),row*col));
summation2=sum(reshape(w_yU,length(w_y),row*col));
summation1=summation1';
summation2=summation2';

% frep=kron(f,ones(length(w_x),1));
% grep=kron(g,ones(length(w_y),1));
% fcol=a1_x+(ax_x*frep)+(ay_x*grep)+summation1;
% frow=a1_y+(ax_y*frep)+(ay_y*grep)+summation2;

fcol=a1_x+(ax_x*f)+(ay_x*g)+summation1;
frow=a1_y+(ax_y*f)+(ay_y*g)+summation2;

fcol=round(fcol);
frow=round(frow);

fcol(fcol>col)=col;
frow(frow>row)=row;
fcol(fcol<1)=1;
frow(frow<1)=1;

% fcolMat=vec2mat(fcol,row)';
% frowMat=vec2mat(frow,row)';

im_sourceR=im_source(:,:,1);
im_sourceG=im_source(:,:,2);
im_sourceB=im_source(:,:,3);

indices=sub2ind(size(im_sourceR),frow,fcol);
temp_morphedR=im_sourceR(indices);
temp_morphedR=vec2mat(temp_morphedR,row);
temp_morphedR=temp_morphedR';

temp_morphedG=im_sourceG(indices);
temp_morphedG=vec2mat(temp_morphedG,row);
temp_morphedG=temp_morphedG';

temp_morphedB=im_sourceB(indices);
temp_morphedB=vec2mat(temp_morphedB,row);
temp_morphedB=temp_morphedB';

morphed_im(:,:,1)=temp_morphedR;
morphed_im(:,:,2)=temp_morphedG;
morphed_im(:,:,3)=temp_morphedB;
% for f=1:col
%     for g=1:row
%         summation1=0;
%         summation2=0;
%         for h=1:p
%             r=(ctr_pts(h,1)-f)^2 + (ctr_pts(h,2)-g)^2;
%             
%             U=r *log(r);
%             U(isnan(U))=0;
%             summation1=summation1+ (w_x(h)*U);
%             summation2=summation2+ (w_y(h)*U);
%         end
%         fcol=a1_x+ax_x*f+ay_x*g+summation1; %fx
%         frow=a1_y+ax_y*f+ay_y*g+summation2; %fy
%         
%         frow=round(frow);
%         fcol=round(fcol);
%         if frow<1
%             frow=1;
%         end
%         if fcol<1
%             fcol=1;
%         end
%         if frow>row
%             frow=row;
%         end
%         if fcol>col
%             fcol=col;
%         end
%         
%         morphed_im(g,f,:)=im_source(frowMat(g,f),fcolMat(g,f),:);
%     end   
%     f
% end
end