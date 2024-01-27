#!/bin/sh

# create new location from raster map (file must contain projection metadata):
# grass -c myraster.tif /home/user/grassdata/mynewlocation
grass
#cd /Users/polinalemenkova/grassdata
#grass -c LC09_L2SP_179073_20220419_20230421_02_T1_SR_B1.tif /Users/polinalemenkova/grassdata/France

# ----IMPORT AND PREPROCESSING-------------------------->
# g.mapset location=France mapset=PERMANENT

g.list rast
# importing the image subset with 7 Landsat bands and display the raster map
r.import input=/Users/polinalemenkova/grassdata/France/LC09_L2SP_199028_20231011_20231012_02_T1_SR_B1.TIF output=L_12102023_01 extent=region resolution=region --overwrite
r.import input=/Users/polinalemenkova/grassdata/France/LC09_L2SP_199028_20231011_20231012_02_T1_SR_B2.TIF output=L_12102023_02 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/France/LC09_L2SP_199028_20231011_20231012_02_T1_SR_B3.TIF output=L_12102023_03 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/France/LC09_L2SP_199028_20231011_20231012_02_T1_SR_B4.TIF output=L_12102023_04 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/France/LC09_L2SP_199028_20231011_20231012_02_T1_SR_B5.TIF output=L_12102023_05 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/France/LC09_L2SP_199028_20231011_20231012_02_T1_SR_B6.TIF output=L_12102023_06 extent=region resolution=region
r.import input=/Users/polinalemenkova/grassdata/France/LC09_L2SP_199028_20231011_20231012_02_T1_SR_B7.TIF output=L_12102023_07 extent=region resolution=region
#
# https://www.eea.europa.eu/en/datahub/datahubitem-view/573ff9d5-6889-407f-b3fc-cfe3f9e23941
r.import input=/Users/polinalemenkova/grassdata/France/eea_r_3035_100_m_etm-terrestrial-r_2012_v3-1_r00.tif output=ecosystems extent=region resolution=region --overwrite
# define colors and raster category labels
r.euro.ecosystem -1 input=ecosystems
# visualization
d.mon wx1
g.region raster=ecosystems -p
# r.colors L_12102023_cluster_reject color=wave -e
r.colors ecosystems color=corine -e
d.rast ecosystems
d.legend raster=ecosystems title="Ecosystem types of Europe. Terrestrial habitats" title_fontsize=14 lines=10 font="Helvetica" fontsize=13 bgcolor=white border_color=white
d.out.file output=France_ecosystems format=jpg --overwrite
#
r.euro.ecosystem -1 input=ecosystems
# visualization
d.mon wx2
g.region raster=ecosystems -p
# r.colors L_12102023_cluster_reject color=wave -e
r.colors ecosystems color=bcyr
r.info ecosystems
d.rast ecosystems
# d.legend raster=ecosystems title="Ecosystem types of Europe. Terrestrial habitats" title_fontsize=14 lines=10 font="Helvetica" fontsize=13 bgcolor=white border_color=white -n
d.out.file output=France_ecosystems_2 format=jpg --overwrite

# ----------- VECTOR MAPS -------->
# import vector shape files into GRASS GIS
v.in.ogr input=/Users/polinalemenkova/grassdata/Niger/ner_gc_adg.shp output=Niger_LCT
# retreive metadata information from vector map and its topology status:
v.info map=Niger_LCT
v.info -c Niger_LCT
#
g.list vect
# Define color table wave based on categories from layer 1:
# v.colors map=Niger_LCT layer=LCCCode color=corine
v.colors map=Niger_LCT layer=GRIDCODE color=corine
v.info -c Niger_LCT
#
# Mapping
d.mon wx1
#d.vect Niger_LCT color=none
#d.vect map=Niger_LCT
g.region vector=Niger_LCT
#d.vect -c map=Niger_LCT display=shape attribute_column=GRIDCODE color=none
d.vect -c map=Niger_LCT display=shape attribute_column=LCCCode color=none
d.legend vector=Niger_LCT title="Niger LCT" title_fontsize=14 font="Helvetica" fontsize=13 bgcolor=white border_color=white
d.out.file output=France_12102023 format=jpg --overwrite
#

# ----------- VECTOR MAPS -------->
# import vector shape files into GRASS GIS
v.in.ogr input=/Users/polinalemenkova/grassdata/Burundi/bdi_gc_adg.shp output=Burundi_LCT
# retreive metadata information from vector map and its topology status:
# v.info map=Burundi_LCT
v.info -c Burundi_LCT
# Mapping
g.region vector=Burundi_LCT -p
d.mon wx1
d.vect -c map=Burundi_LCT color=none display=shape legend_label="Land cover class"
d.legend.vect -b at=2,40 title="Burundi: LCC" font=Sans \
    symbol_size=26 fontsize=16 title_fontsize=20

# display=shape
# connect full DBF database to vector map, use "VALUE" as the key column
#v.db.connect map=Burundi_LCT driver=dbf table=bdi_gc_adg.dbf key=value -o
#

