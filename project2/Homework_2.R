library("RODBC")
library(dplyr)
myconn<-odbcConnect("dartmouth","yzhang","yzhang@qbs181")
IC_Demo<-sqlQuery(myconn,"select * from Demographics")
IC_Cond<-sqlQuery(myconn,"select * from Conditions")
IC_TM<-sqlQuery(myconn,"select * from TextMessages")

Demo_Cond_TM <- sqlQuery(myconn,"select A.*, B.*,C.* from Demographics A
                                 full join Conditions B
                                 on A.contactid=B.tri_patientid
                                full join TextMessages C
                                on A.contactid=C.tri_contactId")

Texts_per_week <- sqlQuery(myconn, "SELECT DATEPART(wk, yzhang.Demo_Cond_TM.TextSentDate) as WeekNumber, 
                          count(*) as WeekCount, 
                          yzhang.Demo_Cond_TM.SenderName
                          From yzhang.Demo_Cond_TM
                          GROUP BY DATEPART(wk, yzhang.Demo_Cond_TM.TextSentDate), 
                          yzhang.Demo_Cond_TM.SenderName
                          ORDER BY DATEPART(wk, yzhang.Demo_Cond_TM.TextSentDate), 
                          yzhang.Demo_Cond_TM.SenderName ASC")

library(ggplot2)
ggplot(Texts_per_week, aes(WeekNumber, WeekCount))+geom_bar(aes(fill=SenderName),
width=0.4, position=position_dodge(width=0.5), stat="identity")+
  labs(x="Week Number", y="Number of Calls")
  theme(legend.position = "top", legend.title = element_blank())

Texts_per_cond <- sqlQuery(myconn, "SELECT DATEPART(wk, yzhang.Demo_Cond_TM.TextSentDate) as WeekNumber, 
                      count(*) as WeekCount, 
                      yzhang.Demo_Cond_TM.tri_Name
                      From yzhang.Demo_Cond_TM
                      GROUP BY DATEPART(wk, yzhang.Demo_Cond_TM.TextSentDate), 
                      yzhang.Demo_Cond_TM.tri_Name
                      ORDER BY DATEPART(wk, yzhang.Demo_Cond_TM.TextSentDate), 
                      yzhang.Demo_Cond_TM.tri_Name ASC")
ggplot(Texts_per_cond, aes(WeekNumber, WeekCount))+geom_bar(aes(fill=tri_Name),
width=0.4, position=position_dodge(width=0.5), stat="identity")+
labs(x="Week Number", y="Number of Calls")
theme(legend.position = "top", legend.title = element_blank())


