# README -- How to use this repo to run HEMCO standalon to generate offline dust emissions
----------------------------------------------------------------------

*GC source code branch: v11-01-Patches-for-HEMCO-usingNativeResMet*

30 September 2020

Jun Meng

jun.meng@dal.ca

-----------------------------------------------------------------------
This repository contains the source code for GEOS-Chem v11-01 (with modifications) and run directory for HEMCO standalon.The modifications to standard GEOS-Chem v11-01 are mostly from David A. Ridley.

The emissions are based on the meteorological field (GEOS-FP) archived at Compute Canada (http://geoschemdata.computecanada.ca/ExtData/GEOS_0.25x0.3125/GEOS_FP/) at native resolution (0.25x0.3125)

The dust source function (under /home/junmeng/Code.v11-01_GC_dust_GEOSFP/HEMCO_Standalone_rundirs/025x03125_NewS/) is updated to a finer resolution file from Paul Ginoux. 

1. **HEMCO_sa_Config.rc** sets the input/output folders and lists the variables required for dust emission. Ensure that these directories match your system.
".YYYMMDDHHMM.nc" will be appended to the end of the output DiagnPrefix. The standalone code reads in met fields directly and maps them onto the variables required by the dust emissions code /HEMCO/Extensions/hcox_dustdead_mod.F

2. **HEMCO_sa_Time.rc** indicates the range of times for the emission calculatio and the timestep. Emissions are calculated hourly as this is the output frequency, and the frequency at which the offline dust emissions are read into the GEOS-Chem model.

3. **HEMCO_sa_Grid.rc** specifies the HEMCO grid on which the emissions are calculated.

4. The species to be traced and the diagnostics to be output are included in **HEMCO_sa_Spec.rc** and **HEMCO_sa_Diagn.rc**

You will need to generate **hemco_standalone.x** by compiling GEOS-Chem with the following: ```make -j4 COMPILER=ifort MET=geosfp GRID=025x03125 CHEM=tropchem```. The GEOS-Chem model will unlikely compile at this resolution as a global model, however, it should get far enough to output the **hemco_standalone.x** into /bin/

Once everything is set up, run **hemco_standalone.x** in the HEMCO_Standalone_rundirs and the dust emissions will be output in the selected directory.

Note: Dust emissions will be saved with no scaling factor. This is applied to the tracers when they are read in via HEMCO_Config.rc. Suggested scale factor to make the global total annual dust emission to 2000 Tg is 5.7141e-4.

------------------------------------------------------------------------------

The GEOS-Chem model can now be run using offline dust emissions:

Switching off DustDead (105) and DustGinoux (106) extensions in HEMCO_Config.rc. The location of the emissions to read in are required and should be added in the SECTION BASE EMISSIONS:

----------------------------------
    --- OFFLINE DUST ---
----------------------------------

	0 EMIS_DST1 /net/seurat/data/ctm/offline_dust/$YYYY/dust_emissions_025x03125.$YYYY$MM$DD$HH00.nc EMIS_DST1 1980-2017/1-12/1-31/0-23 C xy kg/m2/s DST1 606 1 2

	0 EMIS_DST2 /net/seurat/data/ctm/offline_dust/$YYYY/dust_emissions_025x03125.$YYYY$MM$DD$HH00.nc EMIS_DST2 1980-2017/1-12/1-31/0-23 C xy kg/m2/s DST2 606 1 2
	
	0 EMIS_DST3 /net/seurat/data/ctm/offline_dust/$YYYY/dust_emissions_025x03125.$YYYY$MM$DD$HH00.nc EMIS_DST3 1980-2017/1-12/1-31/0-23 C xy kg/m2/s DST3 606 1 2

	0 EMIS_DST4 /net/seurat/data/ctm/offline_dust/$YYYY/dust_emissions_025x03125.$YYYY$MM$DD$HH00.nc EMIS_DST4 1980-2017/1-12/1-31/0-23 C xy kg/m2/s DST4 606 1 2

* This will point to the offline hourly dust emissions and extract the EMIS_DSTX variables and to be put into the DSTX tracers in place of the online calculation.

* The offline emissions in this database have no scale factor applied, so users should apply the required scale factor in their application. Suggested scale factor to make the global total annual dust emission to 2000 Tg is 5.7141e-4. 

* 606 DUST_EMISSIONS    5.7141e-4                                       - -               - xy 1 1


