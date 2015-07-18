%Colormap
function c = greenGrad(m)

if nargin < 1
    m = size(get(gcf, 'colormap'), 1);
end
greenHSV=rgb2hsv([ 0.2000    0.8500    0.7500]);
r = [(m-1)/2:.5:m-1]/max(m-1, 1); 
c = [ ones(m, 1)*greenHSV(1),r'*greenHSV(2), ones(m, 1)*greenHSV(3)];
c = hsv2rgb(c);
return;