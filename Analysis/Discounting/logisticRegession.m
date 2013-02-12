clear X
clear Y
[e, a]=extractOlfData('256.csv');
%%
left=a.side;
TTL=a.side(:, 2).*e.rightDecisionTTL;
rewardsize=a.side*[e.leftRewardSizeTotal(1), e.rightRewardSizeTotal(1)]';
rewardDelay=a.rewardDelay;


% logistic regression
% dependent Y, left choice
 %construct independent X
 % 1 N-1 side
%  X=a.side(1:end-1, 1);
 % 2 N-1 TTL
%  X=[X, TTL(1:end-1)];
 % 3 N-1 Reward Size
 rewardsize=a.side*[e.leftRewardSizeTotal(1), e.rightRewardSizeTotal(1)]';
 rewardsize(end)=[];
 X=[X, rewardsize];
 % 4 N-1 Reward Delay
 X=[X, a.rewardDelay(1:end-1)]; 
 
 [b, dev, stats]=glmfit(X, Y, 'normal')
 
 