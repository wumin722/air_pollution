####估计区域
#long1 = 113.19; long2 = 113.445
#lat1 = 23.04; lat2 = 23.208 
#####读取数据
require('osmar')
air_index = read.csv('/home/yin/R/air_pollution/data/air_index-5-9', header=T)

####提取检测站附近osm数据
GetPointInfo = function(long, lat, width=1000, height=1000) {
  box = center_bbox(long, lat, width, height)
  get_osm(box)
}


GetCiteInfo = function(v, width=1000, height=1000) {
  info = list()
  for(i in 1:length(v[,1])) {
    info[[i]] = GetPointInfo(
          v[i, 2], v[i, 3],  width=1000, height=1000)
  }
  info
}

cite_info_1km = GetCiteInfo(air_index)
names(cite_info_1km) = air_index[, 1]
save(cite_info_1km, file='/home/yin/R/air_pollution/proc_data/cite_info_1km.RData')
#load('/home/yin/R/air_pollution/proc_data/cite_info_1km.RData')
####node的数量
NodeNum = function(osm) summary(osm)$nodes[1][[1]][1]
#node_num = sapply(cite_info_1km, function(p) length(p$nodes$attrs$id))
node_num = sapply(cite_info_1km, GridNodeNum)
save(node_num, file='/home/yin/R/air_pollution/proc_data/node_num.RData')
#sort(node_num)

####way的数量
WayNum = function(osm) summary(osm)$ways[1][[1]][1]
way_num = sapply(cite_info, WayNum)
#sort(way_num)

###########
#load('/home/yin/R/air_pollution/proc_data/road_len_1km.RData')
#cor(node_num, way_num)
#get_point_info(air_index[1, 2:3])
#plot(cite_info[[2]], main=air_index[2, 1])
#i = 2
#plot(road.len.1km, average.table[, i], main=names(as.data.frame(average.table)[i]))
#no2.model = lm(unlist(average.table[, 2]) ~ road.len.1km + node_num + way_num)
#summary(no2.model)


