module MultipassServiceRequestTemplates

  ADD_ISSUED_USER = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ns="http://www.gamestop.com/services/channel/multipass/contracts/2010/05" xmlns:ns1="http://www.gamestop.com/services/core/contracts/2010/05" xmlns:ns2="http://www.gamestop.com/services/csl/authentication/contracts/messages/2010/05" xmlns:ns3="http://www.gamestop.com/services/core/entities/2010/05">
  <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
      <wsa:Action soap:mustUnderstand="1">?</wsa:Action>
      <wsa:To soap:mustUnderstand="1">?</wsa:To>
  </soap:Header>
   <soap:Body>
      <ns:AddIssuedUser>
         <ns:request>
            <ns1:MachineName>dcontest</ns1:MachineName>
            <ns2:Password>?</ns2:Password>
            <ns2:User>
               <ns3:ClientID>0</ns3:ClientID>
               <ns3:EmailAddress>?</ns3:EmailAddress>
               <ns3:EmailIsValid>?</ns3:EmailIsValid>
               <ns3:UserID>0</ns3:UserID>
               <ns3:UserName>?</ns3:UserName>
            </ns2:User>
         </ns:request>
      </ns:AddIssuedUser>
   </soap:Body>
</soap:Envelope>
eos

  CHANGE_PASSWORD = <<eos
<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:ns="http://www.gamestop.com/services/channel/multipass/contracts/2010/05" xmlns:ns1="http://www.gamestop.com/services/core/contracts/2010/05" xmlns:ns2="http://www.gamestop.com/services/csl/authentication/contracts/messages/2010/11">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing">
    <wsa:Action soap:mustUnderstand="1">http://www.gamestop.com/services/channel/multipass/contracts/2010/05/IMultiPassService/ChangePassword</wsa:Action>
    <wsa:To soap:mustUnderstand="1">?</wsa:To>
   </soap:Header>
   <soap:Body>
      <ns:ChangePassword>
         <ns:request>
            <ns1:MachineName>?</ns1:MachineName>
            <ns2:NewPassword>?</ns2:NewPassword>
            <ns2:OldPassword>?</ns2:OldPassword>
            <ns2:OpenIDClaimedIdentifier>?</ns2:OpenIDClaimedIdentifier>
         </ns:request>
      </ns:ChangePassword>
   </soap:Body>
</soap:Envelope>
eos

end