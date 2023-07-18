FROM dafoam/opt-packages:latest

USER dafoamuser

RUN mkdir -p $HOME/test_file_from_ci
