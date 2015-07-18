%% bar and dots.

red=[ 0.85    0.20   0.20];
blue=[ 0.3    0.65    0.8];
orange= [0.9, 0.3,  0];
gray=[.4, .4, .4];
green=[  0.2,  0.85,0.75];
yellow=[1, 0.95, 0.4];
pink= [0.9, 0.3,  0.6];


L =[ 0.9551    0.8871    0.9040    0.8696
    0.8060    0.5676    0.5938    0.6017
    0.2019    0.0949    0.0669    0.2162];

nL=[
    0.9437    0.8412    0.9434    0.8287
    0.8276    0.6667    0.6196    0.6306
    0.2139    0.1423    0.0991    0.2353];
    

Lc=[0.8914728682	0.9142857143	0.869047619	0.9504950495
0.7857142857	0.7916666667	0.6607142857	0.5903614458
0.1843575419	0.2882882883	0.1129032258	0.2050359712]

nLc=[0.9285714286	0.8309859155	0.8787878788	0.8367346939
0.7578947368	0.7647058824	0.8	0.6375
0.1652661064	0.2764976959	0.133105802	0.2218543046]
 
figure(10)
subplot(121)
for i=1:length(L(:, 1))
hold on
bar(1+i*3, mean(nL(i, :)), 'FaceColor', 'w')
bar(2+i*3, mean(L(i, :)), 'FaceColor', green)
errorbar([1, 2]+i*3, [mean(nL(i, :)),mean(L(i, :))], [std(nL(i, :)),std(L(i, :))], 'LineStyle', 'none' , 'Color', 'k')
    for ii=1:length(L(1, :))
      plot([1,2]+i*3,[nL(i, ii),L(i, ii)],'-or',...
           'MarkerFaceColor',[1,0.5,0.5])
    end
         set(gca,'xtick',[]);

  [h, p]=ttest(L(i, :),nL(i, :));
if h==1
    t=text(1.5+i*3, 1.2*max([mean(nL(i, :))+std(nL(i, :)), mean(L(i, :))+std(L(i, :))]) , ['*'], 'FontSize', 14)
  
end
end



subplot(122)

for i=1:length(Lc(:, 1))
hold on
bar(1+i*3, mean(nLc(i, :)), 'FaceColor', 'w')
bar(2+i*3, mean(Lc(i, :)), 'FaceColor', green)
errorbar([1, 2]+i*3, [mean(nLc(i, :)),mean(Lc(i, :))], [std(nLc(i, :)),std(Lc(i, :))], 'LineStyle', 'none' , 'Color', 'k')
    for ii=1:length(Lc(1, :))
      plot([1,2]+i*3,[nLc(i, ii),Lc(i, ii)],'-or',...
           'MarkerFaceColor',[1,0.5,0.5])
    end
     set(gca,'xtick',[]);

  [h, p]=ttest(Lc(i, :),nLc(i, :));
if h==1
    t=text(1.5+i*3, 1.2*max([mean(nLc(i, :))+std(nLc(i, :)), mean(Lc(i, :))+std(Lc(i, :))]) , ['*', num2str(round(100*p)/100)], 'FontSize', 14)
  
end
end

