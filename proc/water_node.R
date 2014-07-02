grid.node.num = sapply(grid_info,  function(p) length(p$nodes$attrs$id))

#####
#不包含waterway的node数量
GridNodeNum = function(p) {
  water.sum = c(0)
  sum =  length(p$nodes$attrs$id)
  waterway.id = p$ways$tags$id[which(p$ways$tags$k == 'waterway' | p$ways$tags$k == 'ship' | p$ways$tags$k == 'boat')]
  WaterNode = function(id) {
   node = list()
  for(i in 1:length(id)) {
    node[[i]] = p$ways$refs$ref[which(p$ways$refs$id == id[i])]
  }
  length(unique(unlist(node)))
  }
 ifelse(length(waterway.id) > 0,  sum-WaterNode(id=waterway.id), sum)
    #water.node = length(which(p$ways$refs$id == waterway.id[i])) + water.num
}
a = c(p$ways$refs$ref[which(p$ways$refs$id == waterway.id[1])], p$ways$refs$ref[which(p$ways$refs$id == waterway.id[2])])
length(unique(a))
GridNodeNum(grid_info[[1]])
grid.node.num1 = sapply(grid_info,  GridNodeNum)

grid.df = transform(grid.df, node.num=grid.node.num1)
head(cbind(grid.node.num, grid.node.num1))
which(grid_info[[940]]$ways$tags$k == 'ship' | grid_info[[940]]$ways$tags$k == 'boat')
grid_info[[940]]$ways$tags
names(pred.grid) = c('X', 'Y')
with(pred.grid, which(X>113.3 & X<113.5 & Y>23 & Y<23.12))
pred.grid[940,]