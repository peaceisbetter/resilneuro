#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=create_heuristic                #Set the job name to "fmriprep"
#SBATCH --time=18:00:00                    #Set the wall clock limit to 48hr
#SBATCH --nodes=1                          #Request 1 node
#SBATCH --ntasks-per-node=16               #Request 16 tasks/cores per node
#SBATCH --mem=5G                         #Request 5GB per node 
#SBATCH --output=heuristic.%j               #Send stdout/err to "Example2Out.[jobID]" 

##OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL                    #Send email on all job events
#SBATCH --mail-user=jackpmanning@tamu.edu    #Send all emails to email_address 

# Enter subject in command call
subject=$1

# Create an object to store the file path to the dicom files on the scratch directory
dicom='../dicom/'

# Create an object to store the file path to the heudiconv singularity file
heudiconv=$SCRATCH/software/heudiconv_latest.sif

# Run the heudiconv singularity container to create the heuristic file
singularity run -B $SCRATCH/resr3:/parent ${heudiconv} --files /parent/dicom/${subject} -o /parent/bids -s ${subject} -c none -b -f convertall
