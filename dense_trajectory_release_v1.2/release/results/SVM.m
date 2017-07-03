% SVM classification for data
% Need to have run Training.m first

clear;
load('BoW_hog','BoW');
fprintf('\nClassification using BOW rbf_svm\n');
labels = importdata('jpl_interaction_labels.xlsx');
labels1 = labels.data.segmented(:,2);

train_labels  = [labels1(1:18) ;labels1(20:61)];
test_labels = labels1(62:84);
train_data = BoW(1:60,:);
test_data  = BoW(61:83,:);
clear BoW;

% rmpath('/Applications/MATLAB_R2016b.app/toolbox/stats/stats/svmtrain.m');
% addpath('/Users/holly/Documents/Project/dense_trajectory_release_v1.2/release/results/libsvm_chi_ksirg/matlab');

% set the parameters via cross-validation! Elapsed time is 246.922774 seconds.
bestc=120;bestg=0.5000;
bestcv=20;
tic 
for log2c = -1:10,
  for log2g = -1:0.1:1.5,
    cmd = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = libsvmtrain(train_labels, train_data, cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end
   % fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end
toc 
options=sprintf('-s 0 -c %f -g %f -q',bestc,bestg);
model=libsvmtrain(train_labels, train_data,options);

%% Apply the SVM model to the test videos 
%{%
[predict_label, accuracy , dec_values] = libsvmpredict(test_labels,test_data, model);
%}

%% MAP