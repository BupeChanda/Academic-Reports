// RBC model with investment and TFP shocks


// Endogenous Variables

var c k n I y r w R a mu log_y log_c log_I log_k log_n log_r log_R log_w log_a log_mu;


// Exogenous Variables

varexo eps_a eps_mu;

// Parameter values 

parameters beta alpha delta a_ss b_ss varphi g_ss k_n_ss n_ss k_ss I_ss c_ss y_ss mu_ss w_ss r_ss R_ss I_y_ss c_y_ss k_n_ss_annual k_y_ss_annual c_I_ss rho_a sd_a rho_mu sd_mu;

// Parameter Calibration 

alpha = 0.35;         // Capital share in production
beta = 0.995;         // Discount factor
delta = 0.025;        // Depreciation rate
a_ss = 1;             // TFP Shock
b_ss = 3.67;          // Labor disutility weight
varphi = 1;           // Inverse of Frisch Elasticity of Labour Supply
mu_ss = 1;            // SS investment shock

g_ss = 0.0;

k_n_ss = ((alpha/((1/beta)-(1-delta)))^(1/(1-alpha)));                           // SS capital to labour ratio
n_ss = ((1-alpha)*b_ss^(-1)/(1-g_ss-delta*(k_n_ss)^(1-alpha)))^(1/(1+varphi));   // SS labour
k_ss = k_n_ss*n_ss;                                                              // SS capital
I_ss = delta*k_ss;                                                               // SS investment
c_ss = n_ss*(a_ss*((k_n_ss)^alpha)-delta*(k_n_ss));                              // SS consumption
y_ss = a_ss*(k_ss^alpha)*(n_ss^(1-alpha));                                       // SS output

w_ss=a_ss*(1-alpha)*(k_ss/n_ss)^alpha;                                           // SS MPN
r_ss=a_ss*alpha*(n_ss/k_ss)^(1-alpha);                                           // SS MPK

R_ss=r_ss+(1-delta);                                                             // SS Gross Real Return on Capital net of depreciation

I_y_ss=I_ss/y_ss;
c_y_ss=c_ss/y_ss;
k_n_ss_annual=k_ss/4*n_ss;
k_y_ss_annual=k_ss/4*y_ss;
c_I_ss=c_ss/I_ss;



rho_mu = 0.95;        // Persistence of investment shock
sd_mu = 0.01;         // Std dev of investment shock

rho_a = 0.95;         // Persistence of TFP shock
sd_a = 0.01;          // Std dev of TFP shock



model;


// Basic Model

// Euler Equation

(1/c) = beta * mu * (1 / c(+1)) * (r(+1) + (1 - delta) / mu(+1));



// Labour Supply Condition

b_ss*n^varphi=(1/c)*a*(1-alpha)*(k(-1)/n)^alpha;


// Production Function

y=a*(k(-1)^alpha)*(n^(1-alpha));

// Resource Constraint

y=I+c;

// Capital Accumulation Constraint

k=mu*I+(1-delta)*(k(-1));

// Marginal Product of Capital - Demand for Capital

r=a*alpha*(n/k(-1))^(1-alpha);

// The Real Gross Return on Capital

R=r(1)+(1-delta);

// Marginal Product of Labour - Demand for Labour

w=a*(1-alpha)*(k(-1)/n)^alpha;


// Process for TFP A

a=((a_ss)^(1-rho_a))*((a(-1))^rho_a)*exp(sd_a*eps_a);

// Process for mu

mu=(mu(-1)^(rho_mu))*(exp(sd_mu*eps_mu));




// Annualized Log Variables

log_y=100*(y-y_ss)/y_ss;

log_c=100*(c-c_ss)/c_ss;

log_I=100*(I-I_ss)/I_ss;

log_k=100*(k-k_ss)/k_ss;

log_n=100*(n-n_ss)/n_ss;

log_r=100*(r-r_ss)/r_ss;

log_R=400*(R-R_ss)/R_ss;

log_w=100*(w-w_ss)/w_ss;

log_a=100*(a-a_ss)/a_ss;

log_mu=100*(mu-mu_ss)/mu_ss;

end;



// Below steady state values derived in a separate MATLAB file

initval;

c=c_ss;
k=k_ss;
n=n_ss;
 
I=I_ss; 
y=y_ss; 
r=r_ss;

R=R_ss;
w=w_ss;
a=a_ss;
mu=mu_ss;


end;

steady;

check;

shocks;

var eps_a; stderr -1;
var eps_mu; stderr -1;


end;

stoch_simul(order=1,irf=100,hp_filter=1600) log_y log_c log_I log_k log_n log_r log_R log_w log_a log_mu;

 