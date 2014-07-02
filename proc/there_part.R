load('/home/yin/R/air_pollution/proc_data/aqi_all.RData')
index1 = which(air.tables[[1]]$Y > 23.2)
index1 = c(index1, 24, 19)
#air.tables[[1]][index1, 1]
#花都师范   九龙镇镇龙 永和子站   增城环保局 从化环保局 白云嘉禾   帽峰山 新塘镇政府
index2 = which(air.tables[[1]]$Y < 23.09)
index2 = index2[-7]
#air.tables[[1]][index3, 1]
#番禺中学   南沙科学馆 黄阁子站   十八涌     番禺沙湾   大石中学   西区子站
index = 1:29
index3 = index[-c(index1, index2)]

PartMean = function(index=index1, data=air.all) {
   part = data[[index[1]]]$NO2
   for(i in index[-1]) {
     part = rbind(part, data[[i]]$NO2)
    }
    Nmean = function(p) mean(p[which(!is.na(p))])
    apply(part, 2, Nmean)
}


PartPlot = function(ind=list(index1, index2, index3), l.col=2:4, l.lty=1:3) {
  plot(PartMean(), xlim=c(0,30), ylim=c(0,75), xlab='time', ylab='NO2', type='n')
  for(i in 1:3) {
  lines(PartMean(index=ind[[i]]), col=l.col[i], lty=l.lty[i], lwd=2)
  }
  legend('bottomleft', legend = c("北部郊区", "南部郊区", "城区及其周边"),
               col = l.col, lty = l.lty, lwd=2)
}

PartPlot()
for(i in 1:3) {
  lines(PartMean(index=ind[[i]]), col=i+1)
}
