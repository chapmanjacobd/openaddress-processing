require(data.table)
require(visdat)
require(caret)
require(stringdist)
require(dplyr)

setwd('~')
setwd('Downloads/kr/')

file_list <- list.files()

for (filen in file_list){

dt = fread(file = filen)

#parti = createDataPartition(dt$LAT,p=0.01,list = F)
#test = dt[parti,]

gc()
#dt=test

# words
pattern = "(0-9\uff10-\uff19|CIRCUIT|COURT|BOULEVARD|ROAD|STREET|DRIVE|SECTOR|REGION|AREA|LANE|VIEW|PARKWAY|LANE|RISE|TERRACE|STATION|SATELLITE|AVENUE|LINK|PLACE|CRESCENT|CIRCLE|HEIGHTS|HILL|GREEN|WALK|WAY|FIELD|SQUARE|JALAN|LORONG|route de|route du|route|résidence de|résidence du|résidence|impasse|lotissement le|lotissement|chemin des|chemin de|chemin du|chemin|rue)"
dt$STREET = gsub(pattern,'',dt$STREET)
# numbers
pattern = "[0-9\uff10-\uff19]"
dt$STREET = gsub(pattern,'',dt$STREET)

dt$STREET = trimws(dt$STREET)
gc()

machi = dt

if (as.integer(count(machi)) != 0) {
    machi<-aggregate(machi[,c('LON','LAT')], 
    list(village = machi$STREET,district = machi$DISTRICT,region = machi$REGION
  ), mean, na.rm = T, na.action = na.pass)
}



#stri_trans_general(machi$machi,'Any-ASCII')
machi$prefecture = filen

#fwrite(machi,file = paste0('machi.',filen))

  if (!exists("dat")){
        dat <- machi
  }
    
  # if the merged dataset does exist, append to it
  if (exists("dat")){
      dat<-bind_rows(dat, machi)
  }

}

fwrite(dat,file = 'kr.csv')
