FROM dafoam/opt-packages:latest

# Swith to dafoamuser
USER dafoamuser

# Here, we need to load all the variables defined in loadDAFoam.sh
ENV DAFOAM_ROOT_PATH=/home/dafoamuser/dafoam \
    PATH=$DAFOAM_ROOT_PATH/packages/miniconda3/bin:$PATH \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$DAFOAM_ROOT_PATH/packages/miniconda3/lib \
    PYTHONUSERBASE=no-local-libs \
    MPI_INSTALL_DIR=$DAFOAM_ROOT_PATH/packages/openmpi-3.1.6/opt-gfortran \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MPI_INSTALL_DIR/lib \
    PATH=$MPI_INSTALL_DIR/bin:$PATH \
    PETSC_DIR=$DAFOAM_ROOT_PATH/packages/petsc-3.14.6 \
    PETSC_ARCH=real-opt \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PETSC_DIR/$PETSC_ARCH/lib \
    PETSC_LIB=$PETSC_DIR/$PETSC_ARCH/lib \
    CGNS_HOME=$DAFOAM_ROOT_PATH/packages/CGNS-4.1.2/opt-gfortran \
    PATH=$PATH:$CGNS_HOME/bin \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CGNS_HOME/lib \
    IPOPT_DIR=$DAFOAM_ROOT_PATH/packages/Ipopt \
    LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$IPOPT_DIR/lib \
    LD_LIBRARY_PATH=$DAFOAM_ROOT_PATH/OpenFOAM/sharedLibs:$LD_LIBRARY_PATH \
    PATH=$DAFOAM_ROOT_PATH/OpenFOAM/sharedBins:$PATH

# Update the DAFoam repo to the latest. We need to compile both the original
# and AD versions of DAFoam libs
RUN cd $DAFOAM_ROOT_PATH/repos && \
    git clone https://github.com/mdolab/dafoam && \
    cd dafoam && \
    . $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812/etc/bashrc && \
    ./Allmake && \
    . $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812-ADR/etc/bashrc && \
    ./Allclean && \
    ./Allmake && \
    . $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812-ADF/etc/bashrc && \
    ./Allclean && \
    ./Allmake && \
    pip install . && \
    rm -rf $DAFOAM_ROOT_PATH/repos/dafoam && \
    rm -rf /home/dafoamuser/test_file_from_ci
