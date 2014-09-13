% This the file simulates cobweb model with bounded memory 


%Specify the parameters first

alpha_1  = 5; 
beta_0   = 0.66;
beta_1   = 0.11;
c        = -0.5; %beta_0+beta_1
sigma    = 0.5; %variance of shock
time     = 10000; %simulation horizon

a        = zeros(time,1); %here we initialize empty matrices for simulations
p        = zeros(time,1);
alpha_2  = zeros(time,1);
beta_2   = zeros(time,1);
p_avg    = zeros(time,1);
a_avg    = zeros(time,1);
w        = zeros(time,1);
w_lag    = zeros(time,1);
w(1)     = 0.5*randn;
w_lag(1) = 0.5*randn;
delta    = 1; %define delta next to w in price equation

% Define variables for rolling window

alpha_2_roll = zeros(time,1);
beta_2_roll  = zeros(time,1);
p_avg_roll   = zeros(time,1);
wm           = zeros(time,1);
p_roll       = zeros(time,1);
a_roll       = zeros(time,1);
Shocks       = randn(1,time+1); %define shocks (or load pre-created data)

for t = 2:time

    w_lag(t) = w(t-1);
   
    w(t) = 0.5*randn;
end

% REE Values

a2   = alpha_1/(1-c);
b2   = delta/(1-c);
ReeP = a2+b2*w_lag(1);

%mean(p_roll)

beta_2_initial  = 2; %Initialize OLS parameters
alpha_2_initial = 1; 

%Initialize some other initial value of the model

a(1) = alpha_2_initial+beta_2_initial*w_lag(1);
p(1) = alpha_1+c*a(1)+delta*w_lag(1)+sigma*Shocks(1,1); %Initial values of p and a


%Initialize average for OLS (non-rolling window)

p_avg(1) = p(1);
wm(1)    = w_lag(1);

window = 3000;

%The Model

for t = 2:window

    %First 2 equations are macroeconomic model

    a(t) = alpha_2(t-1)+beta_2(t-1)*w(t-1);
    p(t) = alpha_1+c*a(t)+delta*w(t-1)+sigma*Shocks(1,t);

    % calculate the mean
    p_avg(t) = mean(p(1:t));
    wm(t)    = mean(w_lag(1:t));

    
    %Now we estimate parameters

        if t==2

            beta_2(t) = b2;

        else

        beta_2(t)=(sum((w_lag(1:t)-wm(t)).*(p(1:t)-p_avg(t))))/(sum((w_lag(1:t)-wm(t)).^2));

        end

    alpha_2(t) = p_avg(t)-beta_2(t)*wm(t);

    %Initialize parameters for rolling window

    p_roll(t)       = p(t);
    a_roll(t)       = a(t);
    alpha_2_roll(t) = alpha_2(t);
    beta_2_roll(t)  = beta_2(t);

end

%Slice w and w_lag to obtain matrices of rolling window

for i_w   = 1:time-window

    wroll             = w(i_w:window+i_w-1);
    w_roll(:,i_w)     = wroll;
    wlagroll          = w_lag(i_w:window+i_w-1);
    w_lag_roll(:,i_w) = wlagroll;

end

%This gives us w_roll(window,lengt(window)), we use w_roll(1,:) for
%computations

%Compute Rolling Window

for z = 1:time-window;
    
    %Compute rolling window
    
    x             = window;
    p_roll_window = p_roll(z:x+z-1);
    a_roll_window = a_roll(z:x+z-1);


    %Macroeconomic Model
    
    a_roll(z+window) = alpha_2_roll(z-1+window)+beta_2_roll(z-1+window)*w_lag(window+z);
    p_roll(z+window) = alpha_1+c*a_roll(z+window)+delta*w_lag(window+z)+sigma*Shocks(1,z+window);
    
    %Now we calculate average for rolling window (used for OLS)

    p_roll_avg(z+window)     = mean(p_roll_window);
    w_lag_roll_avg(z+window) = mean(w_lag_roll(:,z));
    
    %Now we estimate parameters for rolling window
    
    beta_2_roll(z+window)  = (sum((w_lag_roll(:,z)-w_lag_roll_avg(z+window)).*(p_roll_window(1:window)-p_roll_avg(z+window))))/(sum((w_lag_roll(:,z)-w_lag_roll_avg(z+window)).^2));
   
    alpha_2_roll(z+window) = p_roll_avg(z+window)-beta_2_roll(z+window)*w_lag_roll_avg(z+window);
   
end


%Plot rolling window

figure;
title('Rolling Window OLS')
subplot(2,2,1);
plot(a_roll,'k');
axis([0 length(1:time) min(a_roll)-0.5 max(a_roll)+0.5]);
hleg=legend('a_roll(t)');
xlabel('Time Periods');
ylabel('a_roll(t)');
subplot(2,2,2);
plot(p_roll,'k');
axis([0 length(1:time) min(p_roll)-0.1 max(p_roll)+0.1]);
xlabel('Time Periods');
ylabel('p_roll(t)');
hleg=legend('p_roll(t)');
subplot(2,2,3);
plot(alpha_2_roll,'k');
axis([0 length(1:time) min(alpha_2_roll)-0.1 max(alpha_2_roll)+0.1]);
xlabel('Time Periods');
ylabel('Alpha_2_Roll');
hleg=legend('Alpha_2_Roll');
subplot(2,2,4);
plot(beta_2_roll,'k');
axis([0 length(1:time) min(beta_2_roll)-0.1 max(beta_2_roll)+0.5]);
xlabel('Time Periods');
ylabel('Beta_2_Roll');
hleg=legend('Beta_2_Roll');





