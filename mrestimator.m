% Runs the MRE estimator.
%     data: 1D or 2D timeseries matrix.
%     kmax: Number of timesteps to compute the correlations
%     
% Options:
%     'kmin': lower-bound of timestep to use (Default 1)

function m = mrestimator(data, kmax, varargin)

%Fixes MKL bug on linux
if isunix
    py.sys.setdlopenflags(int32(10));
end

%Parses input
parser = inputParser;
kminDefault = 1;
addParameter(parser,'kmin',kminDefault);
parse(parser,varargin{:});
kmin = parser.Results.kmin;

%Loads module
mre = py.importlib.import_module('mrestimator');

%Calculates coefficients
rk = mre.coefficients(data, [kmin,kmax]);

%Fits function
fit = mre.fit(rk);
m = fit.mre;

%fprintf('m = %0.3f (tau = %0.1f dt)\n',fit.mre, fit.tau);
end