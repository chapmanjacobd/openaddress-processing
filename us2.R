require(data.table)
require(visdat)
require(caret)
require(stringdist)
require(dplyr)

setwd('~')
setwd('Downloads/pfiles/')

file_list <- list.files()

for (filen in file_list){
  
  print(filen)

  dt = fread(file = filen)

if (as.integer(count(dt)) != 0) {
  if (!exists("dat")){
        dat <- dt
  }
    
  # if the merged dataset does exist, append to it
  if (exists("dat")){
      dat<-bind_rows(dat, dt)
      print(filen)
  }
}
}

fwrite(dat,file = 'all.csv')
