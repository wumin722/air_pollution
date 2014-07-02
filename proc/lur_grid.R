#####
#读取数据
require('osmar')

pred.grid = expand.grid(seq(113.1, 113.7, l=40), seq(22.7, 23.46735, l=48))

#get_osm(, source = osmsource_file("/home/yin/R/air_pollution/source.osm"))

#####
#读取源数据
#src = osmsource_osmosis(file = "/home/yin/R/air_pollution/source.osm")
#osm.source = osmsource_file()
#GetPointInfo(pred.grid[1,1], pred.grid[1,2])

#######
#加载Distance函数
source('/home/yin/R/air_pollution/proc/dist.R')

GetGridInfo = function(v, width=1000, height=1000) {
  info = list()
  for(i in 1:length(v[,1])) {
    info[[i]] = GetPointInfo(
      v[i, 1], v[i, 2],  width=1000, height=1000)
  }
  info
}

grid_info_1km = GetGridInfo(pred.grid)
save(grid_info_1km, file='/home/yin/R/air_pollution/proc_data/grid_info_1km.RData')
load('/home/yin/R/air_pollution/proc_data/grid_info_1km.RData')
#####
#错误测试
GridNode = function(k=1:1000) {
  vec = c()
  for(i in k) {
    vec[i] = NodeNum(grid_info_1km[[i]])
  }
  vec
}
grid.node.num = GridNode()


#####
#取出1到1923的数据
grid_info = list()
for(i in 1:1922) {grid_info[[i]] = grid_info_1km[[i]]}

grid.node.num = sapply(grid_info,  function(p) length(p$nodes$attrs$id))
#grid.node.num[1923:1924] = c(144, 136)
#find(object=grid_info_1km[[1]], way(tags(v == 'subway')))
#####
#计算1km范围内道路的长度
grid.len.1km = 
  sapply(grid_info_1km, DTypeWay)

######
##读取地铁站点坐标
sub.cite.df = read.table('~/R/air_pollution/proc_data/proc_sub_cite',
                         sep='\t', header=T)
#####
#离最近地铁站的距离

GridNearSub = function(n) {
  vec = pred.grid[n, ]
  sub.cite.num = length(sub.cite.df$X)
  dist = c(rep(NA, sub.cite.num))
  for(i in 1:sub.cite.num) {
    dist[i] = Distance(vec[, 1], vec[, 2],
                       sub.cite.df[i, 2], sub.cite.df[i, 3])
  }
  min(dist)
}
grid.dist = sapply(1:1922, GridNearSub)
grid.df = as.data.frame(cbind(pred.grid[1:1922,], grid.dist, grid.len.1km))
grid.df = grid.df[, 1:5]
grid.df$grid.node.num = grid.node.num
names(grid.df) = c('X', 'Y', 'dist', 'road.len.1km', 'node.num')
save(grid.df, file='/home/yin/R/air_pollution/proc_data/grid_df1.RData')
#####
#预测NO2
load('/home/yin/R/air_pollution/proc_data/lur_df.RData')
pred.model = lm(NO2 ~ dist  + road.len.1km, data=lur.df[-c(13, 16), ])

pred.no2 = predict(pred.model, grid.df[, -(1:2)])
image.df = cbind(grid.df[,1:2], pred.no2)
names(image.df) = c('X', 'Y', 'NO2')
#####
par(mfrow=c(1, 1))
x = seq(113.1, 113.7, l=40)
y = seq(22.7, 23.46735, l=48)
#y = seq(22.7, 23.5, l=50)
#mat = array(1:1920, dim=c(48, 40))
inner = InnerBorder()
image.df$NO2[-inner] = NA
my.image = reshape(image.df[1:1920,], idvar='X', timevar='Y', direction='wide')
names(my.image)[-1] = y
row.names(my.image) = x
mat = as.matrix(my.image[, -1])

##
require('fields')
par(mfrow=c(1,1), mar=c(2.5, 2.5, 2, 1), mgp=c(1.5, 0.5, 0), pch=20)
image.plot(x=x, y=y, z=mat, col=gray(seq(1,0.1,l=30)), cex.axis=0.6)
persp(x=x, y=y, z=mat)
df = image.df[which(image.df$NO2 > 55), ]
require('lattice')
boundry = read.table('/home/yin/R/air_pollution/boundry_data/guangzhou.tab')
names(boundry) = c('X', 'Y')
with(image.df, levelplot(NO2~X*Y, df, col.regions=heat.colors(30))) 
points(113.3, 23)
plot(boundry,type='n')
llines(x=boundry$X, y=boundry$Y, col=3)