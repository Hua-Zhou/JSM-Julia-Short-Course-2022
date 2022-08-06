# docker build . -t kose/jsm2022-julia-short-course
# docker run -it -p 8888:8888 kose/jsm2022-julia-short-course
# docker-compose up

# https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile
# ubuntu: v20.04, R: v4.1.3, Julia: v1.7.3, Python: v3.10
FROM jupyter/datascience-notebook:ubuntu-20.04

USER ${NB_UID}

RUN echo "c.MappingKernelManager.cull_idle_timeout = 1800" >> /home/${NB_USER}/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.shutdown_no_activity_timeout = 1800" >> /home/${NB_USER}/.jupyter/jupyter_notebook_config.py

# install nbgitpuller
RUN arch=$(uname -m) && \
    if [ "${arch}" == "aarch64" ]; then \
        # Prevent libmamba from sporadically hanging on arm64 under QEMU
        # <https://github.com/mamba-org/mamba/issues/1611>
        export G_SLICE=always-malloc; \
    fi && \
    mamba install --quiet --yes \
    'nbgitpuller' \
    'r-bench' && \
    mamba clean --all -f -y && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

# Setup julia

USER root
COPY install-packages.jl /opt/julia-${JULIA_VERSION}/
## add some Linux dependencies
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    libpixman-1-0 \
    libpixman-1-dev \
    p7zip-full \
    p7zip-rar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

USER ${NB_UID}
ENV JULIA_DEFAULT_ENV="${JULIA_DEPOT_PATH}/environments/v1.7"

RUN mkdir -p $JULIA_DEFAULT_ENV

COPY Project.toml $JULIA_DEFAULT_ENV

USER root
RUN fix-permissions $JULIA_DEFAULT_ENV /opt/julia-${JULIA_VERSION}
USER ${NB_UID}

# Install and precompile packages
RUN julia --threads 4 /opt/julia-${JULIA_VERSION}/install-packages.jl && \
    rm -rf "${HOME}/.local" && \ 
    fix-permissions "${JULIA_PKGDIR}"

# # create system image with precompiled packages -- DROPPED FOR NOW
# USER root
# COPY sysimage-precompile.jl /opt/julia-${JULIA_VERSION}/
# USER ${NB_UID}
# RUN julia -e 'using PackageCompiler; create_sysimage([:Plots, :PGFPlotsX, :LaTeXStrings, :IJulia, :Pluto]; precompile_statements_file="/opt/julia-1.7.3/sysimage-precompile.jl", sysimage_path="/opt/julia-1.7.3/sys_pluto.so")' && \ 
#     fix-permissions "/opt/julia-1.7.3/"

## Configure jupyter

RUN pip3 install git+https://github.com/fonsp/pluto-on-jupyterlab.git ; \
    rm -rf ~/.cache

RUN jupyter labextension install @jupyterlab/server-proxy && \
    jupyter lab build && \
    jupyter lab clean && \
    rm -rf ~/.cache

# disable download (do we still need it?)
# RUN jupyter labextension disable @jupyterlab/docmanager-extension:download \
#     && jupyter labextension disable @jupyterlab/filebrowser-extension:download
