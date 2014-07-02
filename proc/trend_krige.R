krdata = as.geodata(lur.df[, -1])
krdata$covariate = lur.df[, 5:8]
kr.bin <- variog(krdata, max.dist=1, , trend=~dist+road.len.1km)
#plot(kr.bin)

ord.ml <- likfit(krdata, ini=c(250, 0.2), nug=50)

tr.ml <- likfit(krdata, trend=~dist+road.len.1km, ini=c(100, 0.2), nug=50)

coords.ml <- likfit(krdata, trend="1st", ini=c(140, 0.3), nug=60)
MCV = function(data=krdata, model1) {
va = xvalid(krdata, model=model1)
sum(va$error^2)/length(va$error)
}
#MCV(model=coords.ml)
#MCV(model=tr.ml)
kc.df = grid.df[1:1920, ]
KC = krige.control(obj.m=tr.ml,
                   trend.d = ~lur.df$dist+lur.df$road.len.1km,
                   trend.l = ~kc.df$dist+kc.df$road.len.1km)
kc = krige.conv(krdata, loc=kc.df[,1:2], krige=KC)
kc.adj = kc
kc.adj$predict[which(kc.adj$predict > max(lur.df$NO2))] = mean(lur.df$NO2)
image(kc.adj, col=heat.colors(30))
BoundPlot()