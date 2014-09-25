%Colormap
function c = april(m)

if nargin < 1
    m = size(get(gcf, 'colormap'), 1);
end

r = (0:m-1)' / max(m-1, 1); 
c = [1-r, r, r];

return;