% This code simulates the OLS with rolling window, saves the output and plots price and expected price
% it is important to note that that we simulate model plenty of times for 1000 times. Then we create
% matrix where each column is the simulation result. Then we calculate average for each row and plot it. 

tic

simulation = 20000;

P_mean       = zeros(1,simulation); % matrix of simulated prices
Pe_mean      = zeros(1,simulation); % matrix of simulated expexted prices
A_mean       = zeros(1,simulation); % matrix of simulated alpha coefficient
B_mean       = zeros(1,simulation); % matrix of simulated beta coefficient

time_period  = 0;

for zi = 1:simulation

	OLS_learning_9;

	P_mean(1,zi)     = mean(p_roll);       % save price
	Pe_mean(1,zi)    = mean(a_roll);       % save expected price
	A_mean(1,zi)     = mean(alpha_2_roll); % save alpha coefficient
	B_mean(1,zi)     = mean(beta_2_roll);  % save beta coefficient

	time_period = time_period + 1 %print time index

end

toc