function plotForDay(action, exptSetup) 

rect = [0 , 0, 1000, 1000];
    figure('OuterPosition', rect)
    plotting(action, exptSetup);
    set(gca, 'FontSize', 8)
    title([exptSetup.mouseID, ' ', exptSetup.dateTime]);

end