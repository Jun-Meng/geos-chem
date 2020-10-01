#! /bin/tcsh -f

# Set all PBS queue options, so no need to specify upon submit
# (retain hash-tag in front of all PBS command)
#PBS -N 0251205
#PBS -q long
#PBS -e localhost:$PBS_O_WORKDIR/$PBS_JOBNAME.e$PBS_JOBID
#PBS -o localhost:$PBS_O_WORKDIR/$PBS_JOBNAME.o$PBS_JOBID
#PBS -l nodes=1:ppn=24
### #PBS -l select=1:ncpus=24:NodeType=hyperthread
#PBS -m ae
#PBS -M daridley@mit.edu

# print some job info to the output file
cd $PBS_O_WORKDIR
echo `date`
echo Working directory is $PBS_O_WORKDIR
echo Running on host `hostname`
echo JobID is $PBS_JOBID

# set stacksize memory to unlimited
limit stacksize unlimited

# change the stack size
setenv KMP_STACKSIZE 100000000

# set correct ifort libraries
source /home/software/intel/bin/ifortvars.csh intel64

# Remove previous log and run the code
rm -f log_$PBS_JOBNAME
time ./hemco_standalone.x HEMCO_sa_Config.rc > log_$PBS_JOBNAME

# Exit normally
exit(0)
