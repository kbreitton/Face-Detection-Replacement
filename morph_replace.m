function Y=morph_replace(im1,im2,im1_pts, im2_pts,im2hull)

%% resizing image and control points
        [size1x, size1y,~]=size(im1);
        [size2x, size2y,~]=size(im2);
        
        im1=imresize(im1,[size2x, size2y]);
        x_frac=size2x/size1x;
        y_frac=size2y/size1y;
        im1_pts(:,1)=round(im1_pts(:,1)*x_frac);
        im1_pts(:,2)=round(im1_pts(:,2)*y_frac);              
    
    [a1_x,ax_x,ay_x,w_x]=est_tps(im2_pts,im1_pts(:,1));
    [a1_y,ax_y,ay_y,w_y]=est_tps(im2_pts,im1_pts(:,2));
    im1_morphed=morph_tsp(im1,a1_x,ax_x,ay_x,w_x,a1_y,ax_y,ay_y,w_y,im2_pts);
    figure(9)
    imshow(im1_morphed);
    
%% making hull into rgb
    im2hull_rgb(:,:,1)=im2hull;
    im2hull_rgb(:,:,2)=im2hull;
    im2hull_rgb(:,:,3)=im2hull;
    
%% replacing face    
    im2_replaced=immultiply(im1_morphed,im2hull_rgb) + immultiply(im2,~(im2hull_rgb));
    figure(10)
    imshow(im2_replaced);
    
%% blending

% [im1Grad_ver, im1Grad_hor] = imgrad(double(im1_morphed));
% [im2Grad_ver, im2Grad_hor] = imgrad(double(im2));
dx=[1,-1];
dy=[1;-1];

im2Grad_hor(:,:,1)=conv2(im2(:,:,1),dx,'same');
im2Grad_ver(:,:,1)=conv2(im2(:,:,1),dy,'same');
im2Grad_hor(:,:,2)=conv2(im2(:,:,2),dx,'same');
im2Grad_ver(:,:,2)=conv2(im2(:,:,2),dy,'same');
im2Grad_hor(:,:,3)=conv2(im2(:,:,3),dx,'same');
im2Grad_ver(:,:,3)=conv2(im2(:,:,3),dy,'same');

im1Grad_hor(:,:,1)=conv2(im1_morphed(:,:,1),dx,'same');
im1Grad_ver(:,:,1)=conv2(im1_morphed(:,:,1),dy,'same');
im1Grad_hor(:,:,2)=conv2(im1_morphed(:,:,2),dx,'same');
im1Grad_ver(:,:,2)=conv2(im1_morphed(:,:,2),dy,'same');
im1Grad_hor(:,:,3)=conv2(im1_morphed(:,:,3),dx,'same');
im1Grad_ver(:,:,3)=conv2(im1_morphed(:,:,3),dy,'same');
% 
% figure(1)
% imshow(im1Grad_hor);
% figure(2)
% imshow(im1Grad_ver);
% figure(3)
% imshow(im2Grad_hor);
% figure(4)
% imshow(im2Grad_ver);

X = double(im2_replaced);
Fh=immultiply(im1Grad_hor,im2hull_rgb) + immultiply(im2Grad_hor,~im2hull_rgb);
Fv=immultiply(im1Grad_ver,im2hull_rgb) + immultiply(im2Grad_ver,~im2hull_rgb);

mask(:,:,1)=im2hull;
mask(:,:,2)=im2hull;
mask(:,:,3)=im2hull;

Y = PoissonGaussSeidel( X, Fh, Fv, mask);

imwrite(uint8(Y),'replaced.jpg');
figure(11);
imshow(uint8(Y));

Y = uint8(Y);

end