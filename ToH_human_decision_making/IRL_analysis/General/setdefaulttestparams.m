% Set default general parameters for the test.
function test_params = setdefaulttestparams(test_params)

% Create default parameters.
default_params = struct(...
    'verbosity',2,...
    'training_samples',32,...
    'training_sample_lengths',100,...
    'true_features',[],...
    'true_examples',[],...
    'test_models',{{'standardmdp','linearmdp'}},...
    'test_metrics',{{'misprediction','policydist','featexp','value',...
        'featvar','reward','rewarddemean','rewardmomentmatch'}});

% Set parameters.
test_params = filldefaultparams(test_params,default_params);