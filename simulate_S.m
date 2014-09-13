% This file was used to simulate coefficients S from the paper

T = 50;

window = T; % simulation horizon

time = 20000; % time

w = zeros(time,1);

pd = makedist('normal'); % we can also load pre-created data to make it consistent

for z = 1:time

	w(z,1) = random(pd);

end

for k = 2:time

    w_lag(k)=w(k-1); % construct w lag

end

w_lag = w_lag';
 
S = zeros(T,time-window-1-T); % Container to store S

% make the sliding window size of w

for i_w = 1:time-window
    
    wlagroll = w_lag(i_w:window+i_w-1);
    
    w_lag_roll(:,i_w)=wlagroll;

end

% Calculate mean of w_lag

w_lag_roll_avg = mean(w_lag_roll);

% Construct S

index = 0;
        
for t = T+1:time-T+2 % -1 is wrong and -2 is correct
    
	for j = 1:T
    
		S(j,t-T) = (1/window)+(w(t-1) - mean(w_lag_roll(:,t-window+1)))*(w(t-j)-mean(w_lag_roll(:,t-window+1)))/(sum((w_lag_roll(:,t-window+1)-w_lag_roll_avg(t-window+1)).^2));

	end

	index = index + 1

end


figure;
plot(S);
xlabel('Memory Length');
ylabel('Value of S')

S_mean = mean(S');

figure;
plot(S_mean,'o-');
xlabel('Mean of S (Each Point is Mean of 5000 Simulations)')
ylabel('Value of S (mean)')

% save S mean for each case of T

save S_mean_50 S_mean