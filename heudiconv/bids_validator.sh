#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#SBATCH --job-name=bids_validator                #Set the job name to "bids_validator"
#SBATCH --time=18:00:00                    #Set the wall clock limit to 48hr
#SBATCH --nodes=1                          #Request 1 node
#SBATCH --ntasks-per-node=16               #Request 16 tasks/cores per node
#SBATCH --mem=5G                         #Request 5GB per node 
#SBATCH --output=create_heudiconv_sif.%j               #Send stdout/err to "Example2Out.[jobID]" 

##OPTIONAL JOB SPECIFICATIONS
#SBATCH --mail-type=ALL                    #Send email on all job events
#SBATCH --mail-user=jackpmanning@tamu.edu    #Send all emails to email_address 

# cd into bids dir
cd ../bids

# create variable to store bids_validator.sif path
bidsval=$SCRATCH/software/bids_validator.sif

# execute the bids validator singularity image
singularity run -B "$(pwd)":/data:ro "${bidsval}" /data
