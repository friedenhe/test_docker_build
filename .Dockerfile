FROM dafoam/opt-packages:latest

# Swith to dafoamuser
USER dafoamuser

# Here, we need to load all the variables defined in loadDAFoam.sh
# DAFoam root path
# DAFoam root path
ENV DAFOAM_ROOT_PATH=/home/dafoamuser/dafoam
# Miniconda3
ENV PATH=$DAFOAM_ROOT_PATH/packages/miniconda3/bin:$PATH
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DAFOAM_ROOT_PATH/packages/miniconda3/lib
ENV PYTHONUSERBASE=no-local-libs
# OpenMPI-3.1.6
ENV MPI_INSTALL_DIR=$DAFOAM_ROOT_PATH/packages/openmpi-3.1.6/opt-gfortran
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPI_INSTALL_DIR/lib
ENV PATH=$MPI_INSTALL_DIR/bin:$PATH
# PETSC
ENV PETSC_DIR=$DAFOAM_ROOT_PATH/packages/petsc-3.14.6
ENV PETSC_ARCH=real-opt
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PETSC_DIR/$PETSC_ARCH/lib
ENV PETSC_LIB=$PETSC_DIR/$PETSC_ARCH/lib
# CGNS-4.1.2
ENV CGNS_HOME=$DAFOAM_ROOT_PATH/packages/CGNS-4.1.2/opt-gfortran
ENV PATH=$PATH:$CGNS_HOME/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CGNS_HOME/lib
# Ipopt
ENV IPOPT_DIR=$DAFOAM_ROOT_PATH/packages/Ipopt
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$IPOPT_DIR/lib
# OpenFOAM-v1812
ENV LD_LIBRARY_PATH=$DAFOAM_ROOT_PATH/OpenFOAM/sharedLibs:$LD_LIBRARY_PATH
ENV PATH=$DAFOAM_ROOT_PATH/OpenFOAM/sharedBins:$PATH

# create a new repo directory
RUN mkdir -p $DAFOAM_ROOT_PATH/repos

# Update the DAFoam repo to the latest. We need to compile both the original
# and AD versions of DAFoam libs
RUN cd $DAFOAM_ROOT_PATH/repos && \
    git clone https://github.com/mdolab/dafoam && \
    cd dafoam && \
    source $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812/etc/bashrc && \
    ./Allmake && \
    source $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812-ADR/etc/bashrc && \
    ./Allclean && \
    ./Allmake && \
    source $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812-ADF/etc/bashrc && \
    ./Allclean && \
    ./Allmake && \
    pip install . && \
    rm -rf $DAFOAM_ROOT_PATH/repos/dafoam && \
    rm -rf $HOME/test_file_from_ci
