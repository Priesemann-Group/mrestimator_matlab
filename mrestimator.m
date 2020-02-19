function m = mrestimator(data, kmax)

%Fixes MKL bug on linux
if isunix
    py.sys.setdlopenflags(int32(10));
end

%Loads module
mre = py.importlib.import_module('mrestimator');

%Calculates coefficients
rk = mre.coefficients(data, [1,kmax]);

%Fits function
fit = mre.fit(rk);

m = fit.mre;

%fprintf('m = %0.3f (tau = %0.1f dt)\n',fit.mre, fit.tau);
end