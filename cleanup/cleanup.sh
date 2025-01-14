#!/bin/bash

# If the a downloaded archive is detected as being corrupted (its hashes do not
# match), it is renamed to something like
# fldigi-4.1.19.tar.gz_bad-checksum_8715e7109d2a674d80b742c97743fe7cb8997166b3c6ddef622c8cd8779d6e7f
# and saved anyway. We can remove these files.
#find ./source_mirror_langdale_prep -name "*bad-checksum*" -exec rm -f {} \;
find . -name "*bad-checksum*" -exec rm -f {} \;

# Repositories are first cloned into the ./downloads/git2/ or ./downloads/svn/
# directories and then compressed into the ./downloads directory. The mirror won't
# need the uncompressed files, so we delete them.
#rm -rf ./source_mirror_langdale_prep/git2
#rm -rf ./source_mirror_langdale_prep/svn
rm -rf ./git2
rm -rf ./svn

# For every downloaded archive, there is a "*.done" file used as a filesystem lock,
# to mark to other local processes that the archive is complete and can be read.
# Mirrors don't use this feature, we can delete the lock files.
#find ./source_mirror_langdale_prep -name "*.done" -exec rm -f {} \;
find . -name "*.done" -exec rm -f {} \;

# delete all symlinks
find . -maxdepth 1 -type l -delete
# delete all files with a size of 0
find . -maxdepth 1 -size 0 -delete
# delete the attempt to download the wrong (hard coded) uninative tarball
rm -rf ./uninative/954182f691bb2dbae157ee991654ad2fd4cb51c7f3d3ab429e9f84654c8dc990

#pushd ./source_mirror_langdale_prep
# this can be done more generic
#ln -sf gitshallow_192.168.42.182.8939.robert.berger.linux-stable.git_ebdb69c-1_linux-6.1.y.tar.gz gitshallow_git.kernel.org.pub.scm.linux.kernel.git.stable.linux-stable.git_ebdb69c-1_linux-6.1.y.tar.gz
#ln -sf gitshallow_192.168.42.182.8939.robert.berger.linux-stable.git_adc2186-1_linux-6.12.y.tar.gz gitshallow_git.kernel.org.pub.scm.linux.kernel.git.stable.linux-stable.git_adc2186-1_linux-6.12.y.tar.gz
#popd
#
# symlink with sed - maybe from the job and not from here?
#
# GITEA_GIT_MIRROR: 192.168.42.182:8939
# sed expression:
# 's/:/./'
# 192.168.42.182:8939 -> 192.168.42.182.8939
#
# symlink with sed:
# 's/192.168.42.182.8939.robert.berger/git.kernel.org.pub.scm.linux.kernel.git.stable/'
# gitshallow_192.168.42.182.8939.robert.berger.linux-stable.git_adc2186-1_linux-6.12.y.tar.gz -> gitshallow_git.kernel.org.pub.scm.linux.kernel.git.stable.linux-stable.git_adc2186-1_linux-6.12.y.tar.gz
#
# hardcoded:
# for i in gitshallow_*linux-stable.git*_linux*.tar.gz; do j=`echo $i | sed 's/192.168.42.182.8939.robert.berger/git.kernel.org.pub.scm.linux.kernel.git.stable/g'`; ln -sf "$i" "$j"; done
# --> sanitize
for i in gitshallow_*linux-stable.git*_linux*.tar.gz; do j=`echo $i | sed 's/192.168.42.182.8939.robert.berger/git.kernel.org.pub.scm.linux.kernel.git.stable/g'`; ln -sf "$i" "$j"; done
# <-- sanitize

