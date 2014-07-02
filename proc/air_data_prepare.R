#####
##读取数据
#获取文件名
path = '/home/yin/R/air_pollution/data/'
air.docs = dir(path)

#获得文件路径，读取数据
docs.path = paste(path, air.docs, sep='')
air.tables = lapply(docs.path, read.csv)
names(air.tables) = air.docs

#####
##数据预处理，将值为-1的转为NA

for(i in 1:length(air.tables)) {
  for(j in 2:length(air.tables[[i]])) {
    air.tables[[i]][, j] = sapply(air.tables[[i]][, j], function(p) ifelse(p > 0, p, NA))
  }
}

#####
#转成时间序列形式
#获取文件名中的时间
FileTime = function(name) {
  time = strsplit(name, '-')[[1]][2:3]
  time = as.numeric(time)
  if(time[2] < 10) {
    time[3] = time[2]
    time[2] = 0
  }
  paste(time, collapse='')
}

#排序函数
OrderDate = function(name) {
  index = sapply(air.docs, FileTime)
  order(index)
}

#汇总一个站点的全部空气质量数据
GetTimeForm = function(cite.num) {
  vec = c()
  for(i in OrderDate(air.docs)) {
    vec = rbind(vec, air.tables[[i]][cite.num, 4:10])
  }
  as.data.frame(vec)
}

#所有站点的时间序列形式存入一个list
air.all = lapply(1:29, GetTimeForm)
save(air.all, file='/home/yin/R/air_pollution/proc_data/aqi_all.RData')

#######
#求各个指标时间维度上的平均数

GetCiteMean = function(index) {
  vec = rep(NA, length(air.all))
  for(i in 1:length(air.all)) {
    vec[i] = mean(air.all[[i]][which(!is.na(air.all[[i]][, index])), index])
  }
  vec
}


AverTable = function() {
  df = c()
  average.lst = lapply(1:7, GetCiteMean)
  for(i in 1:length(average.lst)) {
    df = cbind(df, average.lst[[i]])  
  }
  df
}

average.table = as.data.frame(AverTable())
names(average.table) = c(names(air.all[[1]]))

#####
#保存数据
save(average.table, file='/home/yin/R/air_pollution/proc_data/aqi_mean.RData')
save(air.tables, file='/home/yin/R/air_pollution/proc_data/aqi_day_mean.RData')

