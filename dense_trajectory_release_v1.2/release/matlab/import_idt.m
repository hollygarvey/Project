function feature = import_idt (file, tra_len, l)
% import_idt: matlab interface of importing idt features from binary files
% Input:
%       file: the name of iDT features
%       tra_len: the length of improved trajectories (default: 15)
% Output:
%       feature:  imported idt features
    fid = fopen(file,'rb');
    feat = fread(fid,[10+4*tra_len+96*3+108,inf],'float');
    index = randperm(size(feat(1,:),2));
	feature = struct('label',zeros(1,6666),'info',zeros(10,6666),'tra',zeros(30,6666),'tra_shape',zeros(30,6666),'hog',zeros(96,6666),'hof',zeros(108,6666),'mbhx',zeros(96,6666),'mbhy',zeros(96,6666));
	for i=1:6666
        feature.label(i) = l;
		feature.info(:,i) = feat(1:10,index(i));
		feature.tra(:,i) = feat(11:10+tra_len*2,index(i));
                feature.tra_shape(:,i) = feat(11+tra_len*2:10+tra_len*4,index(i));
                ind = 10+tra_len*4;
		feature.hog(:,i) = feat(ind+1:ind+96,index(i));
		feature.hof(:,i) = feat(ind+97:ind+204,index(i));
		feature.mbhx(:,i) = feat(ind+205:ind+300,index(i));
		feature.mbhy(:,i) = feat(ind+301:end,index(i));
	end
    fclose(fid);
end
