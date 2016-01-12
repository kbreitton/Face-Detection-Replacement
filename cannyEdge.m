function E = cannyEdge(I, high_threshold_factor, low_threshold_factor)
tic

%read in grayscale image
ourImage = rgb2gray(I);

% ourImage = I;

%figure(1)
%imshow(ourImage);axis image;
dx=[1 -1];
dy=[1;-1];
G = fspecial('gaussian', 5, 4);
[Gx, Gy] = gradient(G);
Gx = Gx(:, [1 2 4 5]);
Gy = Gy([1 2 4 5], :);

%convolution
jx=conv2(double(ourImage),Gx,'same');
jy=conv2(double(ourImage),Gy,'same');

%calculate the magnitude
magnitude = sqrt(jx.^2 + jy.^2);

%calculate the gradient and edge directions
dirGradient = atan2d(jy, jx);

dirGradient(dirGradient < 0) = dirGradient(dirGradient < 0) + 360;

dirEdge_1= dirGradient+90; %two edge directions
dirEdge_2= dirGradient - 90;

%round the angles
% dirGradient = round(dirGradient);
% dirEdge_1= round(dirEdge_1);
% dirEdge_2= round(dirEdge_1);

max=0;
maxi=0;
maxj=0;

%determine where the maximum is along the gradient direction for each pixel
%first assume every pixel is an edge, and compare each pixel to the next
%one along its edge gradient and set a pixel to 0 (not an edge) if it is
%less than the next

%direction of next pixel to compare with is determined by mapping a 9x9
%pixel square around each pixel in 360 degree coordiantes
isMax=ones(length(dirGradient(:,1)),length(dirGradient(1,:)));
for i=3:length(dirGradient(:,1))-2
    for j = 3:length(dirGradient(1,:))-2
        if isMax(i,j) == 0 %if pixel already known to not be a local maximum, pass
            continue
        else
            
            %             i_next = round(i - sind(dirGradient(i,j))); %mark where the next pixel is...flip the sine because matrices in MATLAB go downwards for positive indices
            %             j_next = round(j + cosd(dirGradient(i,j)));
            %
            %             i_next_next = round(i - 2*sind(dirGradient(i,j))); %mark where the next pixel is...flip the sine because matrices in MATLAB go downwards for positive indices
            %             j_next_next = round(j + 2*cosd(dirGradient(i,j)));
            %
            %             %****comparing the next 2 pixel directions
            %             if magnitude(i_next,j_next) > magnitude(i,j) || magnitude(i_next_next,j_next_next) > magnitude(i,j) %if next or next_next > current
            %                 isMax(i,j)=0; %current is not an edge
            %                 if magnitude(i_next,j_next) > magnitude(i_next_next,j_next_next)
            %                     isMax(i_next_next, j_next_next) = 0; %next_next is also not an edge
            %                 else
            %                     isMax(i_next, j_next) = 0;
            %                 end
            %             elseif magnitude(i_next,j_next) > magnitude(i_next_next,j_next_next)
            %                 isMax(i_next_next, j_next_next) = 0;
            %
            %                 if magnitude(i_next,j_next) > magnitude(i,j)
            %                     isMax(i, j) = 0; %current is also not an edge
            %                 else
            %                     isMax(i_next, j_next) = 0;
            %                 end
            %             else
            %                 isMax(i_next, j_next) = 0;
            %                 if magnitude(i_next_next,j_next_next) > magnitude(i,j)
            %                     isMax(i, j) = 0; %current is also not an edge
            %                 else
            %                     isMax(i_next_next, j_next_next) = 0;
            %                 end
            %             end
            
            %interpolate for the next magnitude to compare to
            i_next = i - sind(dirGradient(i,j));
            j_next = j + cosd(dirGradient(i,j));
            
            i_next_1 = round(i - sind(dirGradient(i,j)));
            j_next_1 = round(j + cosd(dirGradient(i,j)));
            
            i_next_2 = round(i - cosd(dirGradient(i,j)));
            j_next_2 = round(j + sind(dirGradient(i,j)));
            
            alpha = sqrt((i_next - i_next_1)^2 + (j_next - j_next_1)^2);
            
            next_mag = alpha *magnitude(i_next_2, j_next_2) + (1-alpha)*magnitude(i_next_1, j_next_1);
            
            if next_mag > magnitude(i,j) %if next > current
                isMax(i,j)=0; %current is not an edge
            else
                isMax(i_next_1, j_next_1) = 0; %next is not an edge
                
            end
            
        end
    end
end

isMax=isMax.*magnitude;
%imagesc(isMax);

%edge linking
visited = zeros(length(magnitude(:,1)), length(magnitude(1,:)));

%set low threshold to 1 stdev away from mean of isMax edge values
high_threshold =  mean(mean(isMax(isMax>0))) * high_threshold_factor;
low_threshold =  mean(mean(isMax(isMax>0))) * low_threshold_factor;


walk = true;
rowL=length(dirGradient(:,1))-1;
colL=length(dirGradient(1,:))-1;
E = zeros(rowL +1, colL + 1); % output (binary), initialized to all zero


low_threshold_saved = low_threshold;
%zero pad isMax
% isMax_pad =zeros(rowL + 2, colL + 2);
% isMax_pad([2:length(isMax_pad(:,1))-1],[2:length(isMax_pad(1,:))-1]) = isMax;

%algorithm flow follows what was posted on the wiki
for i=4:rowL-3
    for j = 4:colL-3
        
        if isMax(i,j) > high_threshold && visited(i,j) == 0 && walk == true %if previously unvisited and walk = true, and if a local maxima pass a high threshold
            
            i_saved = i;
            j_saved = j;
            
            i_next_1 = round(i - sind(dirEdge_1(i,j))); %mark the 'previous' and next' along the edge
            j_next_1 = round(j + cosd(dirEdge_1(i,j)));
            
            i_next_2 = round(i - sind(dirEdge_2(i,j)));
            j_next_2 = round(j + cosd(dirEdge_2(i,j)));
            
            if isMax(i_next_1,j_next_1) > isMax(i_next_2,j_next_2) && visited(i_next_1,j_next_1) == 0 %choose which direction the edge is really along
                direction = 1;
            elseif isMax(i_next_2,j_next_2) > isMax(i_next_1,j_next_1) && visited(i_next_2,j_next_2) == 0
                direction = 2;
            else
                continue
            end;
            
            %******************
            
            switch direction %switch case for continuing along the chosen edge direction
                
                case 1
                    
                    
                    while walk
                        if visited(i,j) == 0 && walk == true
                            visited(i,j) = 1; %mark current as visited
                            
                            
                            i_next = round(i - sind(dirEdge_1(i,j))); %update next
                            j_next = round(j + cosd(dirEdge_1(i,j)));
                            
                            
                            
                            
                            if i > rowL || j > colL || i <= 0 || j <= 0 %check if i,j out of bounds
                                break;
                            elseif i_next >rowL || j_next >colL || i_next <= 0 || j_next <= 0 %check if i,j are out of bounds
                                visited(i,j) = 1;
                                break;
                            end
                            
                            if(isMax(i_next,j_next) > isMax(i,j)) && visited(i_next, j_next) == 0 %if edge next > current *and* next is unvisited
                                E(i,j) = 1; %plot the current point
                                
                                i = i_next; %set current = next
                                j = j_next;
                                
                                i_next = round(i - sind(dirEdge_1(i,j)));
                                j_next = round(j + cosd(dirEdge_1(i,j)));
                                
                                
                                if isMax(i,j) > low_threshold %if magnitude passes threshold
                                    low_threshold = low_threshold * 0.50; %reduce the low threshold (benefit of the doubt)
                                    E(i,j) = 1; %plot(record) the next point
                                    
                                else
                                    walk = false; %else set walk to false
                                end
                                
                            elseif isMax(i_next,j_next) > low_threshold %if next !> current, check if next is at least above the dynamic lower threshold
                                %                         visited(i,j) = 1; %mark current as visited
                                low_threshold = low_threshold * 0.50; %reduce the low threshold (benefit of the doubt)
                                
                                E(i,j) = 1; %plot the current point
                                
                                i = i_next;%set current = next
                                j = j_next;
                                
                                E(i,j) = 1; %plot the next point
                                
                                i_next = round(i - sind(dirEdge_1(i,j))); %update next
                                j_next = round(j + cosd(dirEdge_1(i,j)));
                                
                            else %if fail the low threshold
                                
                                visited(i,j) = 1; %mark current as visited
                                walk = false; %set walk = false
                            end
                        else
                            break;
                        end
                    end
                    
                    %**********************************
                case 2
                    
                    while walk
                        if visited(i,j) == 0 && walk == true
                            visited(i,j) = 1; %mark current as visited
                            
                            
                            i_next = round(i - sind(dirEdge_2(i,j))); %mark next
                            j_next = round(j + cosd(dirEdge_2(i,j)));
                            
                            
                            if i > rowL || j > colL || i <= 0 || j <= 0 %check if i,j out of bounds
                                break;
                            elseif i_next >rowL || j_next >colL || i_next <= 0 || j_next <= 0 %check if i,j are out of bounds
                                visited(i,j) = 1;
                                break;
                            end
                            
                            if(isMax(i_next,j_next) > isMax(i,j)) && visited(i_next, j_next) == 0 %if edge next > current *and* next is unvisited
                                E(i,j) = 1; %plot the current point
                                
                                i = i_next; %set current = next
                                j = j_next;
                                
                                i_next = round(i - sind(dirEdge_2(i,j))); %update next
                                j_next = round(j + cosd(dirEdge_2(i,j)));
                                
                                
                                
                                if isMax(i,j) > low_threshold %if magnitude passes threshold
                                    low_threshold = low_threshold * 0.50; %reduce the low threshold (benefit of the doubt)
                                    E(i,j) = 1; %plot(record) the next point
                                    
                                else
                                    walk = false; %else set walk to false
                                end
                                
                            elseif isMax(i_next,j_next) > low_threshold %if next !> current, check if next is at least above the dynamic lower threshold
                                %                         visited(i,j) = 1; %mark current as visited
                                low_threshold = low_threshold * 0.50; %reduce the low threshold (benefit of the doubt)
                                
                                E(i,j) = 1; %plot the current point
                                
                                i = i_next;%set current = next
                                j = j_next;
                                
                                E(i,j) = 1; %plot the next point
                                
                                i_next = round(i - sind(dirEdge_2(i,j))); % update next
                                j_next = round(j + cosd(dirEdge_2(i,j)));
                                
                            else %if fail the low threshold
                                
                                visited(i,j) = 1; %mark current as visited
                                walk = false; %set walk = false
                            end
                        else
                            break;
                        end
                        
                    end
                    
                    
            end
            %*********************************
            
            %reset everything after exiting the walk recursion
            walk = true;
            i = i_saved;
            j = j_saved;
            low_threshold = low_threshold_saved; %reset the lower threshold value
            
        else
            visited(i,j) = 1; %if fail the high threshold, just mark as visited
        end
        
    end
    
end

% figure(1)
% imshow(isMax > high_threshold);

% figure(1)
% imshow(E);

% cleaning up the output
E = bwmorph(E, 'clean');
% E = bwmorph(E, 'bridge');
% E = bwmorph(E, 'shrink');
% E = bwmorph(E, 'thin');


% imshow(E)
end
