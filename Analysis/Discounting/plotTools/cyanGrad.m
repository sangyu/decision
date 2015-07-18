%Colormap
function c = cyanGrad(m)

if nargin < 1
    m = size(get(gcf, 'colormap'), 1);
end

r = [(m-1)/2:.5:m-1]/max(m-1, 1); 
c = [ (1-r'),  ones(m, 1)*0.8, ones(m, 1)*0.8];

return;