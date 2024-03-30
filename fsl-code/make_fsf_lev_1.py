#!/usr/bin/python

# %%
# import necessary modules
import os
import glob
import numpy as np
import re
import pandas as pd

# %%
# Set path to the directory
cdir = os.getcwd()

# Set path to parent directory
pardir = os.path.dirname(cdir)
pattern = "sub-Resiliency[0-9][0-9][0-9]_task-STERN_dir-AP_run-[0-3]_space-MNI152NLin2009cAsym_desc-preproc_bold.nii.gz"

# set path to fsfdir, where new fsf files will be put
fsfdir = cdir + "/fsfdir"
condir = pardir + "/cond"

# get all the subdirectory paths
subdirs = glob.glob("%s/fmriprep/sub-Resiliency[0-9][0-9][0-9]/func/"%pardir)
subdirs = [s for s in subdirs if 'sub-Resiliency305' not in s]
print("This is how many subject folders there are: " + str(len(subdirs)))

# %%
# create an empty list to populate with all split sub directories
splitdir_ls = []

for path in subdirs:
    # split the directory string up into individual strings
    splitdir = path.split('/')
    # append to the list
    splitdir_ls = splitdir_ls + [splitdir]

# create an array with the split directory list
np_spdir = np.array(splitdir_ls)

# make an array with the file name for each task-STERN run (0-3)
# use subdirs for this
task_files = []
for subdir in subdirs:
    task_files.extend(glob.glob(os.path.join(subdir + '/' + pattern)))

# %%
### For loop should start here

for file in task_files:
    # split the task file path
    sp_file = file.split('/')
    print(sp_file)

    # specify the subject number
    ### IMPORTANT: iterate over the first index for np_spdir(index, 7), 0 is for testing
    subnum = sp_file[7]
    print('This is subnum: ' + subnum)

    # get the runnum from the 10th element of sp_file
    xyz = sp_file[9].split('_')
    runnum = xyz[3]
    print('This is runnum: ' + runnum)

    # Use fslnvols to find the timing for each scan
    ntime = os.popen('fslnvols %s'%(task_files[0])).read().rstrip()

    # find trial difficulty from cond folder for each run
    # IMPORTANT: These {}tsv objects have to point to the filname only for the tsv files, with the extension
    cond_files = os.listdir(os.path.join(condir + '/' + subnum))

    # replace 'run-1' with runnum
    # The trial block should always be followed by the next sequential block
    for item in cond_files:
        if re.search('low', item) and re.search(runnum, item):
            lowtsv = item
        elif re.search('medium', item) and re.search(runnum, item):
            medtsv = item
        elif re.search('high', item) and re.search(runnum, item):
            hightsv = item

    # Get the file name for low rest
    if re.search('block-1', lowtsv) != None:
        for s in cond_files:
            if re.search('block-2', s) and re.search(runnum, s):
                low_rest = s
    elif re.search('block-3', lowtsv) != None:
        for s in cond_files:
            if re.search('block-4', s) and re.search(runnum, s):
                low_rest = s
    elif re.search('block-5', lowtsv) != None:
        for s in cond_files:
            if re.search('block-6', s) and re.search(runnum, s):
                low_rest = s

    # get the file name for med rest
    if re.search('block-1', medtsv) != None:
        for s in cond_files:
            if re.search('block-2', s) and re.search(runnum, s):
                med_rest = s
    elif re.search('block-3', medtsv) != None:
        for s in cond_files:
            if re.search('block-4', s) and re.search(runnum, s):
                med_rest = s
    elif re.search('block-5', medtsv) != None:
        for s in cond_files:
            if re.search('block-6', s) and re.search(runnum, s):
                med_rest = s

    # Get the file name for high rest
    if re.search('block-1', hightsv) != None:
        for s in cond_files:
            if re.search('block-2', s) and re.search(runnum, s):
                high_rest = s
    elif re.search('block-3', hightsv) != None:
        for s in cond_files:
            if re.search('block-4', s) and re.search(runnum, s):
                high_rest = s
    elif re.search('block-5', hightsv) != None:
        for s in cond_files:
            if re.search('block-6', s) and re.search(runnum, s):
                high_rest = s

    # # create a dictionary with the replacements
    replace = {'SUBNUM':subnum, 
               'NTPTS':ntime, 
               'RUNNUM':runnum, 
               'LOWTSV':lowtsv, 
               'MEDTSV':medtsv, 
               'HIGHTSV':hightsv, 
               'LOWREST':low_rest,
               'MEDREST':med_rest,
               'HIGHREST':high_rest}

    # open the template.fsf file
    with open("%s/template.fsf"%(cdir)) as infile:
        # open the new file to be written to
        with open("%s/design_%s_%s.fsf"%(fsfdir, subnum, runnum), 'w') as outfile:
            for line in infile:
                for src, target in replace.items():
                    line = line.replace(src, target)
                outfile.write(line)

# print stuff for debugging
print('\n' + 'This is ntime: ' + ntime + '\n')
print(subnum)
print('This is subdirs[0]: \n' + subdirs[0] + '\n')
# print(task_files)

# %%
