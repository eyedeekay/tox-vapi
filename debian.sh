#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCELIB="libtoxcore.vapi"
SOURCEDOC=README.md
DEBFOLDER=./tox-vapi
DEBVERSION=$(date +%Y%m%d)"-0.2.8"

cd $DEBFOLDER

git pull cmotc master

DEBFOLDERNAME=$DEBFOLDER-$DEBVERSION

# Create your scripts source dir
cp -R ./ "../$DEBFOLDERNAME"

# Copy your script to the source dir
cd "../$DEBFOLDERNAME"

# Create the packaging skeleton (debian/*)
dh_make -s --indep --createorig 

mkdir -p debian/tmp/usr/share/vala-0.2.8/
#mkdir -p debian/tmp/usr/share/docs

mv "vapi" debian/tmp/usr/share/vala-0.2.8/vapi
# Remove make calls
#grep -v makefile debian/rules > debian/rules.new 
#mv debian/rules.new debian/rules 

# debian/install must contain the list of scripts to install 
# as well as the target directory
echo usr/share/vala-0.2.8/vapi/$SOURCELIB usr/share/vala-0.2.8/vapi > debian/install 
#echo $SOURCEDOC usr/share/doc/hidblock >> debian/install

# Remove the example files
rm debian/*.ex

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc >> ../log

