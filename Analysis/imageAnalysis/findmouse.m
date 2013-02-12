%% Image processing

theta=-6;

b=imrotate(x0, theta);


c=b(250:740, 510:950);
imshow(c)

d=ADAPTHISTEQ(c);
imshow(d)

e=2*(180-d(:,:,1));
imshow(e)

[junk threshold] = edge(e, 'sobel');
fudgeFactor = .5;
BWs = edge(e,'sobel', threshold * fudgeFactor);
figure, imshow(BWs), title('binary gradient mask');
se90 = strel('line', 3, 90);
se0 = strel('line', 10, 0);
BWsdil = imdilate(BWs, [se90 se0]);
figure, imshow(BWsdil), title('dilated gradient mask');
BWdfill = imfill(BWsdil, 'holes');
figure, imshow(BWdfill);
title('binary image with filled holes');


%% Image processing

theta=-6;

f=imrotate(x1, theta);


g=f(250:740, 510:950);
imshow(g)

h=ADAPTHISTEQ(g);
imshow(g)

i=2*(180-g(:,:,1));
imshow(e)

[junk threshold] = edge(i, 'sobel');
fudgeFactor = .5;
BWs2 = edge(i,'sobel', threshold * fudgeFactor);
figure, imshow(BWs2), title('binary gradient mask');
se90 = strel('line', 3, 90);
se0 = strel('line', 20, 0);
BWsdil2 = imdilate(BWs2, [se90 se0]);
figure, imshow(BWsdil2), title('dilated gradient mask');
BWdfill2 = imfill(BWsdil2, 'holes');
figure, imshow(BWdfill2);
title('binary image with filled holes');



delta=BWdfill-BWdfill2

imshow(delta)