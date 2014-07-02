########更新数据
path = '/home/yin/R/air_pollution/proc/'
fname = c('air_data_prepare.R', 'esti_road_length.R')
fname = paste(path, fname, sep='')
for(i in 1:length(fname)) {
  source(file=fname[i], echo=F)
}


