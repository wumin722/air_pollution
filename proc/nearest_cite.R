########加载Distance函数
source('/home/yin/R/air_pollution/proc/dist.R')

########读取地铁站点坐标
sub.cite.df = read.table('~/R/air_pollution/proc_data/proc_sub_cite',
  sep='\t', header=T)

########读取监测站点坐标
air.df = read.csv('~/R/air_pollution/data/air_index-5-9')

########计算检测站点与每个地铁站的距离
NearSub = function(n) {
  vec = air.df[n, ]
  sub.cite.num = length(sub.cite.df$X)
  dist = c(rep(NA, sub.cite.num))
  for(i in 1:sub.cite.num) {
    dist[i] = Distance(vec[, 2], vec[, 3],
          sub.cite.df[i, 2], sub.cite.df[i, 3])
  }
  min(dist)
}

########计算每个监测站的nearest subway cite
dist = sapply(1:29, NearSub)
save(dist, file='~/R/air_pollution/proc_data/dist_to_sub.RData')
