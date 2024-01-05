# resilneuro
This is a repository for analyzing neuroimaging data on TAMU HPRC clusters for the [Human Movement Complexity Lab](https://hmcl.tamu.edu/).

Table of Contents
=================
  * [Introduction](#introduction)
  * [Heudiconv](#heudiconv)

# Introduction
The first step in processing the data is organizing the raw data, the DICOM (.dcm) files, into an appropriate file structure so that a BIDS converter can be used on it. BIDS ([Brain Imaging Database Structure](https://bids.neuroimaging.io/)) is a standardized way to organize neuroimaging data, and is how programs like fmriprep need the data to be organized.

### DICOM data should be stored in a structure like <br>
dicom

    dicom
    ├── sub-{subject id}
    |  └── ses-{session id}
    |     └── files.dcm
    └── ...

# Heudiconv
