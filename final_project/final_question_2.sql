select A.*, B.*,C.* from Demographics A
                                 full join Conditions B
                                 on A.contactid=B.tri_patientid
                                full join TextMessages C
                                on A.contactid=C.tri_contactId

UPDATE yzhang.Demo_Cond_TM SET TextSentDate = CONVERT(datetime, TextSentDate, 1)

select * FROM yzhang.Demo_Cond_TM t
                      inner join (
                      select contactid, max(TextSentDate) as MaxDate
                      from yzhang.Demo_Cond_TM
                      group by contactid
                      ) tm
                      on t.contactid=tm.contactid and t.TextSentDate=TM.MaxDate

select count(DISTINCT Demo_Cond_TM.contactid) from yzhang.Demo_Cond_TM