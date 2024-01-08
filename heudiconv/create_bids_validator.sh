#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=create_bids_validator_sif                #Set the job name to "create_bids_validator_sif"
#SBATCH --time=18:00:00                    #Set the wall clock limit to 48hr
#SBATCH --nodes=1                          #Request 1 node
#SBATCH --ntasks-per-node=16               #Request 16 tasks/cores per node
#SBATCH --mem=5G                         #Request 5GB per node 
#SBATCH --output=create_bids_validator.%j               #Send stdout/err to "Example2Out.[jobID]" 

##OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL                    #Send email on all job events
#SBATCH --mail-user=jackpmanning@tamu.edu    #Send all emails to email_address 

# change drectory to scratch directory
cd $SCRATCH

# load web proxy
module load WebProxy

# pull latest bids validator image from dockerhub
singularity build bids_validator.sif docker://bids/validator:latest
