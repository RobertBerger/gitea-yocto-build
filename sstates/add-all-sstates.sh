#!/bin/bash
# to be executed on host in /appdata/artifacts/

ls -lah *-SSTATE_DIR.tar.gz

if [ -d sstate-temp ]; then
   rm -rf sstate-temp
fi

if [ -f all-SSTATE_DIR.tar.gz ]; then
   rm -f all-SSTATE_DIR.tar.gz
fi

mkdir sstate-temp

for i in *-SSTATE_DIR.tar.gz;
do 
   echo "+ tar -I pigz -xf $i -C sstate-temp/"
   time tar -I pigz -xf "$i" -C "sstate-temp/" ;    # Use -C to switch directory before extract and put extension to search for in tar file in quotes.
   echo "+ du -hs sstate-temp"
   du -hs sstate-temp
done

echo "+ pushd sstate-temp"
pushd sstate-temp
echo "+ tar -I pigz -cf ../all-SSTATE_DIR.tar.gz ."
time tar -I pigz -cf ../all-SSTATE_DIR.tar.gz .
echo "+ popd"
popd
