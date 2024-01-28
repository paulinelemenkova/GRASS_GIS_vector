#!/bin/sh

# create new location from raster map (file must contain projection metadata):
# grass -c myraster.tif /home/user/grassdata/mynewlocation
grass
#cd /Users/polinalemenkova/grassdata

# ----IMPORT AND PREPROCESSING-------------------------->

# ----------- overlay raster >
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172062_20230819_20230825_02_T1_SR_B1.TIF output=L_2023a_01
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172062_20230819_20230825_02_T1_SR_B2.TIF output=L_2023a_02
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172062_20230819_20230825_02_T1_SR_B3.TIF output=L_2023a_03
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172062_20230819_20230825_02_T1_SR_B4.TIF output=L_2023a_04
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172062_20230819_20230825_02_T1_SR_B5.TIF output=L_2023a_05
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172062_20230819_20230825_02_T1_SR_B6.TIF output=L_2023a_06 --overwrite
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172062_20230819_20230825_02_T1_SR_B7.TIF output=L_2023a_07
r.info L_2023a_07
# N:    -204285    S:    -436515   Res:    30                     |
# E:     345915    W:     118185   Res:    30
#
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172063_20230819_20230825_02_T1_SR_B1.TIF output=L_2023b_01
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172063_20230819_20230825_02_T1_SR_B2.TIF output=L_2023b_02
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172063_20230819_20230825_02_T1_SR_B3.TIF output=L_2023b_03
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172063_20230819_20230825_02_T1_SR_B4.TIF output=L_2023b_04
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172063_20230819_20230825_02_T1_SR_B5.TIF output=L_2023b_05
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172063_20230819_20230825_02_T1_SR_B6.TIF output=L_2023b_06
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_172063_20230819_20230825_02_T1_SR_B7.TIF output=L_2023b_07
g.list rast
r.info L_2023b_07
# N:    -364485    S:    -596415   Res:    30                     |
# E:     312015    W:      84585   Res:    30

# 1.
# g.region sets a new region for both rasters (to include both rasters)
g.region w=84585 e=345915 n=-204285 s=-596415

#
r.composite blue=L_2023a_01 green=L_2023a_02 red=L_2023a_04 output=L_2023a_RGB --overwrite
r.composite blue=L_2023b_01 green=L_2023b_02 red=L_2023b_04 output=L_2023b_RGB --overwrite
#
d.mon wx0
d.rast L_2023a_RGB
d.rast L_2023b_RGB
#
d.mon wx2
d.rast L_2023b_07
d.rast L_2023a_07
#
# Mosaic of SWIR-1 and SWIR-2 bands
g.region w=84585 e=345915 n=-204285 s=-596415
d.mon wx3
d.rast L_2023a_06
d.rast L_2023b_06
d.out.file output=SWIR_1 format=jpg
d.mon wx3
d.rast L_2023a_07
d.rast L_2023b_07
d.out.file output=SWIR_2 format=jpg

#
#v.in.ogr input=/Users/polinalemenkova/grassdata/Burundi/bdi_gc_adg.shp output=Burundi_LCT -o
#v.colors map=Burundi_LCT use=cat layer=1 rgb_column=LCCCODE color=bcyr
#d.vect map=Burundi_LCT display=shape rgb_column=LCCCODE

v.in.ogr input=/Users/polinalemenkova/grassdata/Burundi_Landsat/ne_110m_geography_regions_polys.shp output=Burundi_borders -o
v.in.ogr input=/Users/polinalemenkova/grassdata/Burundi_Landsat/ne_110m_lakes.shp output=Burundi_lakes -o
g.region vector=Burundi_lakes w=84585 e=345915 n=-204285 s=-596415 -p
g.region -l
v.info Burundi_lakes
d.vect map=Burundi_lakes display=shape

eval `g.region -g`
ogr2ogr -spat $w $s $e $n Burundi_cut.shp Burundi_borders.shp
ogr2ogr -spat w=84585 s=-596415 e=345915 n=-204285 Burundi_cut.shp Burundi_borders.shp
    
# ---CLUSTERING AND CLASSIFICATION------------------->
# grouping data by i.group
# Set computational region to match the scene
g.region w=84585 e=345915 n=-204285 s=-596415
i.group group=L_2023a subgroup=res_30m \
  input=L_2023a_06,L_2023a_07 --overwrite
#
# Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L_2023a subgroup=res_30m \
  signaturefile=cluster_L_2023a \
  classes=10 reportfile=rep_clust_L_2023a.txt --overwrite
#
# Classification by i.maxlik module
i.maxlik group=L_2023a subgroup=res_30m \
  signaturefile=cluster_L_2023a \
  output=L_2023a_cluster_classes reject=L_2023a_cluster_reject --overwrite
# ---------- 2nd image -------->
# g.region w=84585 e=345915 n=-204285 s=-596415
i.group group=L_2023b subgroup=res_30mb \
  input=L_2023b_06,L_2023b_07 --overwrite
#
# Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L_2023b subgroup=res_30mb \
  signaturefile=cluster_L_2023b \
  classes=10 reportfile=rep_clust_L_2023b.txt --overwrite

# Classification by i.maxlik module
i.maxlik group=L_2023b subgroup=res_30mb \
  signaturefile=cluster_L_2023b \
  output=L_2023b_cluster_classes reject=L_2023b_cluster_reject --overwrite
#g.region raster=L_2023b_cluster_classes w=84585 e=345915 n=-204285 s=-596415 -p
#
# assign colours
r.colors L_2023a_cluster_classes color=bcyr -e
r.colors L_2023b_cluster_classes color=bcyr -e
#
# display two rasters side by side
d.mon wx1
d.rast L_2023a_cluster_classes
d.rast L_2023b_cluster_classes
d.legend raster=L_2023b_cluster_classes title="Burundi: LCC" title_fontsize=12 font="Helvetica" fontsize=9 bgcolor=white border_color=white -c

# add bounding box
g.region w=84585 e=345915 n=-204285 s=-596415
#
# Creating a vector polygon from the current region extent.
v.in.region output=Burundi_bbox
v.info map=Burundi_bbox
d.vect map=Burundi_bbox display=shape color=black fill_color=none width=3
d.out.file output=Burundi_LCC format=jpg --overwrite
