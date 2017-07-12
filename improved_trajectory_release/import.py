import gzip
import numpy as np
import scipy.io as sio
import glob, os
import timeit

#change directory
os.chdir("/jpl_trajectories")

#iterate over every file in directory
for file in glob.glob("*.gz"):

    #initialize matrix. extra column for name
    d = 1+10+30+96*3+108
    mat = np.zeros([1, d])
    #counter for naming videos
    i = 1

    f = gzip.open(file)
    name = f.name
    name = name.replace('.gz','')
    print('File {} open'.format(name))

    start_time = timeit.default_timer()

    for line in f:
        #here need to for each line enter to matrix which will then output
        #might be faster to do in C++
        #temp = np.zeros([1,d])
        #add in the line
        l = line.split('\t')
        l.remove('\n')
        #if i==1:
        #    print(l)
        #don't need name atm
        #temp[0] = name
        temp = map(float,l)
        #temp = l

        #append to original matrix
        mat = np.vstack((mat,temp))
        i+=1
        #if i%1000==0:
        #    print('Row {}'.format(i))

    f.close()

    print('Final row = {}'.format(i))

    #remove first row of zeros
    mat = np.delete(mat,(0),axis=0)

    elapsed = timeit.default_timer() - start_time
    print('Finished processing file, time elapsed = {}s'.format(elapsed))


    #save matrix with sio
    sio.savemat('{}.mat'.format(name), {'data':mat})
    print('Matrix {} saved')


#iterate over all files in folder:
#os.chdir("/mydir")
#for file in glob.glob("*.txt"):
#    print(file)
