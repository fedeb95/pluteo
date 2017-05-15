clear lines;
gray = rgb2gray(imread('pluteo.jpg'));
%ker = 1/9 * ones(3);
%gray = imfilter(im2double(gray),ker);
BW = edge(gray,'canny',0.1);
BW2 = bwmorph(BW,'bridge');
[H,T,R] = hough(BW);
P  = houghpeaks(H,3,'threshold',ceil(0.2*max(H(:))));
x = T(P(:,2)); y = R(P(:,1));
lines = houghlines(BW2,T,R,P,'FillGap',70,'MinLength',100);
figure, subplot(2,2,1), imshow(gray), hold on
max_len1 = 0;
max_len2 = 0;
xy_long1 = 0; xy_long2 = 0;
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   % skips lines caused by microscope
   if (lines(k).theta == -90 || lines(k).theta == 90)
       continue;
   end
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

   % Determine the endpoints of the longest line segment
   len = norm(lines(k).point1 - lines(k).point2);
   if ( len > max_len1)
        max_len2 = max_len1;
        max_len1 = len;
        xy_long2 = xy_long1;
        xy_long1 = xy;
   elseif ( len > max_len2)
        max_len2 = len;
        xy_long2 = xy;
   end
end

subplot(2,2,2), imshow(BW);
subplot(2,2,3), imshow(BW2);

width = norm(xy_long1(1,:) - xy_long2(1,:));
length = sqrt((max_len1^2) - (width/2)^2);

disp('body length: ' + string(length) +' from '+ string(max_len1) + ' ' + string(max_len2));
disp('body width: ' + string(width));