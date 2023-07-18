FROM dafoam/opt-packages:latest

# Swith to dafoamuser
USER dafoamuser

# create a new repo directory
RUN source /home/dafoamuser/dafoam/loadDAFoam.sh

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
    rm -rf $DAFOAM_ROOT_PATH/repos/dafoam
