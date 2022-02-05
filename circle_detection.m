%inputimage=imread('location of file');
%radius=[26,30,31,32];
%centures = circle_detection(inputimage,radius)

function centures = circle_detection(inputimage,radius)
i= rgb2gray(inputimage);
edge_image = edge(i, 'canny',[0.01 0.45]);

%image size
[rows,columns]=size(edge_image);% input image dimension
%accumulator
acc=zeros(rows,columns);

% [5] perform Hough transform
for x=1:columns
  for y=1:rows
    if(edge_image(y,x)==1) % detect edge points frim the binary edge image 
      for ang=0:360 % discretized theta
        t=(ang*pi)/180; 
       for g=1:4  % for loop run the input radius values radius=[26,30,31,32];
       r=radius(g);
       a=round(x-r*cos(t)); % 'a' convert to hough space
       b=round(y-r*sin(t)); % 'b' convert to hough space
        if(a & b)
          acc(b,a)=acc(b,a)+1; % store values in the accumulator
        end
       end
      end
    end
  end
end

  
%% [6] show Hough transform
figure(1);
imagesc(b,a, acc);
title('Hough Transform');
xlabel('a');
ylabel('b');
colormap('gray'); hold on;


%% Thresholding and get the center of the circle.
close all;
temp = acc;
temp(find(temp<250))=0; %Thresholding (make zero anything below value of 250 in the accumulator)
imshow(temp,[0 max(temp(:))])
temp = imdilate(temp, ones(6,6)); %Dilating
imshow(temp,[0 max(max(temp))]);
temp = imerode(temp,ones(3,3)); %Eroding
imshow(temp,[0 max(max(temp))]);
s = regionprops(im2bw(temp),'centroid','Perimeter'); %Computing centroid , Center of mass of the region
centroids = cat(1, s.Centroid);%Create and concatenate two matrices vertically, then horizontally.

figure(2)
imshow(i);
hold on;
plot(centroids(:,1), centroids(:,2),'*b')% plot by taking stored radius values in centroids

% Drawing circles
xCenter = [centroids(:,1)];
yCenter = [centroids(:,2)];
centures = [xCenter,yCenter] % showing the x and y values of the centure of circles

for a=1:length(centroids(:,1)) % Draw circles
    
theta = 0 : 0.01 : 2*pi;
x = 30* cos(theta) + xCenter(a);
y = 30* sin(theta) + yCenter(a);
plot(x, y,'g','LineWidth',0.5);

end
