clearvars;

obj = VideoReader('samplepics/jump1.avi');
frames = read(obj);

%%
% some video sequence
i = 1;
for imgi = 1 : size(frames(1,1,:),3)
    fname{i} = frames(:,:,imgi);
    i = i + 1;
end
N = length(fname);

%%
% compute the saliency maps for this sequence

param = makeGBVSParams; % get default GBVS params
param.channels = 'IF';  % but compute only 'I' instensity and 'F' flicker channels
param.levels = 3;       % reduce # of levels for speedup

motinfo = [];           % previous frame information, initialized to empty
for i = 1 : N
    [out{i} motinfo] = gbvs( fname{i}, param , motinfo );
end

%%
% display results
% figure;
% for i = 1 : N
%    subplot(2,N,i);    
%    imshow( fname{i} );
%    title( fname{i} );
%    subplot(2,N,N+i);
%    imshow( out{i}.master_map_resized );
% end

for i=1:N
    figure(1);
%     subplot(1,2,1);
%     imshow(fname{i});
%     subplot(1,2,2);
    imshow( out{i}.master_map_resized );
end

%%
%Remove corresponding trajectories   