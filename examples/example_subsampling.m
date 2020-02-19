% This example illustrates the effect of subsampling on the timeseries of a
% branching process. 
% Observing only 1% of the activations of a branching process
% with m = 0.999 (close to critical) results in a large decrease in the
% temporal correlations of the activity, but the mrestimator is able to
% recover the autocorrelation time of the dynamics.


% Parameters
m = 0.999;        %The branching parameter
a = 10;           %Stationary activity of the process
duration = 1e5;   %Time duration of the process
p = 0.01;         %Fraction of observed events under subsampling
kmax = 1000;      %Number of steps to use in the regression  

% Fixes MKL bug on linux
if isunix
    py.sys.setdlopenflags(int32(10));
end


% Loads the module
mre = py.importlib.import_module('mrestimator');

% Simulates branching dynamics, with and without subsampling
args = pyargs('a',int32(a),'length',int32(duration));
data_full = mre.simulate_branching(m,args);
data_sub = mre.simulate_subsampling(data_full,p);

% Calculates linear regression for the fully-sampled activity
data_matlab = double(data_full);
lin_fit = polyfit(data_matlab(1:end-1),data_matlab(2:end),1);
m_lin_full = lin_fit(1);

% Calculates linear regression for the subsampled activity
data_matlab = double(data_sub);
lin_fit = polyfit(data_matlab(1:end-1),data_matlab(2:end),1);
m_lin_sub = lin_fit(1);

% Uses mrestimator
m_full = mrestimator(data_full,kmax);
m_sub = mrestimator(data_sub,kmax);

% Display results
fprintf('\nTrue branching parameter: m = %0.5f\n',m);

fprintf('\nFull timeseries:\n')
fprintf('MR Estimator: m = %0.5f\n',m_full);
fprintf('Linear regression: m = %0.5f\n',m_lin_full);

fprintf('\nSubsampled timeseries:\n')
fprintf('MR Estimator: m = %0.5f\n',m_sub);
fprintf('Linear regression: m = %0.5f\n',m_lin_sub);
