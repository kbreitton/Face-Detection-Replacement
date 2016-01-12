MATLAB="/usr/local/MATLAB/R2013a"
Arch=glnxa64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/home/klyde/.matlab/R2013a"
OPTSFILE_NAME="./mexopts.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for spread" > spread_mex.mki
echo "CC=$CC" >> spread_mex.mki
echo "CFLAGS=$CFLAGS" >> spread_mex.mki
echo "CLIBS=$CLIBS" >> spread_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> spread_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> spread_mex.mki
echo "CXX=$CXX" >> spread_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> spread_mex.mki
echo "CXXLIBS=$CXXLIBS" >> spread_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> spread_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> spread_mex.mki
echo "LD=$LD" >> spread_mex.mki
echo "LDFLAGS=$LDFLAGS" >> spread_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> spread_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> spread_mex.mki
echo "Arch=$Arch" >> spread_mex.mki
echo OMPFLAGS= >> spread_mex.mki
echo OMPLINKFLAGS= >> spread_mex.mki
echo "EMC_COMPILER=" >> spread_mex.mki
echo "EMC_CONFIG=optim" >> spread_mex.mki
"/usr/local/MATLAB/R2013a/bin/glnxa64/gmake" -B -f spread_mex.mk
