source("http://zzlab.net/GAPIT/gapit_functions.txt") 

library(data.table)
myGD=as.data.frame(fread("data/upload_data.012"))  
myGM=fread("data/upload_data.bim")
myGM<-data.frame(SNP=myGM$V2,Chromosome=myGM$V1,Postition=myGM$V4)

datasize<-nrow(myGD)

Y<-read.table("data/ADG.txt")

####function for cross validation sampling
CVgroup <- function(k,datasize,seed){
  cvlist <- list()
  set.seed(seed) 
  n <- rep(1:k,ceiling(datasize/k))[1:datasize]   
  temp <- sample(n,datasize)   
  x <- 1:k
  dataseq <- 1:datasize
  cvlist <- lapply(x,function(x) dataseq[temp==x])  
  return(cvlist)
}

fold <- 5

cvlist <- CVgroup(k = fold,datasize = datasize,seed = 111)

KI<-GAPIT.kinship.VanRaden(myGD)

KI<-cbind(Y$V1,KI)


####GS only(GBLUP)
r2_vec<-numeric(length=5)

for (i in 1:fold) {
  myGAPIT<-GAPIT(
    Y=Y[-cvlist[[i]],],
    GD=myGD[-cvlist[[i]],],
    GM=myGM,
    PCA.total = 3,
    KI=KI,
    model="gBLUP",
    SNP.test = FALSE,
    memo="gBLUP",
    file.out=F
  )  
  
  order=match(Y[,1],myGAPIT$Pred[,1])
  myPred=myGAPIT$Pred[order,]
  r2=cor(myPred[cvlist[[i]],5],Y[cvlist[[i]],2])
  r2_vec[i]<-r2
}


####GWAS+GS(MLM+GBLUP)
r2_vec_1<-numeric(length=5)

for(i in 1:fold){
  myGWAS<-GAPIT(
    Y=Y[-cvlist[[i]],],
    GD=myGD[-cvlist[[i]],],
    GM=myGM,
    PCA.total = 3,
    model="MLM",
    SNP.test = FALSE,
    memo="GWAS"
  )  
  
  index<-myGWAS$GWAS[,4]<-1/length(myGWAS$GWAS[,4])
  myQTN<-cbind(myGWAS$PCA,myGD[,index])
  
  myGS<-GAPIT(
    Y=Y[-cvlist[[i]],],
    GD=myGD,
    GM=myGM,
    CV=myQTN,
    KI=KI,
    model="gBLUP",
    SNP.test = FALSE,
    memo="GWAS+GS",
    file.output = F
  )
  
  order=match(Y[,1],myGS$Pred[,1])
  myPred_1=myGS$Pred[order,]
  r2_1=cor(myPred_1[cvlist[[i]],5],Y[cvlist[[i]],2])
  r2_vec_1[i]<-r2_1
}


####result visualization
acc<-read.table("result.txt",header = T)
library(ggplot2)
ggplot(acc,aes(x=Trait,y=Accuracy,fill=Method))+geom_boxplot()