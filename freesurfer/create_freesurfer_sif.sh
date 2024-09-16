#!/bin/bash
# The purpose of this script is to create a singularity
# image of freesurfer in the current working directory

singularity pull docker://freesurfer/freesurfer:7.2.0
