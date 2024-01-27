#!/bin/sh

# create new location from raster map (file must contain projection metadata):
# grass -c myraster.tif /home/user/grassdata/mynewlocation
grass
#cd /Users/polinalemenkova/grassdata

# ----IMPORT AND PREPROCESSING-------------------------->

# import vector shape files into GRASS GIS
v.in.ogr input=/Users/polinalemenkova/grassdata/Burundi/bdi_gc_adg.shp output=Burundi_LCT
# retreive metadata information from vector map and its topology status:
v.info map=Burundi_LCT
v.info -c Burundi_LCT

# "db.columns" lists all columns for a give table. Connection to databases are supported through dbf, shp, odbc and pg drivers.
# List columns from Shape file with DBF attribute table
db.columns table=bdi_gc_adg driver=dbf database=/Users/polinalemenkova/grassdata/Burundi/
# ID
# GRIDCODE
# LCCCODE
# AREA_M2

# ----------->
# check original map attributes
v.db.select Burundi_LCT column=LCCCODE

v.db.select Burundi_LCT
# look at legend
# full data:
# db.select table=Burundi_LCT
# first 7 rows:
db.select table=Burundi_LCT | head -7
# ----------->
# check column names of vector map attributes
v.info -c Burundi_LCT
# INTEGER|cat
# INTEGER|ID
# INTEGER|GRIDCODE
# CHARACTER|LCCCODE
# DOUBLE PRECISION|AREA_M2

# ----------->
# check column names of legend table
db.describe -c Burundi_LCT
# ncols: 5
# nrows: 11608
# Column 1: cat:INTEGER:20
# Column 2: ID:INTEGER:20
# Column 3: GRIDCODE:INTEGER:20
# Column 4: LCCCODE:CHARACTER:254
# Column 5: AREA_M2:DOUBLE PRECISION:20

# v.colors -c map=Burundi_LCT use=cat column=GRIDCODE layer=1 rgb_column=LCCCODE
v.colors map=Burundi_LCT use=cat layer=1 rgb_column=LCCCODE color=bcyr --overwrite
#v.colors -c map=Burundi_LCT rgb_column=GRIDCODE

# Mapping
g.region vector=Burundi_LCT -p
d.mon wx4
#d.vect map=Burundi_LCT display=shape \
    legend_label="Land cover class" type=area rgb_column=LCCCODE color=turbo --overwrite
d.mon wx4
d.vect map=Burundi_LCT display=shape \
    legend_label="Land cover class" type=area rgb_column=LCCCODE --overwrite
#
d.legend.vect columns=3 -b at=2,40 title="Burundi: LCC" font=Sans \
    symbol_size=26 fontsize=16 title_fontsize=18
    
d.legend raster=lsat8_2015.ndvi range=-1,1 title="NDVI" title_fontsize=14 font=Helvetica fontsize=12 -t -s -b border_color=white thin=12 label_step=0.1 -d

db.select table=/Users/polinalemenkova/grassdata/Burundi/bdi_gc_adg.dbf

db.tables -p

# display=shape
# connect full DBF database to vector map, use "VALUE" as the key column
#v.db.connect map=Burundi_LCT driver=dbf table=bdi_gc_adg.dbf key=value -o

d.out.file output=Burundi_LCC format=jpg --overwrite
#


