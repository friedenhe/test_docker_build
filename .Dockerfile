FROM dafoam/opt-packages:latest

# Swith to dafoamuser
USER dafoamuser

# Here, we need to load all the variables defined in loadDAFoam.sh
RUN . /home/dafoamuser/dafoam/loadDAFoam.sh; exit 0

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
