%%Load Data

clear;

direct = '/Users/holly/Documents/Project/dense_trajectory_release_v1.2/release/matlab/data/jpl';
files = dir(direct);

fileIndex = find(~[files.isdir]);
data = struct('name',{},'tra_shape',{});

for i = 1:length(fileIndex)
    fileName = files(fileIndex(i)).name;
    temp = import_idt1(strcat('data/jpl/',fileName),15,strrep(fileName,'.gz','') );
    data = [data; temp];
end

save('final_data_tra_shape','data');

%%
%Pick 100,000 random descriptors

for i=1:size(data,1)
    if i==1
        descriptors = struct('name', repmat(string(data(1).name),1,size(data(1).tra_shape,2)),'tra_shape',data(1).tra_shape);
    else
        descriptors.name = [descriptors.name repmat(string(data(i).name),1,size(data(i).tra_shape,2))];
        descriptors.tra_shape = [descriptors.tra_shape data(i).tra_shape];
    end
end

save('final_data_tra_shape','descriptors');

%%
%Choose number of descriptors
feat_size = 100000;

descriptors_chosen = struct('name',repmat(string(0),1,feat_size),'tra_shape',[zeros(size(descriptors.tra_shape,1),feat_size)]);


    index = randperm(size(descriptors.tra_shape,2));

    for i=1:feat_size
        j = index(i);
        descriptors_chosen.name(i) = descriptors.name(j);
        descriptors_chosen.tra_shape(:,i) = descriptors.tra_shape(:,j);
    end

 save('descriptors_chosen_tra_shape','descriptors_chosen');
