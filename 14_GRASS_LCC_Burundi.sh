#!/bin/sh

# create new location from raster map (file must contain projection metadata):
# grass -c myraster.tif /home/user/grassdata/mynewlocation
grass
#cd /Users/polinalemenkova/grassdata

# ----IMPORT AND PREPROCESSING-------------------------->

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
