#!/bin/bash

path="src/Lib/Resources/Base.elm"
match="allTexture ="
list=""
for ((i=0;i<50;i++)) do
	index=$(printf "%03d" $i)
	list+=", (\"planet_$index\", getResourcePath \"img/tile_$index.png\")\n"

done
sed -i "/$match/a $list" $path