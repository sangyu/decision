% SYNTAX
%  computeROCCurve(coefficients, regressionStats, regressors, regressorIndices, xAxisIndex, plottingCategories)
%  computeROCCurve(..., 'axes', ax, 'colormap', cmap)
%   coefficients - The coefficients array returned from glmfit.
%   regressionStats - The stats object returned from glmfit.
%   regressors - The original data matrix passed into glmfit.
%   regressorIndices - The column indices into the regressors over which to plot data points.
%                This must be one of the regressorIndices values.
%                Default: 1
%   plottingCategories - The indices of the regressorValues that define the separate curves to be plotted.
%                        One line will be plotted for each unique value in the specified regressorValues element.
%                        Default: 1
%   ax - The axes in which the regression is plotted (may be passed in as well as returned, to allow adding plots to existing axes).
%        Default: gca
%   cmap - The color map used for plotting.
%          Default: april
%   auROC - The area under the ROC curve(s), may be an array if multiple plots are requested via plottingCategories.
%   x, y - The data points from the plot, may be cell arrays of arrags if multiple plots are requested via plottingCategories.
function [auROC, x, y] = computeROCcurve(coefficients, regressionStats, regressors, regressorIndices, varargin)

%Process arguments.
ax = [];
if exist('april', 'file') == 2
    %numPlots = 0;
    %for i = 1 : length(regressorIndices)
    %    numPlots = numPlots + length(unique(regressors(:, regressorIndices)));
    %end
    cmap = april(length(regressorIndices));
else
    cmap = [];
end
xAxisIndex = 1;
plottingCategories = 1;
if ~isempty(varargin)
    xAxisIndex = varargin{1};
    plottingCategories = varargin{2};
end
for i = 2 : 2 : length(varargin)
    if strcmpi(varargin{i}, 'axes')
        ax = varargin{i + 1};
    elseif strcmpi(varargin{i}, 'colormap')
        cmap = varargin{i + 1};
    end
end
if isempty(ax)
    ax = gca;
end
if isempty(cmap)
    cmap = get(ax, 'ColorOrder');
end
if ~any(xAxisIndex == regressorIndices)
    error('The xAxisIndes must be one of the regressorIndices values.');
end
if length(coefficients) ~= length(regressorIndices) + 1
    error('The number of coefficients (from glmfit) must match the number of regressorIndices.');
end

regressorValues = cell(size(regressorIndices));
rvLen = zeros(size(regressorIndices));
for i = 1 : length(regressorIndices)
    regressorValues{i} = unique(regressors(:, regressorIndices(i)));
    rvLen(i) = length(regressorValues{i});
end
mxRVLen = max(rvLen);

% %Change the coordinate system for the indices, from the original data matrix to the combination matrix.
% xInputIndices = 1 : length(regressorIndices);%This may be unnecessary now, but leaves flexibility as we keep changing our minds.
% xAxisIndex2 = find(xAxisIndex == regressorIndices);

% % categories = makeCombinations(regressorValues(plottingCategories));
% %Enumerate the combinations.
% xInput = makeCombinations(regressorValues);
% rowCount = size(xInput, 1);

%Generate the plot data from the fit coefficients.
olderStats = verLessThan('stats', '7.6');
hold on;
% numPoints = rowCount / mxRVLen;
% [xInput, ~] = sortrows(xInput, xInputIndices(xInputIndices ~= xAxisIndex2));
% for i = 1 : numPoints
%     rangeStart = (i - 1) * mxRVLen + 1;
%     rangeEnd = rangeStart + mxRVLen - 1;
%     if olderStats
%         p = glmval(coefficients, xInput(rangeStart : rangeEnd, :), 'logit', regressionStats);
%     else
%         p = glmval(coefficients, xInput(rangeStart : rangeEnd, :), 'logit', regressionStats, 'simultaneous', true);
%     end
%     %Compute the ROC and plot it.
%     [x, y, ~, auROC] = perfcurve(xInput(rangeStart : rangeEnd, plottingCategories), p, 1);
%     if i <= size(cmap, 1)
%         color = cmap(i, :);
%     else
%         color = cmap(mod(size(cmap, 1), i), :);
%     end
%     plot(ax, x, y, 'Color', color);
% end
if olderStats
    p = glmval(coefficients, regressors(:, regressorIndices), 'logit', regressionStats);
else
    p = glmval(coefficients, regressors(:, regressorIndices), 'logit', regressionStats, 'simultaneous', true);
end

x = cell(size(plottingCategories));
y = cell(size(plottingCategories));
auROC = zeros(size(plottingCategories));
for i = 1 : length(plottingCategories)
    %Compute the ROC and plot it.
    [x{i}, y{i}, ~, auROC(i)] = perfcurve(regressors(:, plottingCategories(i)), p, 1);
    if i <= size(cmap, 1)
        color = cmap(i, :);
    else
        color = cmap(mod(size(cmap, 1), i), :);
    end
    plot(ax, x{i}, y{i}, 'Color', color);
end

if nargout > 1 && length(x) == 1 && length(y) == 1
    x = x{1};
    y = y{1};
end

return;

%--------------------------------------------------------------------------
function xInput = makeCombinations(regressorValues)

%Enumerate the combinations.
rowCount = 1;
for i = 1 : length(regressorValues)
    rowCount = rowCount * length(regressorValues{i});
end
xInput = zeros(rowCount, length(regressorValues));%Pre-allocate for speed.
%Implement using orthogonal roll-over.
indices = ones(size(regressorValues));
for i = 1 : rowCount
    %Fill the current row.
    for j = 1 : size(xInput, 2)
        xInput(i, j) = regressorValues{j}(indices(j));
    end
    %Increment across columns (left to right), rolling over as necessary.
    k = 1;
    indices(k) = indices(k) + 1;
    %Roll over.
    while k < length(indices) && indices(k) > length(regressorValues{k})
        indices(k) = 1;
        k = k + 1;
        indices(k) = indices(k) + 1;
    end
    if indices(k) > indices(k)
        indices(k) = 1;
    end
end

return;