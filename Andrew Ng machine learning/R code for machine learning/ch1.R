# 吴恩达 《机器学习》
## 第一章 线性回归

path <- "E:/python学习/吴恩达机器学习/machine-learning-ex1/ex1/ex1data1.txt"
data <- read.csv(path, header = F, col.names = c("Population", "Profit"))

library(ggplot2)
ggplot(data,aes(Population,Profit))+geom_point(colour="red")

# 考虑使用梯度下降法来进行回归

# 一个维度下的回归

costfunc1 <- function(data, alpha=0.01, theta = c(0,0),iteration = 500) {
  # 如果把iteration设置为0，就是一个单纯计算的公式
  # 学习率设置为0, 初始值设置为c(2,1)
  n <- nrow(data)
  X <- cbind(rep(1,n), data[,1]) # 设计矩阵

  df <- data.frame(theta0=rep(0,iteration+1),
                   theta1 = rep(0, iteration + 1),
                   cost = rep(0,iteration + 1))

  lapply(1:(iteration+1), FUN = function(i){
    yhat <- X %*% theta   #拟合值
    cost <- sum((yhat - data[,2])^2)/(2*n)
    df[i,] <<- c(theta, cost)
    theta <<- theta - t(X) %*% (yhat-data[,2]) * alpha / n

  })

  return(df)
}

test <- costfunc1(data,alpha = 0.01, theta = c(0,0), iteration = 1000)
tail(test)
plot(test$cost[-1],col="red",type="l")

yfit1 <- cbind(rep(1,nrow(data)),data[,1]) %*% as.numeric(test[1001,1:2])
ggplot(data,aes(Population,Profit))+geom_point(colour="red")+geom_abline(data=yfit1)

## 考虑二元线性回归
path2 <- "E:/python学习/吴恩达机器学习/machine-learning-ex1/ex1/ex1data2.txt"
data2 <- read.csv(path2, header = F)
data2 <- scale(data2, center = TRUE, scale = TRUE)
costfunc2 <- function(data, p, alpha=0.01, theta, iteration = 500) {
  # p表示自变量个数
  # 如果把iteration设置为0，就是一个单纯计算的公式

  n <- nrow(data)
  #theta <- rep(0,p+1)
  X <- as.matrix(cbind(rep(1,n), data[,1:p])) # 设计矩阵

  df <- data.frame(theta0=rep(0,iteration+1),
                   theta1 = rep(0, iteration + 1),
                   theta2 = rep(0, iteration + 1),
                   cost = rep(0,iteration + 1))

  lapply(1:(iteration+1), FUN = function(i){
    yhat <- X %*% theta   #拟合值
    cost <- sum((yhat - data[,p+1])^2)/(2*n)
    df[i,] <<- c(theta, cost)
    theta <<- theta - t(X) %*% (yhat-data[,p+1]) * alpha / n

  })

  return(df)
}


test2 <- costfunc2(data2, p=2, alpha = 0.01, theta = c(0,0,0), iteration = 1000)

##############################################
# 考虑 学习率 alpha的选取问题
##############################################
alphalist <- c(0.01,0.02,0.03)
y <- vapply(alphalist, FUN = function(x){
            costfunc1(data,alpha = x, theta = c(0,0),iteration = 500)$cost[501]
            }
            , FUN.VALUE = numeric(1.0))
plot(alphalist,y,type="l")


#######################################
# 线性回归模型 ############################
#######################################
linearreg <- function(data) {
  data <- as.matrix(data)
  n <- nrow(data)
  p <- ncol(data)
  x <- cbind(rep(1,n),data[,1:p-1])
  y <- data[,p]
  library(MASS)
  coeff <- ginv(t(x)%*%x) %*% t(x) %*% y
  fit <- x %*% coeff
  return(list(coefficients=coeff, fit=fit))
}
