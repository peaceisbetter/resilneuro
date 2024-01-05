# resilneuro
This is a repository for analyzing neuroimaging data on TAMU HPRC clusters for the [Human Movement Complexity Lab](https://hmcl.tamu.edu/).

Table of Contents
=================
  * [Introduction](#introduction)
  * [Heudiconv](#heudiconv)

# Introduction
The first step in processing the data is organizing the raw data, the DICOM (.dcm) files, into an appropriate file structure so that a BIDS converter can be used on it. BIDS ([Brain Imaging Database Structure](https://bids.neuroimaging.io/)) is a standardized way to organize neuroimaging data, and is how programs like fmriprep need the data to be organized.

### Your parent directory (aka project folder) should be in a structure like this <br>

    $SCRATCH
    ├── project-title
    |  └── codes
    |  └── dicom
    └── ...

### DICOM data should be stored in a structure like <br>
    dicom
    ├── sub-{subject id}
    |  └── ses-{session id}
    |     └── files.dcm
    └── ...
> you can omit the ses- level folders if you only have one visit per subject

# Heudiconv
The next step is to convert from DICOM to NIFTI, and to store the NIFTI files in a BIDS compliant data set. BIDS also requires a dataset_description.json file, and a participants.tsv file in the BIDS directory. 

We will use the tool "HeuDiConv" to convert from dicom to nifti, and store it in BIDS format. Heudiconv is best run through a container program, like docker or singularity. Since we are using the TAMU HPRC, we will be using singularity, because it was built specifically for use on HPC clusters. Singularity can run docker images, but we will use a .sif file (singularity file).

## First we will create the heudiconv_latest.sif file <br>
To start, change directory into your project's code folder
```shell
$cd $SCRATCH/yourproject/codes
```

To pull a docker image on the cluster we need to first connect the cluster to the internet. Us the following shell command to connect the compute node to the internet.
```shell
$module load WebProxy
```

Then, run the following command to run the create_heudiconv.sh script on the cluster
```shell
$sbatch create_heudiconv_sif.sh
```

This will create a 'heudiconv_latest.sif' file in the scratch directory. To change the directory where it is stored, you can alter the code in 'create_heudiconv_sif.sh' on the first executed line to 'cd $SCRATCH/your/file/path' or you can move it manually in the folder structure by clicking 'copy/move' and navigating to the appropriate folder.
