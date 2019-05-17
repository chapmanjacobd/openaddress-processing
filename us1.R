require(data.table)
require(visdat)
require(caret)
require(stringdist)
require(dplyr)
setwd('~')
setwd('Downloads/us/')

file_list <- list.files()

for (filen in file_list){
  
  print(filen)

  dt = fread(file = filen)

  pattern = "(0-9\uff10-\uff19|route de|route du|route|résidence de|résidence du|résidence|impasse|lotissement le|lotissement|chemin des|chemin de|chemin du|chemin|rue|- /|-|HWY|HIGHWAY|- &|PL|BLK|PIKE|HARB|HARBOR|TRAIL|,|[.])"
  dt$STREET = gsub(pattern,'',dt$STREET)
  dt$CITY = gsub(pattern,'',dt$CITY)
  
  dt <- dt[,c("LON","LAT","STREET","CITY")]
  
  # numbers
  pattern = "[0-9\uff10-\uff19]"
  dt$STREET = gsub(pattern,'',dt$STREET)
  dt$CITY = gsub(pattern,'',dt$CITY)
  
  dt$STREET = gsub('  ',' ',dt$STREET)
  dt$STREET = gsub('  ',' ',dt$STREET)
  dt$STREET = gsub('  ',' ',dt$STREET)
  dt$STREET = trimws(dt$STREET)
  dt$CITY = gsub('  ',' ',dt$CITY)
  dt$CITY = gsub('  ',' ',dt$CITY)
  dt$CITY = gsub('  ',' ',dt$CITY)
  dt$CITY = trimws(dt$CITY)
  gc()
  
  dat = NULL
  
  dat<-aggregate(dt[,c('LON','LAT')], 
    list(village = dt$STREET,city = dt$CITY
  ), mean, na.rm = T, na.action = na.pass)
  
  if (as.integer(count(dat)) == 0) {
  dat<-aggregate(dt[,c('LON','LAT')], 
    list(village = dt$STREET
  ), mean, na.rm = T, na.action = na.pass)
  }
  
  dat$city = dat$village
  
  pattern = "(0-9\uff10-\uff19|CIRCUIT|COURT|BOULEVARD|ROAD|STREET|DRIVE|SECTOR|REGION|AREA|LANE|VIEW|PARKWAY|LANE|RISE|TERRACE|STATION|SATELLITE|AVENUE|LINK|PLACE|CRESCENT|CIRCLE|HEIGHTS|HILL|GREEN|WALK|WAY|FIELD|SQUARE|JALAN|LORONG|route de|route du|route|résidence de|résidence du|résidence|impasse|lotissement le|lotissement|chemin des|chemin de|chemin du|chemin|rue|[-] [/]|[-]|RD|AVE|LN|CT|ST|BLVD|DR|HWY|HIGHWAY|[-] [&]|PL|BLK|CR|PIKE|HARB|HARBOR|TRAIL|SQ|CIR)"
  dat$village = gsub(pattern,'',dat$village)
  
  fwrite(dat,file = paste0('p.',filen))

}
