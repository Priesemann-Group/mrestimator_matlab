function import_module(location)
%Imports the MR Estimator module from a folder

%Fixes MKL bug on linux
if isunix
    py.sys.setdlopenflags(int32(10));
end

%Imports mrestimator as a module
py_path = py.sys.path;
py_path.insert(int64(1),location)

end