# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:latest

## system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# copy necessary files
## app folder
COPY . ./app
RUN cp -r ./app/input .
# renv.lock file
COPY renv.lock ./renv.lock


# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::consent(provided = TRUE)'
RUN Rscript -e 'renv::restore()'


#docker hub########################################################################
#EXPOSE 3838
#CMD ["R", "-e", "rmarkdown::run('./app/Variable_Selection.Rmd', shiny_args=list(host = '0.0.0.0', port = 3838))"]
#\dockerhub########################################################################

####horeku#########################################################################################               
RUN rm -rf /var/lib/apt/lists/*              
RUN useradd shiny_user
USER shiny_user
CMD ["R", "-e", "rmarkdown::run('./app/Variable_Selection.Rmd', shiny_args=list(host = '0.0.0.0', port = as.numeric(Sys.getenv('PORT'))))"]
####\horeku########################################################################################                 