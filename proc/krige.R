#####
require('geoR')

#####
#将经纬度转化为距离形式，以E0，N0为坐标原点, 经度和维度分别乘以111.3和102.4
#krdata = lur.df
#krdata =transform(krdata, X = X*102.4, Y = Y*111.3)




#####
#正态性检验
#shapiro.test(lur.df[, 4])
#变异函数
#vario60 <- variog(s100, max.dist = 1, direction=pi/3) 

#####
#剔除郊区数据
krdata = as.geodata(lur.df[-c(9,13,14,15,23,25,29), -1])
vario60 = variog(krdata, max.dist = 1, direction=pi/3) 
#####
#plot(variog(krdata, max.dist=1000))
#lines.variomodel(cov.model="exp", cov.pars=c(150, 10), nug=50, max.dist=60)
#lines.variomodel(cov.model="mat", cov.pars=c(150, 20), nug=50, kappa=0.5,max.dist=60, lty=2)
#lines.variomodel(cov.model="sph", cov.pars=c(150,.2), nug=0,max.dist=1, lwd=2)

# kappa=1,fix.nugget = T, nugget = 50,
#####
#模型选择
#ml <- likfit(krdata, ini = c(180,0.2), nugget=50)
CovPlot = function(bin=bin1, dat=krdata, cov=c('exp', 'mat', 'sph'), ini=c(150,0.2), l.col=1:3, ...) {
  plot(variog(dat, max.dist=60))
  fn = list()
  for(i in 1:length(cov)) {
   fn[[i]] <- variofit(bin, cov.model=cov[i],  ini.cov.pars=ini, ...)
   lines(fn[[i]], col = i+1, max.dist = 1)
  }
  fn
}

save(pm.model, file='/home/yin/R/air_pollution/proc_data/pm_model.RData')
#legend(0.2, 100, legend=c('exp', 'mat', 'sph'), col=2:4, lty=1)
#残差平方和#交叉验证
KrigeValid = function(model=no2.model) {
  ma = matrix(NA, 3, 2)
  for(i in 1:length(model)) {
    ma[i, 1] = model[[i]]$value
    va = xvalid(s100, model=model[[i]])
    ma[i, 2] = sum(va$error^2)/length(va$error)
  }
  ma
}
#names(ma) = c('')
#pred = expand.grid(seq(112.8, 114, l=50), seq(22.6, 23.7, l=60))

#kc = krige.conv(krdata, loc = pred.grid, krige = krige.control(obj.m = so2.model[[1]]))
#####
#NO2浓度大于40的概率
set.seed(123)
OC <- output.control(n.pred = 2000, simul = TRUE, thres = 40)
pred.kc <- krige.conv(krdata, loc = pred.grid, krige = krige.control(obj.m = no2.model[[3]]), out=OC)
save(pred.kc, file='/home/yin/R/air_pollution/proc_data/pred_kc_40.RData')
#par(mfrow=c(1,1),mar=c(2.5,3,2,2), mgp=c(1.5, 0.5, 0))
#pred.kc$predict[-inner] = NA
#image(pred.kc, loc = pred.grid, val = 1 - pred.kc$prob, col=gray(seq(1,0.1,l=30)), axes=F,
#      x.leg=c(113.1, 113.7), y.leg=c(22.7, 22.76))
#BoundPlot()
