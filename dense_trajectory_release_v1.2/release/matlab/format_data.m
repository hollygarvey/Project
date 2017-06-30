%%Load Data
% data = struct('jump',[],'run',[],'sit',[]);
% %jump_data = import_idt('out.features.jump*.gz',15);
% 
% for i=1:5
%     name = sprintf('data/jump%d.gz',i);
%     data.jump(end+1) = import_idt(name,15);
% end

% jump1 = import_idt('data/jump1.gz',15,1);
% jump2 = import_idt('data/jump2.gz',15,1);
% jump3 = import_idt('data/jump3.gz',15,1);
% jump4 = import_idt('data/jump4.gz',15,1);
% jump5 = import_idt('data/jump5.gz',15,1);
% 
% run1 = import_idt('data/run1.gz',15,2);
% run2 = import_idt('data/run2.gz',15,2);
% run3 = import_idt('data/run3.gz',15,2);
% run4 = import_idt('data/run4.gz',15,2);
% run5 = import_idt('data/run5.gz',15,2);
% 
% sit1 = import_idt('data/sit1.gz',15,3);
% sit2 = import_idt('data/sit2.gz',15,3);
% sit3 = import_idt('data/sit3.gz',15,3);
% sit4 = import_idt('data/sit4.gz',15,3);
% sit5 = import_idt('data/sit5.gz',15,3);
% sdown_data = import_idt('out.stairdown.sit.gz',15);
% sup_data = import_idt('out.features.stairup.gz',15);
% stand_data = import_idt('out.features.stand.gz',15);
% turn_data = import_idt('out.features.turn.gz',15);
% walk_data = import_idt('out.features.walk.gz',15);

direct = '/Users/holly/Documents/Project/dense_trajectory_release_v1.2/release/matlab/data/jpl';
files = dir(direct);

fileIndex = find(~[files.isdir]);
data = struct('name',{},'info',{},'tra',{},'tra_shape',{},'hog',{},'hof',{},'mbhx',{},'mbhy',{});

for i = 1:length(fileIndex)
    fileName = files(fileIndex(i)).name;
    temp = import_idt1(strcat('data/jpl/',fileName),15,strrep(fileName,'.gz','') );
    data = [data; temp];
end

save('final_data')

%%
%Create dictionary
%All in same category need to pick 100,000 features at random
%Want dictionary size 4000

%dict_size = 4000;
feat_size = 100000;
%each_class = feat_size/8;

descriptors = struct('label',[ones(jump_size) 2*ones(run_size) 3*ones(sit_size)],...
                     'info',[jump_data.info run_data.info sit_data.info],...
                     'tra',[jump_data.tra run_data.tra sit_data.tra],...
                     'tra_shape',[jump_data.tra_shape run_data.tra_shape sit_data.tra_shape],...
                     'hog',[jump_data.hog run_data.hog sit_data.hog],...
                     'hof',[jump_data.hof run_data.hof sit_data.hof],...
                     'mbhx',[jump_data.mbhx run_data.mbhx sit_data.mbhx],...
                     'mbhy',[jump_data.mbhy run_data.mbhy sit_data.mbhy]);

%%
%Choose number of descriptors
descriptors_chosen = struct('label',[zeros(1,feat_size)],...
                     'info',[zeros(10,feat_size)],...
                     'tra',[zeros(30,feat_size)],...
                     'tra_shape',[zeros(30,feat_size)],...
                     'hog',[zeros(96,feat_size)],...
                     'hof',[zeros(108,feat_size)],...
                     'mbhx',[zeros(96,feat_size)],...
                     'mbhy',[zeros(96,feat_size)]);

index = randperm(size(descriptors.label(1,:),2));
for i=1:feat_size
    j = index(i);
    descriptors_chosen.label(1,i) = descriptors.label(1,j);
    descriptors_chosen.info(10,i) = descriptors.info(10,j);
    descriptors_chosen.tra(30,i) = descriptors.tra(30,j);
    descriptors_chosen.tra_shape(30,i) = descriptors.tra_shape(30,j);
    descriptors_chosen.hog(96,i) = descriptors.hog(96,j);
    descriptors_chosen.hof(108,i) = descriptors.hof(108,j);
    descriptors_chosen.mbhx(96,i) = descriptors.mbhx(96,j);
    descriptors_chosen.mbhy(96,i) = descriptors.mbhy(96,j);
end

save('descriptors_chosen');
