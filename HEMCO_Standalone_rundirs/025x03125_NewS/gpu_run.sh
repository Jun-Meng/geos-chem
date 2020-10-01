#!/bin/bash
#SBATCH --account=def-rmartin
#SBATCH --nodes=1
#SBATCH --gres=gpu:2
#SBATCH --time=0-2:55
#SBATCH --ntasks-per-node=32
#SBATCH --mem=0
#SBATCH --mail-type=ALL
#SBATCH --mail-user=jun.meng@dal.ca
#SBATCH --job-name=dust_025
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

RunDir=`pwd`


cd $RunDir
#
./hemco_standalone.x HEMCO_sa_Config.rc > running_log 
