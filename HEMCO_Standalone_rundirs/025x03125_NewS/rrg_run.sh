#!/bin/bash
#SBATCH --account=rpp-rmartin
####SBATCH --account=def-rmartin
#SBATCH --time=0-23:50
#SBATCH --ntasks-per-node=32
#SBATCH --mem=0
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jun.meng@dal.ca
#SBATCH --job-name=dust_025_NewS
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

RunDir=`pwd`


cd $RunDir
#
./hemco_standalone.x HEMCO_sa_Config.rc > running_log 
