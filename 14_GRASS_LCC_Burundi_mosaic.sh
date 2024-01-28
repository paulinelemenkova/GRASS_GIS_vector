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
#
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_173062_20230810_20230812_02_T1_SR_B1.TIF output=L_2023c_01
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_173062_20230810_20230812_02_T1_SR_B2.TIF output=L_2023c_02
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_173062_20230810_20230812_02_T1_SR_B3.TIF output=L_2023c_03
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_173062_20230810_20230812_02_T1_SR_B4.TIF output=L_2023c_04
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_173062_20230810_20230812_02_T1_SR_B5.TIF output=L_2023c_05
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_173062_20230810_20230812_02_T1_SR_B6.TIF output=L_2023c_06
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/LC08_L2SP_173062_20230810_20230812_02_T1_SR_B7.TIF output=L_2023c_07
#
r.info L_2023c_07
# N: -203953.96259963    S: -438395.88326795   Res: 29.8880572    |
# E: 176633.07390249    W: -53324.3699252   Res: 29.88789236
#
g.list rast
r.info L_2023b_07
# N:    -364485    S:    -596415   Res:    30                     |
# E:     312015    W:      84585   Res:    30

# 1.
# g.region sets a new region for both rasters (to include both rasters)
g.region w=84585 e=345915 n=-204285 s=-596415

# new
g.region w=-53324 e=345915 n=-203953 s=-596415
#
r.composite blue=L_2023a_01 green=L_2023a_02 red=L_2023a_04 output=L_2023a_RGB --overwrite
r.composite blue=L_2023b_01 green=L_2023b_02 red=L_2023b_04 output=L_2023b_RGB --overwrite
r.composite blue=L_2023c_01 green=L_2023c_02 red=L_2023c_04 output=L_2023c_RGB --overwrite
#
d.mon wx0
d.rast L_2023a_RGB
d.rast L_2023b_RGB
d.rast L_2023c_RGB
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
v.in.ogr input=/Users/polinalemenkova/grassdata/Burundi_Landsat/ne_10m_admin_0_countries.shp output=world_countries -o
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
# ---------- 3rd image -------->
# g.region w=84585 e=345915 n=-204285 s=-596415
i.group group=L_2023c subgroup=res_30mc \
  input=L_2023c_06,L_2023c_07 --overwrite
#
# Clustering: generating signature file and report using k-means clustering algorithm
i.cluster group=L_2023c subgroup=res_30mc \
  signaturefile=cluster_L_2023c \
  classes=10 reportfile=rep_clust_L_2023c.txt --overwrite

# Classification by i.maxlik module
i.maxlik group=L_2023c subgroup=res_30mc \
  signaturefile=cluster_L_2023c \
  output=L_2023c_cluster_classes reject=L_2023c_cluster_reject --overwrite
# assign colours
r.colors L_2023a_cluster_classes color=bcyr -e
r.colors L_2023b_cluster_classes color=bcyr -e
r.colors L_2023c_cluster_classes color=bcyr -e
#
# display two rasters side by side
d.mon wx1
d.rast L_2023a_cluster_classes
d.rast L_2023b_cluster_classes
d.legend raster=L_2023b_cluster_classes title="Burundi: LCC" title_fontsize=12 font="Helvetica" fontsize=9 bgcolor=white border_color=white -c

# add bounding box
g.region w=84585 e=345915 n=-204285 s=-596415
#
g.region w=-53324 e=345915 n=-203953 s=-596415 --overwrite
# Creating a vector polygon from the current region extent.
v.in.region output=Burundi_bbox --overwrite
v.info map=Burundi_bbox
d.vect map=Burundi_bbox display=shape color=black fill_color=none width=3
d.out.file output=Burundi_LCC format=jpg --overwrite

#v.in.ogr input=/Users/polinalemenkova/grassdata/Burundi_Landsat/ne_10m_admin_0_countries.shp output=world_countries -o --overwrite
#v.in.ogr input=/Users/polinalemenkova/grassdata/Burundi_Landsat/ne_10m_populated_places.shp output=world_cities -o

# 2. add geographic vector data
# add cities
# import SHAPE file at full extent and reproject to current location projection
v.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/ne_10m_populated_places.shp output=Burundi_cities extent=region --overwrite
# v.info Burundi_cities
db.describe -c Burundi_cities
# display
#
# add countries
# import SHAPE file at full extent and reproject to current location projection
v.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/ne_10m_admin_0_countries.shp output=Burundi_border extent=region --overwrite
v.info Burundi_border
db.describe -c Burundi_border
# add grayscale earth
r.import input=/Users/polinalemenkova/grassdata/Burundi_Landsat/GRAY_HR_SR_W.TIF extent=region resolution=region --overwrite output=shaded_relief --overwrite
r.info shaded_relief
#
# display geographic elements
d.mon wx0
d.rast shaded_relief
d.rast L_2023c_cluster_classes
d.rast L_2023a_cluster_classes
d.rast L_2023b_cluster_classes
d.legend raster=L_2023b_cluster_classes title="Burundi: LCC" title_fontsize=12 font="Helvetica" fontsize=9 bgcolor=white border_color=white -c
d.vect map=Burundi_border display=shape type=area color=red fill_color=none width=3 attribute_column=NAME_EN
d.vect map=Burundi_cities display=shape type=point color=black fill_color=yellow width=3 attribute_column=NAME font=sans icon=basic/circle size=8

# v.proj - Re-projects a vector map from one location to the current location.
v.clip input=world_countries clip=Burundi_bbox output=Burundi_border --overwrite
#v.colors map=Burundi_LCT use=cat layer=1 rgb_column=LCCCODE color=bcyr
d.mon wx0
d.vect map=Burundi_border display=shape
d.erase
v.info world_countries
v.info Burundi_border
v.info world_cities
g.region vector=world_cities w=-53324 e=345915 n=-203953 s=-596415

v.clip -r input=world_countries output=Burundi_border --overwrite
v.clip -r input=/Users/polinalemenkova/grassdata/Burundi_Landsat/PERMANENT/vector/world_cities output=Burundi_cities
