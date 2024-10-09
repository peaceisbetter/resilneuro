# Processing fMRIPrepped data in FSL
This is a readme.md file containing instructions on how to import fMRI data which has been preprocessed with fMRIPrep into FSL for further analysis including:
1. Spatial smoothing (fMRIprep does NOT do any spatial smoothing)
2. First level analysis
3. Second level analysis

## To get the events folders and files
First run make_events_tsv.R
Then run make_events_tsv_FSL.R
Then run make_fsf_lev_1.py

These are all run interactively. Run the R script line by line starting from the top. Run the Python script interactively at each # %% comment (this comment turns it functionally into a code chunk/cell like a python notebook file .ipynb)


## First
Make sure your data is in bids format (see bids validator).

## Second
Create a template.fsf file. To do this, open and go through the FSL GUI with one scan, and save the fsf file. For this step, both [mumfordbrainstats](https://www.youtube.com/watch?v=Js0tlNXxd9k&list=PLB2iAtgpI4YHlH4sno3i3CUjCofI38a-3&index=12&ab_channel=mumfordbrainstats) and [andy’s brain blog](https://www.youtube.com/watch?v=xa00DEk42w4&list=PLIQIswOrUH69lUeHurAk9pLHOPTzQ6M72&index=5&ab_channel=AndrewJahn) have videos on this. 

The template.fsf file will have to be tailored to your data set, so you won’t be able to just copy/paste someone else’s. The template.fsf file present in this repository is specific to this project.

Select ‘First-level analysis’ and ‘Statistics’ at the top of FEAT.

## Third
Copy/paste and rename your .fsf file to template.fsf.

Then, open it in a text editor (like visual studio code) and put searchable strings into it that you can search/replace with with a python script like [make_fsf_lev_1.py](https://github.com/peaceisbetter/resilneuro/blob/main/fsl-code/make_fsf_lev_1.py). These strings go in places that change each for each iteration of a loop that you would run to go through all of the subjects. 
For example, I put SUBNUM in my template.fsf file, and created a dictionary in python where SUBNUM takes on the value of the subject identifier during each loop iteration. 

*The following is an exerpt from template.fsf:*
```
# Output directory
set fmri(outputdir) "/gpfs/home/jackpmanning/Documents/resil/feat/SUBNUM"
```

## Fourth
After the template.fsf file has been updated with the searchable strings you want, you will have to use the template.fsf file to create an .fsf file for every subject, every condition, and every run. See [run_fsl_python.ipynb](https://github.com/peaceisbetter/resilneuro/blob/main/fsl-code/run_fsl_python.ipynb) for example code on how to do this, along with the output to expect at each step
> run_fsl_python.ipynb is a jupyter notebook using python to run fsl for each .fsf file I created.
