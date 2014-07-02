####读入检测点1km范围内的osm数据
require('osmar')
load('/home/yin/R/air_pollution/proc_data/cite_info.RData')

####加载Distance函数
source('/home/yin/R/air_pollution/proc/dist.R')


####查询构成way的点
NodesOfWay = function(src, way_id) {
  way.osm = subset(src, way_ids=way_id)
  way.nodes = subset(src,
    node_ids=way.osm$ways$refs$ref)
 data.frame(lon=way.nodes$nodes$attrs$lon,
             lat=way.nodes$nodes$attrs$lat)
}

####计算路的长度
DistOfWay = function(src, way_id) {
  total = 0
  df = NodesOfWay(src, way_id)
  if(length(df[,1])-1 > 1) {
    for(i in 1:(length(df[,1])-1)) {
      total = total + Distance(df[i, 1],
        df[i, 2], df[i+1, 1], df[i+1, 2])
    }
}
  else {
    warning('have not enough nodes')
    total = 0
  }
  total
}      
              
####求一个区域某种类型路的总长度  
DTypeWay = function(src, cond='highway') {
  ways = find(object=src, way(tags(k == cond)))
  sum(sapply(ways, function(p) DistOfWay(src=src, p)))
}

####计算个观测点1KM范围内的道路长度
road.len.1km = rep(NA, 29)
road.len.1km = sapply(cite_info, DTypeWay)
save(road.len.1km, file='/home/yin/R/air_pollution/proc_data/road_len_1km.RData')

#find(object=cite_info[[1]], way(tags(k == 'highway')))
