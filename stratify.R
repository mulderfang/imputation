install.packages("stratifyR")
library(stratifyR)
library(tidyverse)
library(sampling)

#cut data
load("y100.rda")
load("y105.rda")

y100_5611 = y100[which(y100$IND == 5611),]
y105_5611 = y105[which(y105$IND == 5611),]

y100_8620 = y100[which(y100$IND == 8620),]
y105_8620 = y105[which(y105$IND == 8620),]

y100_5611_tax <- y100_5611 %>% filter(TAX == 1) 
y100_5611_notax <- y100_5611 %>% filter(TAX == 2) 
y105_5611_tax <- y105_5611 %>% filter(TAX == 1) 
y105_5611_notax <- y105_5611 %>% filter(TAX == 2) 


y100_8620_tax <- y100_8620 %>% filter(TAX == 1) 
y100_8620_notax <- y100_8620 %>% filter(TAX == 2)
y105_8620_tax <- y105_8620 %>% filter(TAX == 1) 
y105_8620_notax <- y105_8620 %>% filter(TAX == 2)

#-----------------------
# y 100 year
y100_8620_notax_1 <- strata.data(y100_8620_notax$EMP, h = 4 , n=400 )
y100_8620_notax_2 <- strata.data(y100_8620_notax$ASSET, h = 3 , n=400 )
y100_8620_notax_3 <- strata.data(y100_8620_notax$REV, h = 4 , n=400 )

y100_8620_notax_1 <- strata.data(y100_8620_notax$ASSET, h = 5 , n=200 )

hist(y100_8620_notax$ASSET)

ggplot(data = y100_5611_notax)+
geom_histogram(aes(x = EMP, y = ..density..), colour = "black", fill = "white" , bins = 50) 



# The program is running, it'll take some time!
# h = 4, Error in if (my_env$minkf2[k, col + 1] == -9999)  : argument is of length zero
summary(y100_8620_notax_1)
y100_8620_notax$stratanames <- ifelse(y100_8620_notax$EMP <=y100_8620_notax_1$OSB[1], "a" , y100_8620_notax$EMP)

y100_8620_notax$stratanames <- ifelse(y100_8620_notax$EMP <=y100_8620_notax_1$OSB[1], "a" , y100_8620_notax$stratanames)
y100_8620_notax$stratanames <- ifelse(y100_8620_notax$EMP >y100_8620_notax_1$OSB[1] & 
                                         y100_8620_notax$EMP <=y100_8620_notax_1$OSB[2], "b",y100_8620_notax$stratanames)
y100_8620_notax$stratanames <- ifelse(y100_8620_notax$EMP >y100_8620_notax_1$OSB[2] & 
                                         y100_8620_notax$EMP <=y100_8620_notax_1$OSB[3], "c",y100_8620_notax$stratanames)
y100_8620_notax$stratanames <- ifelse(y100_8620_notax$EMP >y100_8620_notax_1$OSB[3] , "d",y100_8620_notax$stratanames)
table(y100_8620_notax$stratanames)
#Optimum Strata Boundaries (OBS)


y100_8620_notax = y100_8620_notax[order(y100_8620_notax$stratanames),]

y100_8620_strata <- strata(y100_8620_notax ,
                           stratanames = c("stratanames") ,
                           size = y100_8620_notax_1$nh , method="srswor" )

y100_8620 <- y100_8620_notax[y100_8620_strata$ID_unit,]

#----------------------------
# y 105 year
y105_8620_notax_1 <- strata.data(y105_8620_notax$ASSET, h = 3 , n=400 )



y105_8620_notax_1 <- strata.data(y105_8620_notax$EMP, h =  , n=200 )


# The program is running, it'll take some time!
# h = 4, Error in if (my_env$minkf2[k, col + 1] == -9999) { : argument is of length zero
summary(y105_8620_notax_1)
y105_8620_notax$stratanames <- ifelse(y105_8620_notax$EMP <=y105_8620_notax_1$OSB[1], "a" , y105_8620_notax$EMP)

y105_8620_notax$stratanames <- ifelse(y105_8620_notax$EMP <=y105_8620_notax_1$OSB[1], "a" , y105_8620_notax$stratanames)
y105_8620_notax$stratanames <- ifelse(y105_8620_notax$EMP >y105_8620_notax_1$OSB[1] & 
                                        y105_8620_notax$EMP <=y105_8620_notax_1$OSB[2], "b",y105_8620_notax$stratanames)
y105_8620_notax$stratanames <- ifelse(y105_8620_notax$EMP >y105_8620_notax_1$OSB[2] & 
                                        y105_8620_notax$EMP <=y105_8620_notax_1$OSB[3], "c",y105_8620_notax$stratanames)
y105_8620_notax$stratanames <- ifelse(y105_8620_notax$EMP >y105_8620_notax_1$OSB[3] , "d",y105_8620_notax$stratanames)
table(y105_8620_notax$stratanames)
#Optimum Strata Boundaries (OBS)


y105_8620_notax = y105_8620_notax[order(y105_8620_notax$stratanames),]

y105_8620_strata <- strata(y105_8620_notax ,
                           stratanames = c("stratanames") ,
                           size = y105_8620_notax_1$nh , method="srswor" )

y105_8620 <- y105_8620_notax[y105_8620_strata$ID_unit,]

y100_8620 <- y100_8620[,-ncol(y100_8620)] 
y105_8620 <- y105_8620[,-ncol(y105_8620)] 

save(y100_8620, file = "data/y100_8620.rda")
save(y105_8620, file = "data/y105_8620.rda")

# y100_8620_notax_1$fhTot
# summary(y100_8620_notax_1)
# # 因為前面1-5重複的次數很多，分層超過4就跑不動
# y100_5611_notax_1 <- strata.data(y100_5611_notax$EMP, h = 2 , n=100 )



#---------------------------------------------
options( warn = -1 )
library(openxlsx)

#cut data
load("data/y100.rda")
y100_5611 = y100[which(y100$IND == 5611),]
save(y100_5611, file = "data/y100_5611.rda")

load("data/y105.rda")
y105_5611 = y105[which(y105$IND == 5611),]
save(y105_5611, file = "data/y105_5611.rda")

### scatterplot
load("data/y100_5611.rda")
load("data/y105_5611.rda")

wb = createWorkbook() 
for(y in 1:2){
  if(y == 1){
    year = 100 #
    complete = y100_5611  
    var = c("COST", "REV", "ASSET")
    
    IND = unique(complete$IND)
    
    dir.create("result")
    dir.create(paste0("result/", IND))
    dir.create(paste0("result/", IND, "/png"))
    
    
  }else{
    year = 105 
    complete = y105_5611 
    var = c("COST", "REV", "ASSET", "INVESTAS")
  }
  png(file = paste0("result/", IND, "/png/y", year, "_nor.png"))
  pairs(complete[,c("YEAR", "EMP", "SAL", var)]) # select tricost / trirev 
  dev.off()
  
  addWorksheet(wb, sheetName = paste0("y", year, "_nor"))
  
  sum = sapply(complete[,c("YEAR", "EMP", "SAL", var)], summary)
  writeData(wb, sheet = paste0("y", year, "_nor"), x = sum, startCol = 2, startRow = 2, rowNames = TRUE)
  
  complete[,c("EMP", "SAL", var)] = log1p(complete[,c("EMP", "SAL", var)])  # select tricost / trirev 
  png(file = paste0("result/", IND, "/png/y", year, "_log.png"))
  pairs(complete[,c("YEAR", "EMP", "SAL", var)])  # select tricost / trirev 
  dev.off() 
  
  addWorksheet(wb, sheetName = paste0("y", year, "_log"))
  
  sum = sapply(complete[,c("YEAR", "EMP", "SAL", var)], summary)
  writeData(wb, sheet = paste0("y", year, "_log"), x = sum, startCol = 2, startRow = 2, rowNames = TRUE)
  
}

### delete missing value

for(y in 1:2){
  if(y == 1){
    year = 100 #
    complete = y100_5611  #y100_xxx
    var = c("COST", "REV", "ASSET")
    
    IND = unique(complete$IND)
    
    dir.create("result")
    dir.create(paste0("result/", IND))
    
  }else{
    year = 105 
    complete = y105_5611 #y105_xxx
    var = c("COST", "REV", "ASSET", "INVESTAS")
  }
  missing = which(complete$TAX == 2)
  incomplete = complete[-missing,]
  
  png(file = paste0("result/", IND, "/png/y", year, "_nor_na.png"))
  pairs(incomplete[,c("YEAR", "EMP", "SAL", var)]) # select tricost / trirev 
  dev.off()
  
  addWorksheet(wb, sheetName = paste0("y", year, "_nor_na"))
  
  sum = sapply(incomplete[,c("YEAR", "EMP", "SAL", var)], summary)
  writeData(wb, sheet = paste0("y", year, "_nor_na"), x = sum, startCol = 2, startRow = 2, rowNames = TRUE)
  
  incomplete[,c("EMP", "SAL", var)] = log1p(incomplete[,c("EMP", "SAL", var)])  # select tricost / trirev 
  
  png(file = paste0("result/", IND, "/png/y", year, "_log_na.png"))
  pairs(incomplete[,c("YEAR", "EMP", "SAL", var)])  # select tricost / trirev 
  dev.off() 
  
  addWorksheet(wb, sheetName = paste0("y", year, "_log_na"))
  
  sum = sapply(incomplete[,c("YEAR", "EMP", "SAL", var)], summary)
  writeData(wb, sheet = paste0("y", year, "_log_na"), x = sum, startCol = 2, startRow = 2, rowNames = TRUE)
  
}
saveWorkbook(wb, file = paste0("result/", IND, "/summary.xlsx"), overwrite = TRUE)

rm(list = ls())

# impute
source("func.R", encoding = "UTF-8")

### input dataset
load("data/y100_5611.rda")
load("data/y105_5611.rda")

### set seed
set.seed(999)

for(j in 1:2){
  for(y in 1:2){
    ### basic information for the different year
    if(y == 1){
      complete = y105_5611
      year = 105
      var = c("COST", "REV", "ASSET", "INVESTAS")
    }else{
      complete = y100_5611
      year = 100
      var = c("COST", "REV", "ASSET")
    }
    
    ### take the basic dataset information
    IND = unique(complete$IND)
    
    ### create the folder to store the results
    dir.create("result")
    dir.create(paste0("result/", IND))
    dir.create(paste0("result/", IND, "/", "y", year))
    
    ### combine COMP1, COMP2, COMP3, COMP4 to a variable
    complete = dummy.COMP(complete)
    
    ### make dataset missing by variable TAX
    missing = which(complete$TAX == 2)
    
    ### manual settings
    ### variable detection to delete useless variables
    # "OUTSALE", "TRICOST", "TRIREV"
    complete = complete[, setdiff(names(complete), c("RES", "TRICOST", "TRIREV", "OUTSALE", "ECOYN", "F020300", "TRICOST", 
                                                     "SEQ", "IND", "EMP_L", "SAL_L", "COSTOP", "REVOP", "COMP1", "COMP2", "COMP3", "COMP4", "SH4", "TAX", "IND_M", "IND_S"))]
    
    complete[, c("EMP", "SAL", var)] = log1p(complete[, c("EMP", "SAL", var)])
    incomplete = complete
    incomplete[missing, var] = NA
    
    if(j == 1){
      sel = "varA"
      
      var_all = setdiff(names(complete), var)
      
      complete_2 = complete[,c(var_all, var)]
      incomplete_2 = incomplete[,c(var_all, var)]
    }else if(j == 2 && y == 1){
      sel = "varS"
      
      var_pvalue = c()
      sig = c()
      for(k in 1:length(var)){
        complete_reg = complete[,c(setdiff(names(complete), var), var[[k]])]
        
        if(k == 1){
          full = lm(COST ~ ., data = complete_reg)
          model = step(full, scope = list(upper = full), direction = "both")
          
        }else if(k == 2){
          full = lm(REV ~ ., data = complete_reg)
          model = step(full, scope = list(upper = full), direction = "both")
          
        }else if(k == 3){
          full = lm(ASSET ~ ., data = complete_reg)
          model = step(full, scope = list(upper = full), direction = "both")
          
        }else if(k == 4){
          full = lm(INVESTAS ~ ., data = complete_reg)
          model = step(full, scope = list(upper = full), direction = "both")
          
        }
        ###
        formula = summary(model)$call$formula
        sig = c(sig, strsplit(as.character(formula)[[3]], " + ", fixed = TRUE)[[1]])
        ### take the variables names
        var_pvalue = rbind(var_pvalue, c(as.character(formula)[[3]], summary(model)$r.squared, summary(model)$adj.r.squared))
      }
      rownames(var_pvalue) = var
      write.csv(var_pvalue, file = paste0("result/", IND, "/sig.csv"))
      
      ### select the variables
      var_sig = unique(sig)
      var_sig = intersect(colnames(complete), var_sig)
      complete_2 = complete[, c(var_sig, var)]
      incomplete_2 = incomplete[, c(var_sig, var)]
      
    }else{
      complete_2 = complete[, c(var_sig, var)]
      incomplete_2 = incomplete[, c(var_sig, var)]
    }
    
    ### imputation by every method
    Method = list()
    ### single imputation
    Method$Real = complete_2
    Method$Complete = na.omit(incomplete_2)
    Method$mean = imputeSingle(incomplete = incomplete_2, var = var, method = "mean")
    Method$median = imputeSingle(incomplete = incomplete_2, var = var, method = "median")
    Method$hotdeck = imputeSingle(incomplete = incomplete_2, var = var, method = "hotdeck")
    Method$knn = imputeSingle(incomplete = incomplete_2, var = var, method = "knn")
    
    ### multiple imputation
    maxit = 10
    
    post = make.post(incomplete_2)
    post[var] = "imp[[j]][, i] <- squeeze(imp[[j]][, i], c(0, 999999999999))"
    
    norm5 = mice(data = incomplete_2, method = "norm", m = 5, maxit = maxit, post = post, visitSequence = "monotone", print = FALSE)
    norm10 = mice(data = incomplete_2, method = "norm", m = 10, maxit = maxit, post = post, visitSequence = "monotone", print = FALSE)
    
    pmm5 = mice(data = incomplete_2, method = "pmm", m = 5, maxit = maxit, visitSequence = "monotone", print = FALSE)
    pmm10 = mice(data = incomplete_2, method = "pmm", m = 10, maxit = maxit, visitSequence = "monotone", print = FALSE)
    
    ### single imputation by take mean from multiple imputation datasets
    Method$norm5_bar = imputeMIbar(imp = norm5, data = incomplete_2, var = var, m = 5)
    Method$norm10_bar = imputeMIbar(imp = norm10, data = incomplete_2, var = var, m = 10)
    Method$pmm5_bar = imputeMIbar(imp = pmm5, data = incomplete_2, var = var, m = 5)
    Method$pmm10_bar = imputeMIbar(imp = pmm10, data = incomplete_2, var = var, m = 10)
    
    ### multiple imputation results
    Method$norm5 = norm5
    Method$norm10 = norm10
    Method$pmm5 = pmm5
    Method$pmm10 = pmm10
    
    ### save impute datasets
    save(Method, file = paste0("result/", IND, "/y", year, "/", sel, ".rda"))
  }
}

rm(list = ls())

# regression
source("func.R", encoding = "UTF-8")

wb = createWorkbook()
for(y in 1:2){
  ### basic information for the different year
  if(y == 1){
    year = 100
  }else{
    year = 105
  }
  
  ### take the basic dataset information
  IND = 5611
  
  ### create the folder to store the results
  dir.create("result")
  dir.create(paste0("result/", IND))
  dir.create(paste0("result/", IND, "/", "y", year))
  ### j == 1 : using all variables to impute, j == 2 using significant variables to impute
  for(j in 1:2){
    if(j == 1){
      sel = "varA"
      
    }else{
      sel = "varS"
      
    }
    load(paste0("result/", IND, "/y", year, "/", sel, ".rda"))
    
    ### calculate regression estimates
    Regression = list()
    for(i in 1:10){
      Regression[[i]] = round(estimate_single(Method[[i]]), digits = 4)
      
    }
    
    for(i in 11:14){
      Regression[[i]] = round(estimate_multiple(Method[[i]]), digits = 4)
      
    }
    names(Regression) = names(Method)
    
    ### detect complete-case has the same variables with others
    if(nrow(Regression$Real) != nrow(Regression$Complete)){
      diff = setdiff(rownames(Regression$Real), rownames(Regression$Complete))
      for(z in 1:length(diff)){
        blank = c(NA, NA, NA, NA, NA)
        Regression$Complete = rbind(Regression$Complete, blank)
        rownames(Regression$Complete)[nrow(Regression$Complete)] = diff[[z]]
      }
      Regression$Complete = Regression$Complete[rownames(Regression$Real),]
    }
    
    ### draw each Regression's confidence interval by variables
    for(v in 1:nrow(Regression[[1]])){
      df = c()
      for(m in 1:length(Regression)){
        df = rbind(df, Regression[[m]][v,])
      }
      ### draw each variable's ci plot by ggplot2
      rownames(df) = names(Regression)
      df$Method = names(Regression)
      actual = df["Real", "estimate"]
      dir.create(paste0("result/", IND, "/", "y", year, "/", sel))
      dir.create(paste0("result/", IND, "/", "y", year, "/", sel, "/reg"))
      
      png(filename = paste0("result/", IND, "/y", year, "/", sel, "/reg/", v, rownames(Regression[[1]])[[v]], "_CI.png"), width = 200, height = 200)
      print(ggplot(df, aes(x = factor(Method, level = names(Regression)), y = estimate)) +
              geom_hline(data = df, aes(yintercept = df["Real", "estimate"]), linetype = "dashed", color = "blue", size = 0.3) +
              geom_point(size = 1.3, color = "red") +
              geom_errorbar(aes(ymax = CI_upper, ymin = CI_lower, width = 0.5)) +
              xlab(rownames(Regression[[1]])[[v]]) + theme_bw() +
              theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
      )
      dev.off()
    }
    
    options(scipen = 999)
    ### add * to present pvalue smaller than 0.05
    for(x in 1:14){
      for(y in 1:nrow(Regression[[x]])){
        if(is.na(Regression[[x]][y,3])){
          next
        }else if(Regression[[x]][y,3] < 0.05){
          Regression[[x]][y,1] = paste0(Regression[[x]][y,1], "*")
        }
      }
    }
    
    
    ### output each method's estimate and SD 
    addWorksheet(wb, sheetName = paste0("y", year, "_", sel))
    
    result1 = c()
    for(v in 1:length(Regression)){
      result1 = cbind(result1, Regression[[v]][,c("estimate", "SD")])
    }
    colnames(result1) = rep(names(Regression), each = 2)
    writeData(wb, sheet = paste0("y", year, "_", sel), x = result1, startCol = 2, startRow = 2, rowNames = TRUE)
    
    
  }
}
saveWorkbook(wb, file = paste0("result/", IND, "/reg.xlsx"), overwrite = TRUE)


rm(list = ls())

# kstest
library(MLmetrics)
library(openxlsx)
options(scipen = 999)

load("data/y100_5611.rda")
load("data/y105_5611.rda")

wb_ksA = createWorkbook()
wb_ksI = createWorkbook()
wb_mse = createWorkbook()

for(y in 1:2){
  ### basic information for the different year
  if(y == 1){
    year = 100
    var = c("COST", "REV", "ASSET")
    complete = y100_5611
    
  }else{
    year = 105
    var = c("COST", "REV", "ASSET", "INVESTAS")
    complete = y105_5611
    
  }
  
  ### take the basic dataset information
  IND = 5611
  missing = which(complete$TAX == 2)
  
  ### create the folder to store the results
  dir.create("result")
  dir.create(paste0("result/", IND))
  ### j == 1 : using all variables to impute, j == 2 using significant variables to impute
  for(j in 1:2){
    if(j == 1){
      sel = "varA"
      
    }else{
      sel = "varS"
      
    }
    ### input result
    load(paste0("result/", IND, "/y", year, "/", sel, ".rda"))
    
    ### add worksheet for ksA / ksI / mse
    addWorksheet(wb_ksA, sheetName = paste0("y", year, "_", sel))
    addWorksheet(wb_ksI, sheetName = paste0("y", year, "_", sel))
    addWorksheet(wb_mse, sheetName = paste0("y", year, "_", sel))
    
    ### KS-test for all
    ks = c()
    for(m in 2:10){
      ks_i = c()
      for(v in 1:length(var)){
        test = ks.test(x = Method[[m]][[var[[v]]]], y = Method$Real[[var[[v]]]])
        
        if(test$p.value > 0.05){
          p = paste0(format(round(test$p.value, digits = 4), nsmall = 4), "^")
        }else{
          p = format(round(test$p.value, digits = 4), nsmall = 4)
        }
        
        ks_i = cbind(ks_i, cbind(round(test$statistic, digits = 4), p))
      }
      ks = rbind(ks, ks_i)
    }
    rownames(ks) = names(Method)[2:10]
    colnames(ks) = rep(c("KS??", "p??"), length(var))
    
    writeData(wb_ksA, sheet = paste0("y", year, "_", sel), x = ks, startCol = 2, startRow = 2, rowNames = TRUE)
    
    ### KS-test for impute data
    ks = c()
    for(m in 3:10){
      ks_i = c()
      for(v in 1:length(var)){
        test = ks.test(x = Method[[m]][missing,var[[v]]], y = Method$Real[missing,var[[v]]])
        
        if(test$p.value > 0.05){
          p = paste0(format(round(test$p.value, digits = 4), nsmall = 4), "^")
        }else{
          p = format(round(test$p.value, digits = 4), nsmall = 4)
        }
        ks_i = cbind(ks_i, cbind(round(test$statistic, digits = 4), p))
      }
      ks = rbind(ks, ks_i)
    }
    rownames(ks) = names(Method)[3:10]
    colnames(ks) = rep(c("KS??", "p??"), length(var))
    
    writeData(wb_ksI, sheet = paste0("y", year, "_", sel), x = ks, startCol = 2, startRow = 2, rowNames = TRUE)
    
    
    ### MSE
    mse = c()
    for(m in 3:10){
      mse_i = c()
      for(v in 1:length(var)){
        test = MSE(y_pred = Method[[m]][[var[[v]]]], y_true = Method$Real[[var[[v]]]])
        mse_i = cbind(mse_i, format(round(test, digits = 4), nsmall = 4))
      }
      mse = rbind(mse, mse_i)
    }
    rownames(mse) = names(Method)[3:10]
    colnames(mse) = var
    
    writeData(wb_mse, sheet = paste0("y", year, "_", sel), x = mse, startCol = 2, startRow = 2, rowNames = TRUE)
    
    
  }
}
saveWorkbook(wb_ksA, file = paste0("result/", IND, "/ksA.xlsx"), overwrite = TRUE)
saveWorkbook(wb_ksI, file = paste0("result/", IND, "/ksI.xlsx"), overwrite = TRUE)
saveWorkbook(wb_mse, file = paste0("result/", IND, "/mse.xlsx"), overwrite = TRUE)

rm(list = ls())

# histogram
library(ggplot2)
load("data/y100_5611.rda")
load("data/y105_5611.rda")

for(y in 1:2){
  ### basic information for the different year
  if(y == 1){
    year = 100
    var = c("COST", "REV", "ASSET")
    complete = y100_5611
    
  }else{
    year = 105
    var = c("COST", "REV", "ASSET", "INVESTAS")
    complete = y105_5611
    
  }
  
  ### take the basic dataset information
  IND = 5611
  
  missing = which(complete$TAX == 2)
  
  ### create the folder to store the results
  dir.create("result")
  dir.create(paste0("result/", IND))
  dir.create(paste0("result/", IND, "/", "y", year))
  ### j == 1 : using all variables to impute, j == 2 using significant variables to impute
  for(j in 1:2){
    if(j == 1){
      sel = "varA"
      
    }else{
      sel = "varS"
      
    }
    ### load result
    load(paste0("result/", IND, "/y", year, "/", sel, ".rda"))
    
    if(year == 100){
      len = 163
    }else{
      len = 153
    }
    
    ### histogram for all data
    for(m in 1:10){
      for(v in 1:length(var)){
        bin = 1
        dir.create(paste0("result/", IND, "/", "y", year, "/", sel))
        dir.create(paste0("result/", IND, "/", "y", year, "/", sel, "/all"))
        
        png(filename = paste0("result/", IND, "/y", year, "/", sel, "/all/", m, names(Method)[[m]], "_", v, ".png"),
            width = len, height = len)
        if(v == 1){
          
          print(ggplot(Method[[m]]) + 
                  geom_histogram(aes(x = COST, y = ..density..), colour = "black", fill = "white") + 
                  geom_density(aes(x = COST, y = ..density..), alpha = .2, fill = "#FF6666") + 
                  xlab(names(Method)[[m]]) + ggtitle("COST")  + theme(axis.line = element_line(size=1, colour = "black")))
          
        }else if(v == 2){
          print(ggplot(Method[[m]]) + 
                  geom_histogram(aes(x = REV, y = ..density..), colour = "black", fill = "white") + 
                  geom_density(aes(x = REV, y = ..density..), alpha = .2, fill = "#FF6666") 
                + xlab(names(Method)[[m]]) + ggtitle("REV") + theme(axis.line = element_line(size=1, colour = "black")))
          
        }else if(v == 3){
          
          print(ggplot(Method[[m]]) + 
                  geom_histogram(aes(x = ASSET, y = ..density..), colour = "black", fill = "white") + 
                  geom_density(aes(x = ASSET, y = ..density..), alpha = .2, fill = "#FF6666")
                + xlab(names(Method)[[m]]) + ggtitle("ASSET") + theme(axis.line = element_line(size=1, colour = "black")))
          
        }else{
          
          print(ggplot(Method[[m]]) + 
                  geom_histogram(aes(x = INVESTAS, y = ..density..), colour = "black", fill = "white") + 
                  geom_density(aes(x = INVESTAS, y = ..density..), alpha = .2, fill = "#FF6666") + 
                  xlab(names(Method)[[m]]) + ggtitle("INVESTAS") + theme(axis.line = element_line(size=1, colour = "black")))
        }
        dev.off()
      }
    }
    
    ### histogram for imputed data
    for(m in c(1, 3:10)){
      for(v in 1:length(var)){
        bin = 1
        dir.create(paste0("result/", IND, "/", "y", year, "/", sel, "/imp"))
        
        
        png(filename = paste0("result/", IND, "/y", year, "/", sel, "/imp/", m, names(Method)[[m]], "_", v, ".png"),
            width = len, height = len)
        if(m == 3|| m == 4){
          if(v == 1){
            print(ggplot(Method[[m]][missing,]) + 
                    geom_histogram(aes(x = COST, y = ..density..), colour = "black", fill = "white", binwidth = bin) + 
                    xlim(c(unique(Method[[3]][missing,"COST"]) - 2 * bin, unique(Method[[3]][missing,"COST"]) + 2 * bin)) + 
                    xlab(names(Method)[[m]]) + ggtitle("COST") + theme(axis.line = element_line(size=1, colour = "black")))
            
          }else if(v == 2){
            print(ggplot(Method[[m]][missing,]) + 
                    geom_histogram(aes(x = REV, y = ..density..), colour = "black", fill = "white", binwidth = bin) + 
                    xlim(c(unique(Method[[3]][missing,"REV"]) - 2 * bin, unique(Method[[3]][missing,"REV"]) + 2 * bin)) + 
                    xlab(names(Method)[[m]]) + ggtitle("REV") + theme(axis.line = element_line(size=1, colour = "black")))
            
          }else if(v == 3){
            print(ggplot(Method[[m]][missing,]) + 
                    geom_histogram(aes(x = ASSET, y = ..density..), colour = "black", fill = "white", binwidth = bin) + 
                    xlim(c(unique(Method[[3]][missing,"ASSET"]) - 2 * bin, unique(Method[[3]][missing,"ASSET"]) + 2 * bin)) + 
                    xlab(names(Method)[[m]]) + ggtitle("ASSET") + theme(axis.line = element_line(size=1, colour = "black")))
            
          }else{
            print(ggplot(Method[[m]][missing,]) + 
                    geom_histogram(aes(x = INVESTAS, y = ..density..), colour = "black", fill = "white", binwidth = bin) + 
                    xlim(c(unique(Method[[3]][missing,"INVESTAS"]) - 2 * bin, unique(Method[[3]][missing,"INVESTAS"]) + 2 * bin)) + 
                    xlab(names(Method)[[m]]) + ggtitle("INVESTAS") + theme(axis.line = element_line(size=1, colour = "black")))
          }
        }else{
          if(v == 1){
            
            print(ggplot(Method[[m]][missing,]) + 
                    geom_histogram(aes(x = COST, y = ..density..), colour = "black", fill = "white") + 
                    geom_density(aes(x = COST, y = ..density..), alpha = .2, fill = "#FF6666") + 
                    xlab(names(Method)[[m]]) + ggtitle("COST") + theme(axis.line = element_line(size=1, colour = "black")))
            
          }else if(v == 2){
            
            print(ggplot(Method[[m]][missing,]) + 
                    geom_histogram(aes(x = REV, y = ..density..), colour = "black", fill = "white") + 
                    geom_density(aes(x = REV, y = ..density..), alpha = .2, fill = "#FF6666") + 
                    xlab(names(Method)[[m]]) + ggtitle("REV") + theme(axis.line = element_line(size=1, colour = "black")))
            
          }else if(v == 3){
            
            print(ggplot(Method[[m]][missing,]) + 
                    geom_histogram(aes(x = ASSET, y = ..density..), colour = "black", fill = "white") + 
                    geom_density(aes(x = ASSET, y = ..density..), alpha = .2, fill = "#FF6666") + 
                    xlab(names(Method)[[m]]) + ggtitle("ASSET") + theme(axis.line = element_line(size=1, colour = "black")))
            
          }else{
            
            print(ggplot(Method[[m]][missing,]) + 
                    geom_histogram(aes(x = INVESTAS, y = ..density..), colour = "black", fill = "white") + 
                    geom_density(aes(x = INVESTAS, y = ..density..), alpha = .2, fill = "#FF6666") + 
                    xlab(names(Method)[[m]]) + ggtitle("INVESTAS") + theme(axis.line = element_line(size=1, colour = "black")))
          }
        }
        
        dev.off()
      }
    }
    
  }
}


### summary for imputed data

load("data/y100_5611.rda")
load("data/y105_5611.rda")

library(openxlsx)
source("func.R", encoding = "UTF-8")


for(y in 1:2){
  ### basic information for the different year
  if(y == 1){
    year = 100
    var = c("COST", "REV", "ASSET")
    complete = y100_5611
  }else{
    year = 105
    var = c("COST", "REV", "ASSET", "INVESTAS")
    complete = y105_5611
    
  }
  
  ### take the basic dataset information
  IND = 5611
  
  missing = which(complete$TAX == 2)
  
  ### create the folder to store the results
  dir.create("result")
  dir.create(paste0("result/", IND))
  dir.create(paste0("result/", IND, "/", "y", year))
  ### j == 1 : using all variables to impute, j == 2 using significant variables to impute
  for(j in 1:2){
    if(j == 1){
      sel = "varA"
      
    }else{
      sel = "varS"
      
    }
    ### input result
    load(paste0("result/", IND, "/y", year, "/", sel, ".rda"))
    
    ### take log and return origin scale to calculate summary statistic and ks-test
    for(l in 1:2){
      
      wb_summary = createWorkbook()
      ### summary statistic for missing value by each method
      for(v in 1:length(var)){
        addWorksheet(wb_summary, sheetName = var[[v]])
        
        for(i in c(1, 3:10)){
          kst = ks.test(x = type(data = Method[[i]][missing, var[[v]]], t = l), y = type(data = Method$Real[missing, var[[v]]], t = l))
          
          sum_i = c(sapply(type(data = Method[[i]][missing, var], t = l), summary)[,v], 
                    sum(type(data = Method[[i]][missing, var[[v]]], t = l)),
                    round(cbind(kst$statistic, kst$p.value), digits = 4))
          
          if(i == 1){
            sum = sum_i
          }else{
            sum = rbind(sum, sum_i)
          }
          
        }
        rownames(sum) = names(Method)[c(1, 3:10)]
        writeData(wb_summary, sheet = var[[v]], x = sum, startCol = 2, startRow = 2, rowNames = TRUE)
      }
      saveWorkbook(wb_summary, file = paste0("result/", IND, "/y", year, "/", sel, "/", "type", l, ".xlsx"), overwrite = TRUE)
    }
    
    
    
    
  }
}

rm(list = ls())



