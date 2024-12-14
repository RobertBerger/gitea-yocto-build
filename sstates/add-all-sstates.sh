#!/bin/bash
# to be executed on host in /appdata/artifacts/

SOURCE_TARBALLS="*-SSTATE_DIR.tar.gz"
TARGET_TARBALL="all-SSTATE_DIR.tar.gz"

SOURCE_TEMP_DIR="sstate-temp"
TARGET_TEMP_DIR="sstate-temp-all"

ls -lah ${SOURCE_TARBALLS}

if [ -d ${SOURCE_TEMP_DIR} ]; then
   rm -rf ${SOURCE_TEMP_DIR}
fi

mkdir ${SOURCE_TEMP_DIR}

if [ -d ${TARGET_TEMP_DIR} ]; then
   rm -rf ${TARGET_TEMP_DIR}
fi

mkdir ${TARGET_TEMP_DIR}

if [ -f ${TARGET_TARBALL} ]; then
   rm -f ${TARGET_TARBALL}
fi

for i in ${SOURCE_TARBALLS};
do 
   echo "+ tar -I pigz -xf $i -C ${SOURCE_TEMP_DIR}/"
   time tar -I pigz -xf "$i" -C "${SOURCE_TEMP_DIR}/" ;    # Use -C to switch directory before extract and put extension to search for in tar file in quotes.
   echo "+ du -hs ${SOURCE_TEMP_DIR}"
   du -hs ${SOURCE_TEMP_DIR}  
   echo "+ pushd ${SOURCE_TEMP_DIR}"
   pushd ${SOURCE_TEMP_DIR}
   # --> sanitize 
   #echo "+ sanitize"
   #find . -name "*bad-checksum*" -exec rm -f {} \;
   #rm -rf ./git2
   #rm -rf ./svn
   #find . -name "*.done" -exec rm -f {} \;
   # delete all symlinks
   #find . -maxdepth 1 -type l -delete
   #find . -maxdepth 1 -size 0 -delete
   #rm -rf ./uninative/954182f691bb2dbae157ee991654ad2fd4cb51c7f3d3ab429e9f84654c8dc990
   # <-- sanitize
   echo "+ rsync -ap * ../${TARGET_TEMP_DIR}/"
   rsync -ap * ../${TARGET_TEMP_DIR}/
   echo " --> symlinks in ${SOURCE_TEMP_DIR}"
   find . -type l -ls
   echo " <-- symlinks in ${SOURCE_TEMP_DIR}"
   echo " --> dirs in ${SOURCE_TEMP_DIR}"
   find . -type d -ls
   echo " <-- dirs in ${SOURCE_TEMP_DIR}"
   echo "+ popd"
   popd
   echo "+ rm -rf ${SOURCE_TEMP_DIR}"
   rm -rf ${SOURCE_TEMP_DIR}
   echo "+ mkdir ${SOURCE_TEMP_DIR}"
   mkdir ${SOURCE_TEMP_DIR}
   du -hs ${TARGET_TEMP_DIR}
   echo " --> symlinks in ../${TARGET_TEMP_DIR}/"
   find ${TARGET_TEMP_DIR}/ -type l -ls
   echo " <-- symlinks in ../${TARGET_TEMP_DIR}/"
   echo " --> dirs in ../${TARGET_TEMP_DIR}/"
   find ${TARGET_TEMP_DIR}/ -type d -ls
   echo " <-- dirs in ../${TARGET_TEMP_DIR}/"
done

echo "+ pushd ${TARGET_TEMP_DIR}"
pushd ${TARGET_TEMP_DIR}
# --> sanitize
#echo "+ magic symlink"
#for i in gitshallow_*linux-stable.git*_linux*.tar.gz; do j=`echo $i | sed 's/192.168.42.182.8939.robert.berger/git.kernel.org.pub.scm.linux.kernel.git.stable/g'`; ln -sf "$i" "$j"; done
# <-- sanitize
echo "+ tar -I pigz -cf ../${TARGET_TARBALL} ."
time tar -I pigz -cf ../${TARGET_TARBALL} .
echo "+ popd"
popd
echo "+ ls -lah ${TARGET_TARBALL}"
ls -lah ${TARGET_TARBALL}
