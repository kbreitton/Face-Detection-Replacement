function plot_boundingBoxes(im, boundingBoxes, shapeInserter)
rects=[boundingBoxes(:,1),boundingBoxes(:,2),boundingBoxes(:,3) - boundingBoxes(:,1), boundingBoxes(:,4) - boundingBoxes(:,2)];
J = step(shapeInserter, im, int32(rects));
figure(1)
imshow(J)
end