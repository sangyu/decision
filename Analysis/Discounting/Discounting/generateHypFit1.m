function [fitresult, gof] = generateHypFit1(freq1, freq4, c)
%CREATEFIT(FREQ1,FREQ4)
%  Create a fit.
%
%  Data for 'discounting' fit:
%      X Input : freq1
%      Y Output: freq4
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 13-Sep-2012 01:04:22


%% Fit: 'discounting'.
[xData, yData] = prepareCurveData( freq1, freq4);

% Set up fittype and options.
ft = fittype( 'a/(1+k*x)', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( ft );
opts.Display = 'Off';
opts.Lower = [-Inf -Inf];
opts.StartPoint = [0.141886338627215 0.421761282626275];
opts.Upper = [Inf Inf];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
h = plot( fitresult, 'k') 
set(h, 'Color', c, 'LineWidth', 1)
grid off
legend off
% Label axes
xlabel( 'delay/s' );
ylabel( 'proportion of delayed choice' );
grid on

