% SYNTAX
%  plotLogisticRegression(coefficients, regressionStats, regressors, regressorIndices)
%  plotLogisticRegression(coefficients, regressionStats, regressors, regressorIndices, xAxisIndex, plottingCategories)
%  plotLogisticRegression(coefficients, regressionStats, regressors, regressorIndices, xAxisIndex, plottingCategories, 'axes', ax, 'colormap', cmap)
%  [ax, lineHandles, patchHandles] = plotLogisticRegression(...)
%   coefficients - The coefficients array returned from glmfit.
%   regressionStats - The stats object returned from glmfit.
%   regressors - The original data matrix passed into glmfit.
%   regressorIndices - The column indices into the regressors over which to plot data points.
%   xAxisIndex - The index into the coefficients and regressorValues arrays that corresponds to the x-axis.
%                This must be one of the regressorIndices values.
%                Default: 1
%   plottingCategories - The indices of the regressorValues that define the separate curves to be plotted.
%                        One line will be plotted for each unique value in the specified regressorValues element.
%                        Default: 1
%   ax - The axes in which the regression is plotted (may be passed in as well as returned, to allow adding plots to existing axes).
%        Default: gca
%   lineHandles - The handles to the resulting lines in that have been plotted.
%   patchHandles - The handles to the patch objects used to create the shaded boundaries in the plot.
%
% EXAMPLE
%  %Regress against columns 2 and 3.
%  [coefficients, deviances, regressionStats] = glmfit(MVmatrix(:, [2, 3]), MVmatrix(:, 1), 'binomial', 'link', 'logit');
%  %Plot the regression with column 2 as the x-axis.
%  plotLogisticRegression(coefficients, regressionStats, MVmatrix, [2, 3], 2, [3, 4]);
%
% SEE ALSO - combnk, perms
function varargout = plotLogisticRegression(coefficients, regressionStats, regressors, regressorIndices, varargin)

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
for i = 3 : 2 : length(varargin)
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

%Change the coordinate system for the indices, from the original data matrix to the combination matrix.
xInputIndices = 1 : length(regressorIndices);%This may be unnecessary now, but leaves flexibility as we keep changing our minds.
xAxisIndex2 = find(xAxisIndex == regressorIndices);

% categories = makeCombinations(regressorValues(plottingCategories));
%Enumerate the combinations.
xInput = makeCombinations(regressorValues);
rowCount = size(xInput, 1);

%Generate the plot data from the fit coefficients.
olderStats = verLessThan('stats', '7.6');
numPoints = rowCount / mxRVLen;
[xInput, ~] = sortrows(xInput, xInputIndices(xInputIndices ~= xAxisIndex2));
hl = [];
hp = [];
for i = 1 : numPoints
    rangeStart = (i - 1) * mxRVLen + 1;
    rangeEnd = rangeStart + mxRVLen - 1;
    if olderStats
        [y, yLo, yHi] = glmval(coefficients, xInput(rangeStart : rangeEnd, :), 'logit', regressionStats);%, 'simultaneous', true);
    else
        [y, yLo, yHi] = glmval(coefficients, xInput(rangeStart : rangeEnd, :), 'logit', regressionStats);
    end
    %Plot, with a shaded area.
    if i <= size(cmap, 1)
        color = cmap(i, :);
    else
        color = cmap(mod(size(cmap, 1), i), :);
    end
    [hl, hp] = boundedline(xInput(rangeStart : rangeEnd, xAxisIndex2), y, [yLo, yHi], 'alpha', 'transparency', 0.2, 'cmap', color);
end
%Marshall output arguments.
if nargout >= 1
    varargout{1} = ax;
end
if nargout >= 2
    varargout{2} = hl;
end
if nargout >= 3
    varargout{3} = hp;
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

% % Segmented data should be plotted in a separate function?
% % If one column is specified, find all levels (unique values) in that column.
% % If multiple columns are specified, find all the unique combinations across those columns.
% %
% 
% % regressionMatrix - The data to be used.
% % regressors - Indices into the regressors matrix, that represent the features that will be plotted separately.
% %                    Iterates over all permutations of the set of features.
% %                    Default: 1
% % xLevel1 - The index into the regressors matrix, that represents the x-axis.
% %              Default: (0 : 0.001 : 1)'
% % yResponse - The column index, in the regressionMatrix, that corresponds to the y values.
% % ax - The axes in which to plot.
% %      Default: gca
% % colorMap - A custom Matlab colormap.
% %            Default: april
% % intercepts - Y-Intercepts for each of the plottingFeatures.
% % handles - Handles to the created graphical elements.
% %
% %plotRegression(regressionMatrix)
% %plotRegression(regressionMatrix, regressors)
% %plotRegression(regressionMatrix, regressors, yResponse)
% %plotRegression(regressionMatrix, regressors, yResponse, xAxis)
% %plotRegression(regressionMatrix, regressors, yResponse, xAxis, xLevel2)
% %plotRegression(..., 'Axes', ax, 'ColorMap', colorMap)
% %[coefficients, deviances, regressionStats, handles] = plotRegression(...)
% function [coefficients, deviances, regressionStats, handles] = plotLogisticRegression(regressionMatrix, varargin)
% 
% xAxis = linspace(0, 1, size(regressionMatrix, 1))';%(0:0.001:1)';
% regressors = 1;
% yResponse = regressionMatrix(:, 1);
% if length(varargin) >= 1
%     regressors = varargin{1};
%     cmap = april(length(regressors));
% end
% if length(varargin) >= 2
%     yResponse = regressionMatrix(:, varargin{2});
% end
% if length(varargin) >= 3
%     xAxis = regressionMatrix(:, varargin{3});
% end
% if length(varargin) >= 4
%     xLeve2 = regressionMatrix(:, varargin{4});
% end
% if length(varargin) >= 5
%     for i = 5 : 2 : length(varargin)
%         if strcmpi(varargin{i}, 'Axes')
%             ax = varargin{i + 1};
%         end
%     end
% end
% 
% [coefficients, deviances, regressionStats] = glmfit(regressionMatrix(:, regressors), yResponse, 'binomial', 'link', 'logit');
% 
% handles.hl = {};
% handles.hp = {};
% hold on;
% %The xAxis should be specified from outside of this function, but needs to match the regressors, and the various xInputNs should represent the combinations. This doesn't seem to work cleanly.
% xInput1 = [xAxis, zeros(size(xAxis)), zeros(size(xAxis))];
% xInput2 = [xAxis, ones(size(xAxis)), ones(size(xAxis))];
% xInput3 = [xAxis, ones(size(xAxis)), zeros(size(xAxis))];
% xInput4 = [xAxis, zeros(size(xAxis)), ones(size(xAxis))];
% olderStats = verLessThan('stats', '7.6');
% for i = 1 : regressors
%     if olderStats
%         %SmallSmall Curve
%         [Yss, YLOss, YHIss] = glmval(coefficients, xInput1, 'logit', regressionStats);%, 'simultaneous', true);
%         
%         %LargeLarge Curve
%         [Yll, YLOll, YHIll] = glmval(coefficients, xInput2, 'logit', regressionStats);%, 'simultaneous', true);
%         
%         %LargeSmall Curve
%         [Yls, YLOls, YHIls] = glmval(coefficients, xInput3, 'logit', regressionStats);%, 'simultaneous', true);
%         
%         %SmallLarge Curve
%         [Ysl, YLOsl, YHIsl] = glmval(coefficients, xInput4, 'logit', regressionStats);%, 'simultaneous', true);
%     else
%         %SmallSmall Curve
%         [Yss, YLOss, YHIss] = glmval(coefficients, xInput1, 'logit', regressionStats, 'simultaneous', true);
%         
%         %LargeLarge Curve
%         [Yll, YLOll, YHIll] = glmval(coefficients, xInput2, 'logit', regressionStats, 'simultaneous', true);
%         
%         %LargeSmall Curve
%         [Yls, YLOls, YHIls] = glmval(coefficients, xInput3, 'logit', regressionStats, 'simultaneous', true);
%         
%         %SmallLarge Curve
%         [Ysl, YLOsl, YHIsl] = glmval(coefficients, xInput4, 'logit', regressionStats, 'simultaneous', true);
%     end
% 
%     [hl, hp] = boundedline(xAxis, Yss, [YLOss, YHIss], xAxis, Yll, [YLOll, YHIll], ...
%     xAxis, Yls, [YLOls, YHIls], xAxis, Ysl, [YLOsl, YHIsl], ...
%     'alpha', 'transparency', 0.2, 'cmap', cmap);
% 
%     handles.hl{end + 1} = hl;
%     handles.hp{end + 1} = hp;
% end
% 
% return;
% 
% % %perform the logisitic regression using columns 2-4 of the regression
% % %matrix, using column 1 as the output
% % [coefficients,deviances,regressionStats] = glmfit(MVregressionMatrix(:,2:4),MVregressionMatrix(:,1),'binomial','link','logit');
% % 
% % 
% % xInput1 = [(0:.001:1)',zeros(1001,1),zeros(1001,1)]; %SmallSmall Curve
% % [Yss,YLOss,YHIss] = glmval(coefficients,xInput1,'logit',regressionStats,'simultaneous',true);
% % 
% % xInput2 = [(0:.001:1)',ones(1001,1),ones(1001,1)]; %LargeLarge Curve
% % [Yll,YLOll,YHIll] = glmval(coefficients,xInput2,'logit',regressionStats,'simultaneous',true);
% % 
% % xInput3 = [(0:.001:1)',ones(1001,1),zeros(1001,1)]; %LargeSmall Curve
% % [Yls,YLOls,YHIls] = glmval(coefficients,xInput3,'logit',regressionStats,'simultaneous',true);
% % 
% % xInput4 = [(0:.001:1)',zeros(1001,1),ones(1001,1)]; %SmallLarge Curve
% % [Ysl,YLOsl,YHIsl] = glmval(coefficients,xInput4,'logit',regressionStats,'simultaneous',true);
% % 
% % 
% % xAxisPlot = (0:.001:1)';
% % figure
% % hold on
% % boundedline(xAxisPlot, Yss, [YLOss,YHIss],xAxisPlot, Yll, [YLOll,YHIll],xAxisPlot, Yls, [YLOls,YHIls],xAxisPlot, Ysl, [YLOsl,YHIsl],'alpha','transparency',.2,'cmap',[.2 .2 .2;.2 .2 .2;0 0 1;1 0 0]);