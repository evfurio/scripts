use BTSEventStore --QA is DL1SCQDB03SQL08\INST08

select ChildOrderNumber,CardNumber,AuthorizationCode,AuthorizationId,AuthorizationReasonCode from om.event_FullOnlineOrderSubmitted_PaymentGiftCard
where ChildOrderNumber = '#{order_num}+D'

