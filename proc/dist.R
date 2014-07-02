####根据经纬度计算两点距离

rad = function(d) {
  d * 3.1416 / 180.0;
}

Distance = function(lon1, lat1, lon2, lat2) {
  R = 6378.137  #km
  radLat1 = rad(lat1);
  radLat2 = rad(lat2);
  
  a = radLat1 - radLat2;
  b = rad(lon1) - rad(lon2);

#  R*acos(sin(MLatA)*sin(MLatB) + cos(MLatA)*cos(MLatB)*cos(MLonA-MLonB))
  s = 2*asin(sqrt(sin(a*0.5)^2 + cos(radLat1)*cos(radLat2)*sin(b*0.5)^2))
  s*R
}

#####
#测试
#Y = (max(lur.df$Y) + min(lur.df$Y))/2
#Y
Distance(113.1, Y, 113.7, Y)
Distance(113, 22.7, 113, 23.46735)

# X = with(lur.df, max(X))
# Y = with(lur.df, max(Y))
# X1 = with(lur.df, min(X))
# Y1 = with(lur.df, min(Y))
#最大误差率
#(Distance(X,0,X1,0)-Distance(X,Y,X1,Y))/Distance(X,Y,X1,Y)