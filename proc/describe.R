#####
path = '/home/yin/R/air_pollution/proc_data/'
paths = paste(path, c('aqi_all.RData', 'aqi_day_mean.RData', 'aqi_mean.RData'), sep='')
for(i in paths) {load(i)}
#require('geoR')
#s100 = as.geodata(cbind(air_index[, 2:3], unlist(average.table[, 2])))

#####
#求某种污染物每天的均值
DayMean = function(index) {
  vec = rep(NA, length(air.tables))
  for(i in 1:length(air.tables)) {
    vec[i] = mean(air.tables[[i]][which(!is.na(air.all[[i]][, index])), index])
  }
  vec
}

#####
#时间序列图
#op = par(mfrow=c(1,2), mar=c(2.3,3,2,1), cex.axis=0.6, mgp=c(1.5, 0.5, 0))
#for(index in c(2, 6)) {
#  plot(ts(DayMean(index + 3), start=c(5, 4), frequency=1), main=names(air.all[[1]])[index], xlab='time', 
#      ylab=expression(paste(mu, "g/", m^3)), lwd=2)
#  for(i in 1:length(air.all)) {points(ts(air.all[[i]][, index], start=c(5, 4), frequency=1), pch=20,
#                                     main=names(air.all[[1]])[index], col=rgb(0, 0, 0, 0.5))}
#}
#par(op)

#####
#箱型图表示 
require('ggplot2') 
BoxData = function(index) {
  vec = c()
  for(i in 1:length(air.all)) {
   numb = length(which(air.all[[i]][, index] > 0)) 
   vec = rbind(vec, cbind(air.all[[i]][which(air.all[[i]][, index] > 0), index], 
                          which(air.all[[i]][, index] > 0), rep(i, numb)))
  }
  vec
}
#####
data.no2 = as.data.frame(BoxData(2)) 
data.pm2_5 = as.data.frame(BoxData(6)) 
names(data.no2) = c('NO2', 'time', 'cite')
names(data.pm2_5) = c('PM2.5', 'time', 'cite')
data.no2 = transform(data.no2, cite=as.factor(cite), time=as.factor(time))
data.pm2_5 = transform(data.pm2_5, cite=as.factor(cite), time=as.factor(time))
save(data.no2, file='/home/yin/R/air_pollution/proc_data/data_no2.RData')
#ggplot(data.so2, aes(time, SO2)) + stat_boxplot() + 
#  stat_summary(aes(colour='mean'), fun.y = mean, geom = "point")
#  geom_smooth(aes(group=sample(1:29, 1)), se=F)
#ggplot(data.no2, aes(cite, NO2)) + stat_boxplot() +  stat_summary(aes(colour='mean'), fun.y = mean, geom = "point")
#print(a)


#day.mean = as.data.frame(cbind(DayMean(5), rep('mean', length(DayMean(5)))))
#day.mean = transform(day.mean, cite=as.factor(cite), SO2=as.numeric(SO2))
#names(day.mean) = c('SO2', 'cite')
#data.df = rbind(data[, -2], day.mean)
#data.df = transform(data.df, cite=as.factor(cite), SO2=as.numeric(SO2))

#qplot(SO2, data = data.so2, geom = "density",  fill=cite, alpha=I(0.2))
##+ geom_density(data=day.mean, size=I(2))  

#####
#data = cbind(data.so2[, 1], data.pm2_5[, 2])
#从化，花都，南沙
#nou = c(13:15, 23, 25)
#####
#NO2历年趋势图
trend = cbind(2000:2012, c(61, 71, 68, 72, 73, 68, 67, 65, 56, 56, 53, 49, 48))
trend = as.data.frame(trend)

names(trend) = c('year', 'NO2')
trend = transform(trend, year=as.factor(year))
#mean(average.table$NO2)
require('ggplot2')
ggplot(aes(x=year, y=NO2, group=1), data=trend) + stat_smooth(se=F, span=0.75) + geom_point()
#plot(trend, type='b', lty=2)
