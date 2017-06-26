%%Load Data
jump_data = import_idt('out.features.jump*.gz',15);
run_data = import_idt('out.features.run.gz',15);
sit_data = import_idt('out.features.sit.gz',15);
% sdown_data = import_idt('out.stairdown.sit.gz',15);
% sup_data = import_idt('out.features.stairup.gz',15);
% stand_data = import_idt('out.features.stand.gz',15);
% turn_data = import_idt('out.features.turn.gz',15);
% walk_data = import_idt('out.features.walk.gz',15);


%%
%Create dictionary
%All in same category need to pick 100,000 features at random
%Want dictionary size 4000

%dict_size = 4000;
feat_size = 100000;
%each_class = feat_size/8;

jump_size = size(jump_data.info(1,:));
run_size = size(run_data.info(1,:));
sit_size = size(sit_data.info(1,:));

descriptors = struct('label',[ones(jump_size) 2*ones(run_size) 3*ones(sit_size)],...
                     'info',[jump_data.info run_data.info sit_data.info],...
                     'tra',[jump_data.tra run_data.tra sit_data.tra],...
                     'tra_shape',[jump_data.tra_shape run_data.tra_shape sit_data.tra_shape],...
                     'hog',[jump_data.hog run_data.hog sit_data.hog],...
                     'hof',[jump_data.hof run_data.hof sit_data.hof],...
                     'mbhx',[jump_data.mbhx run_data.mbhx sit_data.mbhx],...
                     'mbhy',[jump_data.mbhy run_data.mbhy sit_data.mbhy]);
%clear jump_data;
%clear run_data;
%clear sit_data;
clear jump_size;
clear run_size;
clear sit_size;

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
