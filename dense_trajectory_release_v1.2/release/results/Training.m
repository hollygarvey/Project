%%
%Create dictionary
clear 
load('descriptors_chosen_hog');
DictionarySize = 4000;
run('vlfeat-0.9.16/toolbox/vl_setup');% to compile the vlfeat lab. 
tic
[C,A_hog] = vl_kmeans(descriptors_chosen.hog,DictionarySize,'algorithm', 'elkan');
C_hog = C';
toc
save('dictionary_hog','C_hog');

%%
%Distance between dictionary and descriptors
clear;
load('dictionary_hog');
load('descriptors_chosen_hog');
n = 80000;
index_train = zeros(1,n);
TrainMat = double(descriptors_chosen.hog(:,1:80000)');
TestMat = double(descriptors_chosen.hog(:,80001:100000)');

for i=1:n
    descriptor = TrainMat(i,:);
    d = EuclideanDistance(descriptor,C_hog);
    [minv,index] = min(d);
    index_train(i) = index;
end

m = 20000;
index_test = zeros(1,m);

for i=1:m
    descriptor = TestMat(i,:);
    d = EuclideanDistance(descriptor,C_hog);
    [minv,index] = min(d);
    index_test(i) = index;
end

save('assignd_descriptor_hog','index_train','index_test');

%%
%Represent each video as BoW

clear;
BoW =zeros(83,4000); %initialization 
isshow = 0; % show image and histogram or not

load('descriptors_chosen_hog');
load('assignd_descriptor_hog');

% if unsorted then uncomment below
% data = [descriptors_chosen.name' descriptors_chosen.hog'];
% data = sortrows(data);
% descriptors_chosen.name = data(:,1)';
% descriptors_chosen.hog = double(data(:,2:97)');

nvids = 83;
vocbsize = 4000;
name = descriptors_chosen.name(1);
ind = 1;
indexes = [index_train index_test];

for ii = 1:size(descriptors_chosen.name,2)
    if (name ~= descriptors_chosen.name(ii))
        ind = ind + 1;
        name = descriptors_chosen.name(ii);
    end
    BoW(ind,indexes(ii)) = BoW(ind,indexes(ii))+1;
end

%Normalise the BoW

for i = 1:nvids
    BoW(i,:)=do_normalize(BoW(i,:));
end

save('BoW_hog','BoW');

%%
% KNN

clear;
load('BoW_hog');
labels = importdata('jpl_interaction_labels.xlsx');
labels1 = struct('name',[],'label',[]);
labels1.name = labels.textdata.segmented(2:85,1);
labels1.label = labels.data.segmented(:,2);



train_labels  = [labels1.label(1:18) ;labels1.label(20:61)];
test_labels = labels1.label(62:84);
train_data = BoW(1:60,:);
test_data  = BoW(61:83,:);
clear BoW;
k = 1;% set the k for k-nn algorithm 
method = 1;% 1-L2; 2- Histogram intersection 
NNresult = knnsearch(test_data,train_data,k,method);

if k >1 
  NNresult = round(mean(NNresult,2));% stores the nearest neighbour 
end 
predict_label = train_labels(NNresult);

%%
% Average precision
correct = zeros(1,23);
for i = 1:23
    if (test_labels(i)==predict_label(i))
        correct(i) = 1;
    end
end

MAP = sum(correct(:))/23;
