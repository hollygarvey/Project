%%
%Create dictionary
%Use K means to find the centres (C), A_tra_shape = assigments
clear 
load('data2/descriptors_chosen_tra_shape');
DictionarySize = 2000;
run('vlfeat-0.9.16/toolbox/vl_setup');% to compile the vlfeat lab. 
tic
[C,A_tra_shape] = vl_kmeans(descriptors_chosen.tra_shape,DictionarySize,'algorithm', 'elkan','numrepetitions',2);
C_tra_shape = C';
toc 

% pool = parpool;                      % Invokes workers
% stream = RandStream('mlfg6331_64');  % Random number stream
% options = statset('UseParallel',1,'UseSubstreams',1,...
%     'Streams',stream);
% tic; % Start stopwatch timer
% [idx,C_tra,sumd,D] = kmeans(descriptors_chosen.tra',4000,'Options',options,'MaxIter',8,...
%     'Display','final','Replicates',10);
% toc % Terminate stopwatch timer

save('data2/dictionary_tra_shape','C_tra_shape');

%%
%Distance between dictionary and descriptors
clear;
load('data2/dictionary_tra_shape');
load('data2/descriptors_chosen_tra_shape');

% if unsorted then uncomment below
data = [descriptors_chosen.name' descriptors_chosen.tra_shape'];
data = sortrows(data);
descriptors_chosen.name = data(:,1)';
descriptors_chosen.tra_shape = double(data(:,2:end)');
save('data2/descriptors_chosen_tra_shape', 'descriptors_chosen');

% n = uint32(size(descriptors.name,2)*3/4);
n=20000;
index_train = zeros(1,n);
TrainMat = double(descriptors_chosen.tra_shape(:,1:n)');
TestMat = double(descriptors_chosen.tra_shape(:,(n+1):size(descriptors_chosen.tra_shape,2)))';


for i=1:n
    descriptor = TrainMat(i,:);
    d = EuclideanDistance(descriptor,C_tra_shape(2:end,:));
    [minv,index] = min(d);
    index_train(i) = index;
end

% m = uint16(n/3);
m=80000;
index_test = zeros(1,m);

for i=1:m
    descriptor = TestMat(i,:);
    d = EuclideanDistance(descriptor,C_tra_shape(2:end,:));
    [minv,index] = min(d);
    index_test(i) = index;
end

save('data2/assignd_descriptor_tra_shape','index_train','index_test');

%%
%Represent each video as BoW

clear;
BoW = struct('Label',repmat(string(0),84,1),'BoW',zeros(84,4000));
% BoW =zeros(18,4000); %initialization 

load('data2/descriptors_chosen_tra_shape');
load('data2/assignd_descriptor_tra_shape');

nvids = 84;
vocbsize = 2000;
name = descriptors_chosen.name(1);
ind = 1;
indexes = [index_train index_test];
descriptors_chosen.name(1) = name;

for ii = 1:size(descriptors_chosen.name,2)
    if (name ~= descriptors_chosen.name(ii))
        ind = ind + 1;
        name = descriptors_chosen.name(ii);
        BoW.Label(ind) = name;
    end
    BoW.BoW(ind,indexes(ii)) = BoW.BoW(ind,indexes(ii))+1;
end

%Normalise the BoW

for i = 1:nvids
    BoW.BoW(i,:)=do_normalize(BoW.BoW(i,:));
end

save('data2/BoW_tra_shape','BoW');

%%
% KNN

%check the labelling
% clear;
% load('data2/BoW_tra_shape');
% labels = importdata('jpl_interaction_labels.xlsx');
% labels1 = struct('name',[],'label',[]);
% labels1.name = labels.textdata.segmented(2:85,1);
% labels1.label = labels.data.segmented(:,2);
% 
% 
% %this part correct?
% train_labels  = labels1.label(1:60);
% test_labels = labels1.label(61:84);
% % train_labels = repmat([1 ; 2 ;3],10,1);
% % test_labels = repmat([1 ; 2 ;3],2,1);
% train_data = BoW.BoW(1:60,:);
% test_data  = BoW.BoW(61:84,:);
% % clear BoW;
% k =3;% set the k for k-nn algorithm 
% method = 1;% 1-L2; 2- Histogram intersection 
% NNresult = fitcknn(train_data, train_labels,'NumNeighbors',k);
% % NNresult = knnsearch(test_data,train_data,k,method);
% 
% % if k >1 
% %   NNresult = round(mean(NNresult,2));% stores the nearest neighbour 
% % end 
% predict_label = train_labels(NNresult);
% 
% %%
% % Average precision
% n = numel(predict_label);
% correct = zeros(1,n);
% for i = 1:n
%     if (test_labels(i)==predict_label(i))
%         correct(i) = 1;
%     end
% end
% 
% MAP = sum(correct(:))/n;
% 
% %%
% % Confusion matrix
% plotc = confusionmat(test_labels,predict_label);
% 
% % num_class = 7;
% % num_test_1c = floor(size(predict_label,1)/num_class);
% % confusion_matrix = ones(num_class);
% class_names={...
%     'shake'
%     'hug'
%     'pet'
% %     'wave'
% %     'point'
% %     'punch'
% %     'throw'
%     };
% % for ci = 1:num_class
% %     for cj = 1:num_class
% %         confusion_matrix(ci,cj)=size(find(predict_label((ci-1)*num_test_1c+1:ci*num_test_1c,:)==cj),1)/num_test_1c;
% %     end 
% % end 
% % close all; figure;
% % draw_cm(confusion_matrix,class_names,num_class);
% plotc = plotc/23;
% 
% draw_cm(plotc,class_names,23);
