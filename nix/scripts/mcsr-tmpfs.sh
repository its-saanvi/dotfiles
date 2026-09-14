#!/bin/bash

mkdir /tmp/mc
mkdir /tmp/mc/SeedQueue

# Importing Practice maps
ln -s "/home/saanvi/MCSR/maps/ZBlaze Practice" /tmp/mc/SeedQueue
ln -s "/home/saanvi/MCSR/maps/ZCrafting Practice v2" /tmp/mc/SeedQueue
ln -s "/home/saanvi/MCSR/maps/Z_craftingworld" /tmp/mc/SeedQueue
ln -s "/home/saanvi/MCSR/maps/ZLBP 3.15.0/" /tmp/mc/SeedQueue
ln -s "/home/saanvi/MCSR/maps/ZOW Practice V2/" /tmp/mc/SeedQueue
ln -s "/home/saanvi/MCSR/maps/ZZero Practice v1.2.2" /tmp/mc/SeedQueue

chown saanvi -R /tmp/mc/SeedQueue
