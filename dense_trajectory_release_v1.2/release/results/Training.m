%%
%Create dictionary
clear 
load('descriptors_chosen');
DictionarySize = 4000;
run('vlfeat-0.9.16/toolbox/vl_setup');% to compile the vlfeat lab. 
tic
[C,A_hog] = vl_kmeans(descriptors_chosen.hog,DictionarySize,'algorithm', 'elkan');
C_hog = C';
toc
save('dictionary_hog','C_hog');

%%
%Distance between dictionary and descriptors
n = 80000;
index_train = zeros(1,n);
TrainMat = descriptors_chosen.hog(:,1:80000)';
TestMat = descriptors_chosen.hog(:,80001:100000)';

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
%Represent each image as BoW

clear;
BoW =zeros(400,500); %initialization 
isshow = 0; % show image and histogram or not
load('descriptors_chosen.labels','labels');
load('dictionary_hog','C');
load('descriptors_chosen.hog','descriptors');
nimages = 100000;
vocbsize = 4000;
for ii = 1:nimages
%       image_dir=sprintf('%s/%s/','data/local',num2string(ii,3));                    % location where detector is saved
%       inFName = fullfile(image_dir, sprintf('%s', 'sift_features'));
%       load(inFName, 'features');
      
      raw_data = zeros(size(descriptors,1));
      for i=1:size(descriptors.data,1)
          d = EuclideanDistance(features.data(i,:),C);
          [minimum, index] = min(d);
          raw_data(i) = index;
      end
      
      histogram = zeros(1,500);
      for i = 1:size(descriptors,1)
          a = raw_data(i);
          for j = 1:500
              if a==j
                  histogram(j) = histogram(j) +1;
                  break;
              else
                  continue;
              end
          end
      end
      
      BoW(ii,:) = do_normalize(histogram);
      
      if isshow == 1
        close all; figure;
        subplot(1,2,1),subimage(imread(strcat('image/',image_names{ii})));
        subplot(1,2,2),bar(BoW(:,ii)),xlim([0 500]);
      end 
end 