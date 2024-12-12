#!/bin/bash
# to be executed on host in /appdata/artifacts/

ls -lah *-DL_DIR.tar.gz

if [ -d dl-temp ]; then
   rm -rf dl-temp
fi

mkdir dl-temp

if [ -d dl-temp-all ]; then
   rm -rf dl-temp-all
fi

mkdir dl-temp-all

if [ -f all-DL_DIR.tar.gz ]; then
   rm -f all-DL_DIR.tar.gz
fi

for i in *-DL_DIR.tar.gz;
do 
   echo "+ tar -I pigz -xf $i -C dl-temp/"
   time tar -I pigz -xf "$i" -C "dl-temp/" ;    # Use -C to switch directory before extract and put extension to search for in tar file in quotes.
   echo "+ du -hs dl-temp"
   du -hs dl-temp   
   echo "+ pushd dl-temp"
   pushd dl-temp
   # --> sanitize 
   echo "+ sanitize"
   find . -name "*bad-checksum*" -exec rm -f {} \;
   rm -rf ./git2
   rm -rf ./svn
   find . -name "*.done" -exec rm -f {} \;
   # delete all symlinks
   find . -maxdepth 1 -type l -delete
   find . -maxdepth 1 -size 0 -delete
   rm -rf ./uninative/954182f691bb2dbae157ee991654ad2fd4cb51c7f3d3ab429e9f84654c8dc990
   # <-- sanitize
   echo "+ rsync -avp * ../dl-temp-all/"
   rsync -avp * ../dl-temp-all/
   echo " --> symlinks in dl-temp"
   find . -type l -ls
   echo " <-- symlinks in dl-temp"
   echo " --> dirs in dl-temp"
   find . -type d -ls
   echo " <-- dirs in dl-temp"
   echo "+ popd"
   popd
   echo "+ rm -rf dl-temp"
   rm -rf dl-temp
   echo "+ mkdir dl-temp"
   mkdir dl-temp
   du -hs dl-temp-all
   echo " --> symlinks in ../dl-temp-all/"
   find dl-temp-all/ -type l -ls
   echo " <-- symlinks in ../dl-temp-all/"
   echo " --> dirs in ../dl-temp-all/"
   find dl-temp-all/ -type d -ls
   echo " <-- dirs in ../dl-temp-all/"
done

echo "+ pushd dl-temp-all"
pushd dl-temp-all
echo "+ magic symlink"
for i in gitshallow_*linux-stable.git*_linux*.tar.gz; do j=`echo $i | sed 's/192.168.42.182.8939.robert.berger/git.kernel.org.pub.scm.linux.kernel.git.stable/g'`; ln -sf "$i" "$j"; done
echo "+ tar -I pigz -cf ../all-DL_DIR.tar.gz ."
time tar -I pigz -cf ../all-DL_DIR.tar.gz .
echo "+ popd"
popd
echo "+ ls -lah all-DL_DIR.tar.gz"
ls -lah all-DL_DIR.tar.gz
