IC_BP <- read.csv("C:/Users/f003mxk/Desktop/Qbs_181/Final/IC_BP_v2.csv", stringsAsFactors = FALSE)
#Question 1
#(a)
colnames(IC_BP)[4] <- "BPstatus"

#(b)
IC_BP$BPstatus[IC_BP$BPstatus=='Normal'] <- 1
IC_BP$BPstatus[IC_BP$BPstatus=='Hypo1'] <- 1
IC_BP$BPstatus[IC_BP$BPstatus=='HTN1'] <- 0
IC_BP$BPstatus[IC_BP$BPstatus=='HTN2'] <- 0
IC_BP$BPstatus[IC_BP$BPstatus=='HTN3'] <- 0
IC_BP$BPstatus[IC_BP$BPstatus=='Hypo2'] <- 0

#(c)
library("RODBC")
library(dplyr)
myconn<-odbcConnect("dartmouth","yzhang","yzhang@qbs181")
IC_Demo<-sqlQuery(myconn,"select * from Demographics")
IC_Cond<-sqlQuery(myconn,"select * from Conditions")
IC_TM<-sqlQuery(myconn,"select * from TextMessages")
library(sqldf)
BP_Demo <- sqldf("select A.*, B.* from IC_Demo A
                 join IC_BP B
                 on A.contactid=B.ID")

#(d)
glimpse(BP_Demo)
BP_Demo_Patient <- data.frame()
aggregate(BP_Demo$ObservedTime, by=list(BP_Demo$ID), FUN=range)
BP_Demo_Patient <- aggregate(BP_Demo$ObservedTime, by=list(BP_Demo$ID), FUN=max)
colnames(BP_Demo_Patient)[2] <- "Max"
BP_Demo_Patient$Min <- aggregate(BP_Demo$ObservedTime, by=list(BP_Demo$ID), FUN=min)[2]
BP_Demo_Patient$Range = BP_Demo_Patient$Max-BP_Demo_Patient$Min
BP_Demo_Patient$Intervals = BP_Demo_Patient$Range/84

BP_Demo_new <- BP_Demo %>%
  group_by(ID) %>%
  mutate(Daynumber=ObservedTime-min(ObservedTime))

BP_Demo_new$Intervalnumber= (BP_Demo_new$Daynumber %/% 84)+1


BP_Demo_Final <- sqldf(
  "
  SELECT ID, Intervalnumber, AVG(SystolicValue), AVG(DiastolicValue), Median(BPstatus)
  FROM BP_Demo_new
  GROUP BY ID, Intervalnumber
  ORDER BY ID, Intervalnumber
  "
)
colnames(BP_Demo_Final)[3] <- "AVGSystolicValue"
colnames(BP_Demo_Final)[4] <- "AVGDiastolicValue"
colnames(BP_Demo_Final)[5] <- "BPstatus"


#(e)
BP_Demo_Sub <- BP_Demo_Final[which(BP_Demo_Final$Intervalnumber==1 |BP_Demo_Final$Intervalnumber==2),]
BP_Demo_Sub_1 <- BP_Demo_Sub[which(BP_Demo_Sub$ID=="B9FA86B2-2D0B-E611-8120-C4346BAD2660" |BP_Demo_Sub$ID=="C0FDFEE3-D4E4-E511-8123-C4346BB59854"|BP_Demo_Sub$ID=="C3FA86B2-2D0B-E611-8120-C4346BAD2660"|BP_Demo_Sub$ID=="C845C5F7-0C16-E611-8128-C4346BB59854"|BP_Demo_Sub$ID=="CC45C5F7-0C16-E611-8128-C4346BB59854"|BP_Demo_Sub$ID=="DED8C3D3-E9E6-E511-8116-C4346BAC02E8"),]
BP_Demo_Sub_2 <- BP_Demo_Sub[which(BP_Demo_Sub$ID=="E3E77E9D-5411-E611-811B-C4346BAC02E8" |BP_Demo_Sub$ID=="F288E3CB-5111-E611-811B-C4346BAC02E8"|BP_Demo_Sub$ID=="F786A327-A108-E611-811D-C4346BACD1A8"|BP_Demo_Sub$ID=="F8D8C3D3-E9E6-E511-8116-C4346BAC02E8"|BP_Demo_Sub$ID=="F986A327-A108-E611-811D-C4346BACD1A8"|BP_Demo_Sub$ID=="388AE3CB-5111-E611-811B-C4346BAC02E8"),]


library(ggplot2)
ggplot(BP_Demo_Sub_1, aes(ID, AVGSystolicValue))+geom_bar(aes(fill=Intervalnumber),
width=0.5, position=position_dodge(width = 0.5), stat="identity")+
  labs(x="ID", y="Average Systolic Value")
  theme(legend.position="top", legend.title=element_blank())
  
plot <- ggplot(BP_Demo_Sub_1, aes(Intervalnumber, AVGSystolicValue, fill=ID))
plot <- plot + geom_bar(stat = "identity", position = 'dodge')
plot

plot <- ggplot(BP_Demo_Sub_2, aes(Intervalnumber, AVGDiastolicValue, fill=ID))
plot <- plot + geom_bar(stat = "identity", position = 'dodge')
plot

#(f)
BP_Demo_Sub_3 <- BP_Demo_Final[which(BP_Demo_Final$Intervalnumber==1 &BP_Demo_Final$BPstatus==0),]
BP_Demo_Sub_4 <- BP_Demo_Final[which(BP_Demo_Final$Intervalnumber==2 &BP_Demo_Final$BPstatus==1),]

BP_Demo <- sqldf("select A.*, B.* from BP_Demo_Sub_3 A
                 inner join BP_Demo_Sub_4 B
                 on A.ID=B.ID")




#Question 3
Demo_Cond_TM <- sqlQuery(myconn,"select A.*, B.*,C.* from Demographics A
                                 full join Conditions B
                                 on A.contactid=B.tri_patientid
                                full join TextMessages C
                                on A.contactid=C.tri_contactId")

library(dplyr)
library(tidyr)
glimpse(Demo_Cond_TM)
Demo_Cond_TM$TextSentDate<- as.character(Demo_Cond_TM$TextSentDate)
Demo_Cond_TM$TextSentDate<- as.Date(Demo_Cond_TM$TextSentDate, format = "%m/%d/%y")
Demo_Cond_TM$contactid <- as.character(Demo_Cond_TM$contactid)

Demo_Cond_TM_new <- Demo_Cond_TM %>%
  group_by(contactid) %>%
  mutate(TextSentDate=as.Date(TextSentDate, format= "%m/%d/%y"))%>% 
  filter(TextSentDate==max(TextSentDate))



