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
clear;

direct = '/Users/holly/Documents/Project/dense_trajectory_release_v1.2/release/matlab/data/jpl';
files = dir(direct);

fileIndex = find(~[files.isdir]);
data = struct('name',{},'hog',{});

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
% feat_size = 100000;
% 
for i=1:size(data,1)
    if i==1
        descriptors = struct('name', repmat(string(data(1).name),1,size(data(1).hog,2)),'hog',data(1).hog);
    else
        descriptors.name = [descriptors.name repmat(string(data(i).name),1,size(data(i).hog,2))];
        descriptors.hog = [descriptors.hog data(i).hog];
    end
end
%  descriptors = struct('label',[ones(jump_size) 2*ones(run_size) 3*ones(sit_size)],...
%                      'info',[jump_data.info run_data.info sit_data.info],...
%                      'tra',[jump_data.tra run_data.tra sit_data.tra],...
%                      'tra_shape',[jump_data.tra_shape run_data.tra_shape sit_data.tra_shape],...
%                      'hog',[jump_data.hog run_data.hog sit_data.hog],...
%                      'hof',[jump_data.hof run_data.hof sit_data.hof],...
%                      'mbhx',[jump_data.mbhx run_data.mbhx sit_data.mbhx],...
%                      'mbhy',[jump_data.mbhy run_data.mbhy sit_data.mbhy]);

%%
%Choose number of descriptors
feat_size = 100000;

descriptors_chosen = struct('name',repmat(string(0),1,feat_size),'hog',[zeros(96,feat_size)]);
%                      'info',[zeros(10,feat_size)],...
%                      'tra',[zeros(30,feat_size)],...
%                      'tra_shape',[zeros(30,feat_size)],...
%                      'hog',[zeros(96,feat_size)],...
%                      'hof',[zeros(108,feat_size)],...
%                      'mbhx',[zeros(96,feat_size)],...
%                      'mbhy',[zeros(96,feat_size)]

% total =0;
% for i = 1:size(data,1)
%     total = total + size(data(i).hog,2);
% end
% 
% av = feat_size/total;
% 
% di=0;

% for k = 1:size(data,1)
    index = randperm(size(descriptors.hog,2));
%     name = data(k).name;
%     temp = uint16(av*size(data(k).hog,2));
    for i=1:feat_size
        j = index(i);
        descriptors_chosen.name(i) = descriptors.name(j);
%         descriptors_chosen.info(:,i+di) = data(k).info(:,j);
%         descriptors_chosen.tra(:,i+di) = data(k).tra(:,j);
%         descriptors_chosen.tra_shape(:,i+di) = data(k).tra_shape(:,j);
        descriptors_chosen.hog(:,i) = descriptors.hog(:,j);
%         descriptors_chosen.hof(:,i+di) = data(k).hof(:,j);
%         descriptors_chosen.mbhx(:,i+di) = data(k).mbhx(:,j);
%         descriptors_chosen.mbhy(:,i+di) = data(k).mbhy(:,j);
    end
%     di = di+temp;
% end

% save('descriptors_chosen','descriptors_chosen');
