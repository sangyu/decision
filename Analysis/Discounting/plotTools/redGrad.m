%Colormap
function c = redGrad(m)

if nargin < 1
    m = size(get(gcf, 'colormap'), 1);
end

r = [(m-1)/2:.5:m-1]/max(m-1, 1); 
c = [ones(m, 1)*.85, 1-r', 1-r'];

return;