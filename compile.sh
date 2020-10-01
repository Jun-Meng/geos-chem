#!/bin/bash
#SBATCH --account=rrg-rmartin-ab
#SBATCH --time=0-5:5
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=10G
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

CodeDir=/scratch/junmeng/GCC/Code.v11-01/
RunDir=/scratch/junmeng/GCC/rundirs/merra2_2x25_soa/
MET=MERRA2
GRID=2x25
CHEM=SOA


#cd $CodeDir
cd $RunDir
make realclean COMPILER=ifort FC=ifort
#make -j8 MET=$MET GRID=$GRID CHEM=$CHEM COMPILER=ifort FC=ifort OMP=yes
#build only 
#make -j4 mpbuild  
#compile and run
make -j4 mp     
#
#mv $CodeDir/bin/geos $RunDir

#cd $RunDir
#./geos 
