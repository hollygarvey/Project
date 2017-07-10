%%Load Data

clear;

direct = '/Users/holly/Documents/Matlab/Project/improved_trajectory_release/jpl_trajectories';
files = dir(direct);

fileIndex = find(~[files.isdir]);
data = struct('name',{},'hog',{});

for i = 1:length(fileIndex)
    fileName = files(fileIndex(i)).name;
    temp = import_idt1(strcat('jpl_trajectories/',fileName),15,strrep(fileName,'.gz','') );
    data = [data; temp];
end

save('data2/final_data_hog','data');

%%
%Pick 100,000 random descriptors

for i=1:size(data,1)
    if i==1
        descriptors = struct('name', repmat(string(data(1).name),1,size(data(1).hog,2)),'hog',data(1).hog);
    else
        descriptors.name = [descriptors.name repmat(string(data(i).name),1,size(data(i).hog,2))];
        descriptors.hog = [descriptors.hog data(i).hog];
    end
end

a = find(descriptors.name == '.DS_Store');
b = numel(a);
descriptors.name = descriptors.name(b+1:end);
descriptors.hog = descriptors.hog(:,b+1:end);

save('data2/final_data_hog','descriptors');

%%
%Choose number of descriptors
feat_size = 100000;

descriptors_chosen = struct('name',repmat(string(0),1,feat_size),'hog',zeros(size(descriptors.hog,1),feat_size));


    index = randperm(size(descriptors.hog,2));

    for i=1:feat_size
        j = index(i);
        descriptors_chosen.name(i) = descriptors.name(j);
        descriptors_chosen.hog(:,i) = descriptors.hog(:,j);
    end

 save('data2/descriptors_chosen_hog','descriptors_chosen');
