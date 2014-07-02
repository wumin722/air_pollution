#####
require('animation')

OlsCv = function(k, df) {
  index = 1:length(df[, 1])
  num = kfcv(k, length(index))
  sa = sample(index, length(index))
  
#  model = lm(NO2 ~ dist + elevation + node.num, data=df)
  j = 1
  er.sum = 0
  for(i in 1:k) {
    ind = sa[j:(num[i] + j - 1)]
    model = lm(NO2 ~ dist + elevation + road.len.1km, data=df[-ind, ])
    j = j + num[i]
    pred = predict(model, df[ind, ])
    sum = 0
    for(i in 1:length(pred)) {sum = sum + (df$NO2[ind[i]]-pred[i])^2}
    er.sum = er.sum + sum
  }
  er.sum/length(df[, 1])
}