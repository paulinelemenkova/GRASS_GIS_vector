#!/bin/sh

# create new location from raster map (file must contain projection metadata):
# grass -c myraster.tif /home/user/grassdata/mynewlocation
grass
#cd /Users/polinalemenkova/grassdata
#grass -c LC09_L2SP_179073_20220419_20230421_02_T1_SR_B1.tif /Users/polinalemenkova/grassdata/France

# ----IMPORT AND PREPROCESSING-------------------------->
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
