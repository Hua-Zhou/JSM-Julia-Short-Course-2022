# docker build . -t huazhou/lange_symposium_workshop_2022
# docker run -it -p 8888:8888 -v /Users/huazhou/Documents/Box\ Sync/MIMIC/mimic-iv-1.0:/srv/mimic-iv huazhou/lange_symposium_workshop_2022
# docker-compose up

# https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile
# ubuntu: v20.04, R: v4.1.3, Julia: v1.7.3, Python: v3.10
FROM jupyter/datascience-notebook:ubuntu-20.04

USER ${NB_UID}

# install nbgitpuller
RUN arch=$(uname -m) && \
    if [ "${arch}" == "aarch64" ]; then \
        # Prevent libmamba from sporadically hanging on arm64 under QEMU
        # <https://github.com/mamba-org/mamba/issues/1611>
        export G_SLICE=always-malloc; \
    fi && \
    mamba install --quiet --yes \
    'nbgitpuller' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# add extra R packages
RUN arch=$(uname -m) && \
    if [ "${arch}" == "aarch64" ]; then \
        # Prevent libmamba from sporadically hanging on arm64 under QEMU
        # <https://github.com/mamba-org/mamba/issues/1611>
        export G_SLICE=always-malloc; \
    fi && \
    mamba install --quiet --yes \
    'r-base64enc' \
    'r-bigrquery' \
    'r-data.table' \
    'r-DBI' \
    'r-dbplyr' \
    'r-extrafont' \
    'r-ggfortify' \
    'r-gghighlight' \
    'r-ggrepel' \
    'r-ggthemes' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# add extra Julia packages
RUN julia -e 'import Pkg; Pkg.update()' && \
    julia -e 'import Pkg; Pkg.add([ \
      "AlgebraOfGraphics", \
      "BenchmarkTools", \
      "BGEN", \
      "CairoMakie", \
      "CodecBzip2", \
      "CodecZlib", \
      "CSV", \
      "DataFrames", \
      "DataDeps", \
      "Dates", \
      "DelimitedFiles", \
      "Distributions", \
      "FileIO", \
      "GLM", \
      "GeneticsMakie", \
      "Glob", \
      "GraphRecipes", \
      "LaTeXStrings", \
      "LinearAlgebra", \
      "LoopVectorization", \
      "Makie", \
      "PGENFiles", \
      "Pipe", \
      "Pluto", \
      "PrettyTables", \
      "PyCall", \
      "PyPlot", \
      "QuartzImageIO", \
      "RCall", \
      "Random", \
      "Revise", \
      "SnpArrays", \
      "SpecialFunctions", \
      "StableRNGs", \
      "Statistics", \
      "StatsBase", \
      "StatsModels", \
      "TranscodingStreams", \
      "UnicodePlots", \
      "VariantCallFormat", \
      "VCFTools" \
      ])' && \
    julia -e 'import Pkg; Pkg.precompile()' && \
    rm -rf "${HOME}/.local" && \
    fix-permissions "${JULIA_PKGDIR}"

## Disable download
RUN jupyter labextension disable @jupyterlab/docmanager-extension:download \
    && jupyter labextension disable @jupyterlab/filebrowser-extension:download

User root

## add somme Linux commands
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    tree && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
    
## add Plink2
RUN wget https://s3.amazonaws.com/plink2-assets/alpha3/plink2_linux_x86_64_20220603.zip \
        && unzip plink2_linux_x86_64_20220603.zip \
        && cp plink2 /usr/local/bin \
        && chmod ugo+x /usr/local/bin/plink2

