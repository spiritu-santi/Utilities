library(here)
library(tidyverse)
library(magrittr)
library(raster)
wgetCHELSA_extract <- function(file_get="envidatS3paths.txt",extent=c(-110,-90,10,30),carpeta="presente"){ 
  files_to_get <- readLines(here(file_get), n = -1L)
  files_to_get %>% strsplit(.,"CHELSA_") %>% lapply(.,"[",2) %>% unlist() %>% 
    strsplit(.,"_") %>% lapply(.,"[",1) %>% 
    unlist() -> to_get
    for (i in 1:length(to_get)){
      cat("Downloading:",to_get[i],"\n")
      system(paste("wget -nv", files_to_get[i],"-O temporal.tif",sep=" "))
      raster::raster("temporal.tif") -> r1
      cat("------- Cropping:","\n")
      nombre <- paste0(to_get[i],".tif")
      raster::crop(r1,extent) -> rc
      writeRaster(rc,filename = here(carpeta,nombre),format="GTiff")
    }
}