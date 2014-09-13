% This is the file for creating data to be used in simulations

pd     = makedist('normal');   % Normal distribution
time   = 7000;                 % Simulation horizon
w      = zeros(time,1);        % Container for w
w_lag  = zeros(time,1);        % Container for w(t-1)
Shocks = zeros(time+1,1);      % Define shocks


% create Shocks

for k = 1:time+1

	Shocks(k) = random(pd);

end

% create observable random variable

w_lag(1)=random(pd);

for t=2:time
    
    w_lag(t)=w(t-1);
   
    w(t)=random(pd); %0.5*randn;
end

save exo_shocks Shocks 

save rand_var_lag w_lag

save rand_var w
