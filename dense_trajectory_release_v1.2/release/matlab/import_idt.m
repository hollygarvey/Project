function feature = import_idt (file, tra_len, l)
% import_idt: matlab interface of importing idt features from binary files
% Input:
%       file: the name of iDT features
%       tra_len: the length of improved trajectories (default: 15)
% Output:
%       feature:  imported idt features
    index = randperm(size(descriptors.label(1,:),2));
    fid = fopen(file,'rb');
    feat = fread(fid,[10+4*tra_len+96*3+108,inf],'float');
	feature = struct('label',[],'info',[],'tra',[],'tra_shape',[],'hog',[],'hof',[],'mbhx',[],'mbhy',[]);
	for i=1:6666
        feature.label = l;
		feature.info = feat(1:10,index(i));
		feature.tra = feat(11:10+tra_len*2,index(i));
                feature.tra_shape = feat(11+tra_len*2:10+tra_len*4,index(i));
                ind = 10+tra_len*4;
		feature.hog = feat(ind+1:ind+96,index(i));
		feature.hof = feat(ind+97:ind+204,index(i));
		feature.mbhx = feat(ind+205:ind+300,index(i));
		feature.mbhy = feat(ind+301:end,index(i));
	end
    fclose(fid);
end
