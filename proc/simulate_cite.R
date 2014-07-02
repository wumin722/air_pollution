#####
#加载需要的数据和包
load('/home/yin/R/air_pollution/proc_data/lur_df.RData')
load('/home/yin/R/air_pollution/proc_data/aqi_mean.RData')
load('/home/yin/R/air_pollution/proc_data/grid_df.RData')

source('/home/yin/R/air_pollution/proc/boundry.R')
source('/home/yin/R/air_pollution/proc/krige.R')
source('/home/yin/R/air_pollution/proc/describe.R')

require('geoR')
require('grid')
require('ggplot2')
#####
#拥有数据的点，估计它们的NO2
pred.model = lm(NO2 ~ dist  + road.len.1km, data=lur.df[-c(13, 16), ])

pred.no2 = predict(pred.model, grid.df[-(1921:1922), -(1:2)])
image.df = cbind(grid.df[-(1921:1922), 1:2], pred.no2)
names(image.df) = c('X', 'Y', 'NO2')

#####
#缩小抽样范围
LimitCite = function() {
  df = with(image.df, image.df[which(X > 113.1 & X < 113.6), ])
  with(df, df[which(Y > 22.8 & Y < 23.4), ])
}

sim.df = LimitCite()

#####
#均匀抽样，获得模拟站点
#GetSimCite = function(n=50, sim.df=image.df) {
#  seq(sample(1:floor(1920/n), 1), 1920, floor(1920/n))
#}

KrigeCV = function(k, df, cov='exp', ini=c(200, 0.4)) {
  index = 1:nrow(df)
  num = kfcv(k, length(index))
  sa = sample(index, length(index))
  j = 1
  er.sum = 0
  predict = rep(NA, length(df[, 1]))
  for(i in 1:k) {
    ind = sa[j:(num[i] + j - 1)]
    data=as.geodata(df[-ind, ])
    bin1 = variog(data, uvec = seq(0,1,l=30))
    model = variofit(bin1, cov.model=cov, ini.cov.pars=ini, weights="equal") 
    kc = krige.conv(data, loc = df[ind, 1:2], krige = krige.control(obj.m = model))
    j = j + num[i]
    predict[ind] = kc$predict
  }
  predict
}
#a = KrigeCV(k=2, df=df)


CiteSimulate = function(n=50, k=1, sim=sim.df, actual.df=lur.df[, 2:4], ini=c(200, 0.4), cov='exp', onlyActual=F) {
  #k为每一份样本的数量，当k=1时，即为leave-one-out
  
  sim.cite =  sim[sample(1:1152, size=n), ]
  df = rbind(actual.df, sim.cite)
  fold = floor(nrow(df)/k)
  actdata = as.geodata(actual.df)
  krdata = as.geodata(df)
  
  bin2 = variog(krdata, uvec = seq(0,1,l=30))
  model = variofit(bin2, cov.model=cov, ini.cov.pars=ini, weights="equal") 
  va = xvalid(krdata, model=model)
#  va = KrigeCV(k=fold, df=df, cov=cov, ini=ini)
#  va = xvalid(, df=df, cov=cov, ini=ini)
  er.var = (va$error)^2
  if(onlyActual) er.var = er.var[1:29]
  sum(er.var)/length(er.var)
}

CiteXvalid = function()
set.seed(123)
#cv值包括模拟站点
sim.cv = sapply(1:40, function(p) CiteSimulate(n=p, k=1))
save(sim.cv, file='/home/yin/R/air_pollution/proc_data/sim_cv.RData')
#不包括模拟站点
actu.cv = sapply(1:40, function(p) CiteSimulate(n=p, onlyActual=T))
save(actu.cv, file='/home/yin/R/air_pollution/proc_data/actu_cv.RData')
#####
#验证KrigeCV函数
#求剔除df第一个值的预测值
data=as.geodata(df[-1, ])
bin1 = variog(data, uvec = seq(0,1,l=30))
model1 = variofit(bin1, cov.model=cov, ini.cov.pars=ini, weights="equal") 
kc = krige.conv(data, loc = df[1, 1:2], krige = krige.control(obj.m = model1))
kc$predict
a = KrigeCV(k=79, df=df)
#xvalid
krdata = as.geodata(df)
bin2 = variog(krdata, uvec = seq(0,1,l=30))
model = variofit(bin2, cov.model=cov, ini.cov.pars=ini, weights="equal") 
va = xvalid(krdata, model=model)


cbind(a, va$predict)
a[1]   
