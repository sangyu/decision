
% regressors - Data matrix
% features - The indices of the columns/rows of interest in the regressors matrix.
% additionalFeature - An extra category, for which the average and standard-deviation of the averageYValue can be calculated.
%
% featureIndices - The indices into the regressors matrix of the unique combinations of the features.
% featureValues - The unique values of the combinations of features.
% averageYValue - The average of the yValues over each unique feature.
% counts - The number of yValues included in each averageYValue.
% ySubsetAvg - The averages of averageYValue, as broken up by the additionalFeature label.
% ySubsetStd - The standard deviation of averageYValue, as broken up by the additionalFeature label.
% ySubsetIndices - The indices corresponding to the unique values determined by the additionalFeature label.
% yCategoryIndices - A 2D cell array, such that yCategoryIndices{i, j} is the indices of the i-th feature and the j-th additional feature.
%
%[featureIndices, featureValues] = segmentRegressionData(regressors, features)
%[averageYValue, counts, featureIndices, featureValues] = segmentRegressionData(regressors, features, yValues)
%[averageYValue, counts, featureIndices, featureValues, ySubsetAvg, ySubsetStd, ySubsetIndices, yCategoryIndices] = segmentRegressionData(regressors, features, yValues, additionalFeature)

%Example:
%Open Kean's Sample Matrix MVMatrix.mat 
%MVMatrix is a nx4 matrix where n is the number of trials. Columns are 
%MVMatrix(:,1) is the output - 0 or 1
%MVMatrix(:,2) is odor concentration coded as fraction from 0 to 1 for 6 odor combinations
%MVMatrix(:,3) is binary regressor whether left reward is large
%MVMatrix(:,4) is binary regressor whether right reward is large
%
%featureIndices = Find the number of unique combinations for this set of regressors, for instance, if you chose odor concentration and left reward large or not, then you would have 12 unique combinations
%counts = Find the number of cases of each unique combinations, for instance, that there are, eg. 15 trials with 25% odor and left large rewarded
%
%For Additional Segmentation and Segmented Averages
%additionalFeature = If you want to segment data on an additional feature like Mouse, Genotype, Session, use an additional feature, for example, MVMatrix(:,5) to segment the data on, for instance, by mouse
%ySubsetAvg and ySubsetStd = Find the average response (and standard deviation), given for example MVMAtrix(:,1), for each unique cases
%ySubsetIndices = gives you for instance the indices for control and mutant genotypes if your additional feature was genotype
%yCategoryIndices = gives you segmentation by, in this case, genotype of the initial feature indices, eg. which indices go with contol mice and mutant mice for a certain odor and left reward size.
% 
% <<<<<<< HEAD:Sandbox/segmentRegressionData.m
function varargout = segmentRegressionData(regressors, features, varargin)
% =======
% <<<<<<< HEAD
% function varargout = EmilyTest(regressors, features, varargin)
% =======
% function varargout = segmentME(regressors, features, varargin)
% >>>>>>> dummy
% >>>>>>> dummy:Sandbox/DummyTestcopy.m

if size(regressors, 1) < size(regressors, 2)
    regressors = regressors';
end

featureValues = unique(regressors(:, features), 'rows');
featureIndices = cell(size(featureValues, 1), 1);
for i = 1 : size(featureValues, 1)
    % [~, ~, indices] = intersect(featureValues(i, :), regressors(:, features), 'rows');
    % featureIndices{i} = indices;
    indices = [];
    for j = i : size(regressors, 1)
        if all(featureValues(i, :) == regressors(j, features))
            indices(end + 1) = j;
        end
    end
    featureIndices{i} = indices; 
end

if nargin > 2
    yValues = varargin{1};
    averageYValues = zeros(size(featureValues, 1), 1);
    counts = zeros(size(featureValues, 1), 1);
    for i = 1 : size(featureValues, 1)
        averageYValues(i) = mean(yValues(featureIndices{i}));
        counts(i) = length(featureIndices{i});
    end
    varargout{1} = averageYValues;
    varargout{2} = counts;
    varargout{3} = featureIndices;
    varargout{4} = featureValues;
    if nargin > 3
        additionalFeature = varargin{2};
        categories = unique(regressors(:, additionalFeature));
        ySubsetAvg = zeros(size(categories));
        ySubsetStd = zeros(size(categories));
        ySubsetIndices = cell(size(categories));
        for i = 1 : length(categories)
            ySubsetIndices{i} = regressors(:, additionalFeature) == categories(i);
            ySubsetAvg(i) = mean(yValues(ySubsetIndices{i}));
            ySubsetStd(i) = std(yValues(ySubsetIndices{i}));
            ySubsetIndices{i} = find(ySubsetIndices{i} == 1);
        end
        yCategoryIndices = cell(length(featureIndices), length(categories));
        if nargout > 7
            for i = 1 : length(featureIndices)
                for j = 1 : length(categories)
                    yCategoryIndices{i, j} = find(regressors(featureIndices{i}, additionalFeature) == categories(j));
                end
            end
        end
        varargout{5} = ySubsetAvg;
        varargout{6} = ySubsetStd;
        varargout{7} = ySubsetIndices;
        varargout{8} = yCategoryIndices;
    end
else
    varargout{1} = featureIndices;
    varargout{2} = featureValues;
end

return;