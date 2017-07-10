% SVM classification for data
% Need to have run Training.m first

clear;
load('data1/BoW_tra','BoW');
fprintf('\nClassification using BOW rbf_svm\n');
labels = importdata('jpl_interaction_labels.xlsx');
labels1 = struct('name',[],'label',[]);
labels1.name = labels.textdata.segmented(2:85,1);
labels1.label = labels.data.segmented(:,2);

train_labels  = labels1.label(1:60);
test_labels = labels1.label(61:84);
% train_labels = repmat([1 ; 2 ;3],10,1);
% test_labels = repmat([1 ; 2 ;3],2,1);
train_data = BoW.BoW(1:60,:);
test_data  = BoW.BoW(61:84,:);
clear BoW;

% rmpath('/Applications/MATLAB_R2016b.app/toolbox/stats/stats/svmtrain.m');
% addpath('/Users/holly/Documents/Project/dense_trajectory_release_v1.2/release/results/libsvm_chi_ksirg/matlab');

% set the parameters via cross-validation! Elapsed time is 246.922774 seconds.
bestc=1000;bestg=1.5000;
bestcv=30;
tic 
for log2c = -1:10,
  for log2g = -1:0.1:1.5,
    cmd = ['-v 5 -t 2 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
    cv = libsvmtrain(train_labels, train_data, cmd);
    if (cv >= bestcv),
      bestcv = cv; bestc = 2^log2c; bestg = 2^log2g;
    end
   % fprintf('%g %g %g (best c=%g, g=%g, rate=%g)\n', log2c, log2g, cv, bestc, bestg, bestcv);
  end
end
toc 
options=sprintf('-s 0 -t 2 -c %f -b 1 -g %f -q',bestc,bestg);
model=libsvmtrain(train_labels, train_data,options);

%% Apply the SVM model to the test videos 
%{%
[predict_label, accuracy , dec_values] = libsvmpredict(test_labels,test_data, model,'-b 1');
%}

%% Using fitcsvm

clear;
load('data2/BoW_tra_shape','BoW');
fprintf('\nClassification using BOW rbf SVM\n');
% labels = importdata('jpl_interaction_labels.xlsx');
% labels1 = labels.data.segmented(:,2);

labels = importdata('jpl_interaction_labels.xlsx');
labels1 = struct('name',[],'label',[]);
labels1.name = labels.textdata.segmented(2:85,1);
labels1.label = labels.data.segmented(:,2);

train_labels  = labels1.label(1:60);
test_labels = labels1.label(61:84);
train_data = BoW.BoW(1:60,:);
test_data  = BoW.BoW(61:84,:);
indx = zeros(1,numel(train_labels));
SVMModels = cell(7,1);
clear BoW;

for j = 1:7
    indx = zeros(1,numel(train_labels));
    for i = 1:numel(train_labels)
        if (train_labels(i)==j-1)
            indx(i) = 1; % Create binary classes for each classifier
        end
    end
%     SVMModels{j} = fitcsvm(train_data,indx');
    SVMModels{j} = fitcsvm(train_data,indx','ClassNames',[false true],...
        'KernelFunction','rbf','BoxConstraint',1);
end

Score = zeros(24,7);

for j = 1:7
    [label,scores] = predict(SVMModels{j},test_data);
    Score(:,j) = scores(:,2);
end

[~,maxScore] = max(Score,[],2);

accuracy = sum(maxScore-1==test_labels)/numel(test_labels);

%%

clear;
load('Data/BoW_mbhy','BoW');
fprintf('\nClassification using BOW rbf_svm\n');
% labels = importdata('jpl_interaction_labels.xlsx');
% labels1 = labels.data.segmented(:,2);

train_labels = repmat([1 ; 2 ;3],10,1);
test_labels = repmat([1 ; 2 ;3],2,1);
train_data = BoW.BoW(1:30,:);
test_data  = BoW.BoW(31:36,:);
clear BoW;

model = ovrtrain(trainY, trainX, '-c 8 -g 4');
[pred ac decv] = ovrpredict(testY, testX, model);
fprintf('Accuracy = %g%%\n', ac * 100);