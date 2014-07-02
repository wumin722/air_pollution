#lur.df$dist = dist
#lur.df$node.num = node_num
#row.names(lur.df) = lur.df$Name
#lur.df$node.num[13] = 0
#lur.df = transform(lur.df, NO2=average.table[, 2])
#save(lur.df, file='/home/wumin/R/air_pollution/proc_data/lur_df.RData')
#####
#加载数据
load('/home/wumin/R/air_pollution/proc_data/dist_to_sub.RData')
load('/home/wumin/R/air_pollution/proc_data/node_num.RData')
load('/home/wumin/R/air_pollution/proc_data/road_len_1km.RData')
load('/home/wumin/R/air_pollution/proc_data/lur_df.RData')
#form data.frame
elevation.df = read.csv('/home/wumin/R/air_pollution/elevation', header=T)
lur.df = as.data.frame(cbind(air_index[, 1:3], average.table[, 2]))
lur.df = transform(lur.df, dist=dist, node.num=node_num, 
                   road.len.1km=road.len.1km, elevation=elevation.df$AQI.ELE)
names(lur.df)[4] = 'NO2'
save(lur.df, file='/home/wumin/R/air_pollution/proc_data/lur_df.RData')

require('xtable')
#查看相关系数
cor.table = cor(lur.df[-c(13, 16), c(4,5,7,8,9)])
with(lur.df, plot(elevation, NO2))
model = lm(NO2 ~ elevation +  dist  + road.len.1km + node.num, data=lur.df)
plot(model)
pred.model = lm(NO2 ~ dist  + node.num, data=lur.df[-c(13, 16), ])
#summary(model)
#road.len.1km
op = par(mfrow=c(2, 2), mar=c(2.5, 2.5, 2, 1), mgp=c(1.5, 0.5, 0))
plot(model)
#par(op)
