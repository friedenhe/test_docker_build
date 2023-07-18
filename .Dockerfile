FROM dafoam/opt-packages:latest

# Swith to dafoamuser
USER dafoamuser

# compile
RUN sed -i 's/source/./g' /home/dafoamuser/dafoam/loadDAFoam.sh && \
    . /home/dafoamuser/dafoam/loadDAFoam.sh && \
    cd $DAFOAM_ROOT_PATH/repos && \
    git clone https://github.com/mdolab/dafoam && \
    cd dafoam && \
    . $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812/etc/bashrc && \
    ./Allmake 2> log.txt && \
    . $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812-ADR/etc/bashrc && \
    ./Allclean && \
    ./Allmake 2> log.txt && \
    . $DAFOAM_ROOT_PATH/OpenFOAM/OpenFOAM-v1812-ADF/etc/bashrc && \
    ./Allclean && \
    ./Allmake 2> log.txt && \
    pip install . && \
    rm -rf $DAFOAM_ROOT_PATH/repos/dafoam && \
    rm -rf /home/dafoamuser/test_file_from_ci
