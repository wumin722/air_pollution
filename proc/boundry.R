require('fields')
require('geoR')

name = c('tianhe', 'luogang', 'liwan', 'yuexiu', 'huangpu', 'baiyun', 'haizhu', 'panyu')
path = '/home/yin/R/air_pollution/boundry_data/'
docs = paste(path, name, '.tab', sep='')
bound.lst = lapply(docs, read.table)
pred.grid = expand.grid(seq(113.1, 113.7, l=40), seq(22.7, 23.46735, l=48))
#read.table('boundry_data/tianhe.tab')
index = which(bound.lst[[2]][, 2] < 23.1)
#bound.lst[[9]] = bound.lst[[2]][index, ]
bound.lst[[2]] = bound.lst[[2]][-index, ]


#boundry.gz = read.table('boundry_data/guangzhou.tab')
#names(boundry.gz) = c('X', 'Y')


InnerBorder = function(x=seq(113.1, 113.7, l=40), y=seq(22.7, 23.46735, l=48), lst=bound.lst, pred=pred.grid) {
  inner = list()
  for( i in 1:length(lst)) {
  po.pred = polygrid(x, y, lst[[i]])
  inner[[i]] = match(row.names(po.pred), row.names(pred))
  }
  unique(unlist(inner))
}

BoundPlot = function(lst=bound.lst, type=2, colo=rgb(0,0,0,0.7)) {
  for(ind in 1:length(lst)) {
    lines(lst[[ind]], lty=type, col=colo)
    #连接第一个和最后一个点
    la = nrow(lst[[ind]])
    lines(lst[[ind]][c(1, la), ], lty=type, col=colo)
  }
}
