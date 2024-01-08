# Resiliency Project Neuroimaging Codes
This is a repository for analyzing neuroimaging data on TAMU HPRC clusters for the [Human Movement Complexity Lab](https://hmcl.tamu.edu/).

Table of Contents
=================
  * [Introduction](#introduction)
  * [Heudiconv](#heudiconv)
  * [fMRIPrep](#fMRIPrep)

# Introduction
The first step in processing the data is organizing the raw data, the DICOM (.dcm) files, into an appropriate file structure so that a BIDS converter can be used on it. BIDS ([Brain Imaging Database Structure](https://bids.neuroimaging.io/)) is a standardized way to organize neuroimaging data, and is how programs like fmriprep need the data to be organized. The heudiconv portion of this guide is following along with the Stanford Center for Reproducible Neuroscience's [BIDS tutorial series](https://reproducibility.stanford.edu/bids-tutorial-series-part-2a/).

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

We will use the tool [heudiconv](https://heudiconv.readthedocs.io/en/latest/index.html) to convert from dicom to nifti, and store it in BIDS format. Heudiconv is best run through a container program, like docker or singularity. Since we are using the TAMU HPRC, we will be using singularity, because it was built specifically for use on HPC clusters. Singularity can run docker images, but we will use a .sif file (singularity file).

## First we will create the heudiconv_latest.sif file <br>
> only do this step if you do not have an image for heudiconv_latest<br>

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

## Second, we will run heudiconv on a single subject to create the metadata files needed to run the entire dataset
Run the create_heuristic.sh shell script with sbatch, and specify a single subject with the -s option. In this example, the subject folder name is 'Resiliency_201'.
```shell
$sbatch create_heuristic.sh Resiliency_201
```
After running heudiconv the bids directory will be populated with the following contents:<br>

<p align="center">
  <img src="https://github.com/peaceisbetter/resilneuro/blob/main/images/heudiconvoutput.png" width="550" title="Heudiconv First Run Output">
</p>

## Third we will modify the heuristic.py file<br>
> TIP: The .heudiconv folder is a Dotfile, meaning it is hidden by default. To see the folder and it's contents, click the "Show Dotfiles" check box.

'heuristic.py' is a general file and is not specific to your dataset yet. This is the file that heudiconv will use to organize your dataset into a bids compliant data set. If this step is done wrong, fmriprep will not run properly, and will give an error indicating that the directory is not bids compliant.

Download the .heudiconv folder to your local machine and open both heuristic.py and dicominfo.tsv in your preferred IDE. You may need to load dicom.tsv into a software like R or excel for it to be visually appealing. You can use [loaddicominfo.R](https://github.com/peaceisbetter/resilneuro/blob/main/heudiconv/loaddicominfo.R) for this.<br>

__Before moving on to step 4, delete the .heudiconv folder from the HPC cluster.__

>Once I understand how to make the heuristic file, I'll update this portion. For now it has already been done, so we will be using the myheuristic.py file. Further information is available in the heudiconv documentation [here](https://reproducibility.stanford.edu/bids-tutorial-series-part-2a/#heuman4). After you modify the heuristic.py file, upload it to the codes folder.

## Fourth, after modifying the heuristic.py file, we will run the heudiconv conversion
Heudiconv can be run on a single subject by using the following command:

```
$singularity run -B $SCRATCH/path/to/parent:/parent $SCRATCH/path/to/heudiconv_latest.sif --files $SCRATCH/parent/dicom/subject -o /parent/bids -s subject's_foldername -c dcm2niix -b -f /parent/codes/myheuristic.py
```

However, it is possible to batch process the heudiconv conversion. To do so we will use batch_run_heudiconv.sh. In the shell script there is a dicom variable which you will have to manipulate. The 'dicom' variable contains the file path to the dicom files within the scratch directory. If you have set up the folder directory correctly, it should be $SCRATCH/project_folder/dicom, and you will change 'project_folder' to whatever you have named your project's folder.

```shell
dicom=$SCRATCH/resr3/dicom
```
After that, if batch_run_heudiconv is in the codes folder, you will submit it as a job using slurm.

```
$sbatch batch_run_heudiconv.sh
```

If that worked correctly your bids folder should look something like this:

<p align="center">
  <img src="https://github.com/peaceisbetter/resilneuro/blob/main/images/after_heudiconv_second_pass.jpg" width="550" title="Heudiconv First Run Output">
</p>

Before moving on to fmriprep, we should validate the bids directory using [bids-validator](https://github.com/bids-standard/bids-validator?tab=readme-ov-file#docker-image). To do so, we will create a singularity image of bids-validatore, store it in our software file, then submit the singularity run command as a batch job using slurm.<br>

To start this process, create the bids-validator image by executing the following script:

```
$sbatch create_bids_validator.sh
```

This will create the singularity image in the scratch directory. Move it to the software folder then run the bids_validator.sh script through slurm:

```
$sbatch bids_validator.sh
```

The output will be in the code folder. Check it to see if the directory is valid. If you get no errors, then you are ready to move on.

# fMRIPrep
