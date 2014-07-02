####读入osm原始数据
require('ggmap')
require('osmar')
raw = readLines('/home/yin/R/air_pollution/source.osm')
maps = get_map('guangzhou', zoom=10, source='google', maptype='roadmap')

guangzhou  = as_osmar(xmlParse(raw))
save(guangzhou, file='/home/yin/R/air_pollution/proc_data/guangzhou_osmar.RData')
#?get_map 
subway = find(object=guangzhou, way(tags(v == 'subway')))
subway.osm = subset(guangzhou, way_ids=subway)
subway.nodes = subset(guangzhou, node_ids=subway.osm$ways$refs$ref)
subway.df = data.frame(lon=subway.nodes$nodes$attrs$lon, lat=subway.nodes$nodes$attrs$lat)
ggmap(maps) + geom_point(aes(x=lon, y=lat), data=subway.df, alpha=.5)
?ggmap
#length(subway.osm$ways$refs$ref)
#plot(subway.nodes)

get_osm(way(subway[1]), source=guangzhou)
#fivenum(air.tables[[1]]$X)
#fivenum(air.tables[[1]]$Y)
#air.tables[[1]][which(air.tables[[1]]$Y > 23.19), 1]
#air.tables[[1]][which(air.tables[[1]]$X < 113.22), 1]
##a = which(air.tables[[1]]$X > 113.5)
#b = which(air.tables[[1]]$Y < 22.8)
#c = which(air.tables[[1]]$Y > 23.3)
#d = c(a, b, c)
#unique(d)
#summary(cite_info[[1]])$ways[1][[1]][1]
