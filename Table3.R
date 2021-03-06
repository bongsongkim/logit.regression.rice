
# variable interactions

  install.packages("RCurl")                  
  require(RCurl)

  install.packages("iml")                  
  require(iml)

  dat <- read.csv(text=getURL("https://raw.githubusercontent.com/bongsongkim/logit.regression.rice/master/ricediversity.44k.germplasm3.csv"),header=T)   
  phe <- read.csv(text=getURL("https://raw.githubusercontent.com/bongsongkim/logit.regression.rice/master/RiceDiversity_44K_Phenotypes_34traits_PLINK.txt"),header=T)
  inters <- intersect(dat$NSFTV.ID,phe$NSFTVID)
  dat <- dat[match(inters,dat$NSFTV.ID),]
  phe <- phe[match(inters,phe$NSFTVID),]  
  
  dat1 <- cbind(dat,phe)    
  dat2 <- dat1[which( dat1$Sub.population == "JAP" | dat1$Sub.population == "IND"),]  

  names(dat2)
  
    phen1 <- dat2$Panicle.number.per.plant
    phen2 <- dat2$Seed.number.per.panicle
    phen3 <- dat2$Florets.per.panicle
    phen4 <- dat2$Panicle.fertility 
    phen5 <- dat2$Straighthead.suseptability
    phen6 <- dat2$Blast.resistance
    phen7 <- dat2$Protein.content
    subpop <- dat2$Sub.population   


   vec <- which(is.na(phen1) == T)
   vec <- c(vec,which(is.na(phen2) == T))
   vec <- c(vec,which(is.na(phen3) == T))
   vec <- c(vec,which(is.na(phen4) == T))
   vec <- c(vec,which(is.na(phen5) == T))
   vec <- c(vec,which(is.na(phen6) == T))
   vec <- c(vec,which(is.na(phen7) == T))
   unique(vec)
   
   X = cbind(phen1,phen2)
   X = cbind(X,phen3)
   X = cbind(X,phen4)
   X = cbind(X,phen5)
   X = cbind(X,phen6)
   X = cbind(X,phen7)  

   X      = X[-vec,]  
   subpop = subpop[-vec]
  
  fit <- glm(Sub.population ~ phen1 + phen2 + phen3 + phen4 + phen5 + phen6 + phen7,data=dat2,family=binomial(link = "logit"),control = list(maxit = 100))  
   summary(fit)
     
  predictor = Predictor$new(fit, data = data.frame(X), y = subpop) 
    
  interact = Interaction$new(predictor)
  plot(interact) 
    
