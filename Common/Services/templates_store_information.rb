module StoreInformationServiceRequestTemplates

IS_SERVICE_ALIVE = <<eos
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.gamestop.com/services/core/contracts/2010/05">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:IsServiceAlive/>
   </soapenv:Body>
</soapenv:Envelope>
eos

GET_STORE_INFORMATION = <<eos
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.gamestop.com/services/csl/storeinformation/contracts/2010/08" xmlns:ns1="http://www.gamestop.com/services/core/contracts/2010/05" xmlns:ns2="http://www.gamestop.com/services/csl/storeinformation/entities/2010/08">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:GetStoreInformation>
         <!--Optional:-->
         <ns:request>
            <ns1:MachineName>?</ns1:MachineName>
            <!--Optional:-->
            <ns2:CountryCode>?</ns2:CountryCode>
            <!--Optional:-->
            <ns2:StoreId>?</ns2:StoreId>
            <!--Optional:-->
            <ns2:StoreNumber>?</ns2:StoreNumber>
         </ns:request>
      </ns:GetStoreInformation>
   </soapenv:Body>
</soapenv:Envelope>
eos

GET_STORES_BY_ZIP_CODE = <<eos	
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.gamestop.com/services/csl/storeinformation/contracts/2010/08" xmlns:ns1="http://www.gamestop.com/services/core/contracts/2010/05" xmlns:ns2="http://www.gamestop.com/services/csl/storeinformation/messages/2010/11" xmlns:ns3="http://www.gamestop.com/services/csl/storeinformation/entities/2010/11">
   <soapenv:Header/>
   <soapenv:Body>
      <ns:GetStoresByZipCode>
         <!--Optional:-->
         <ns:request>
            <ns1:MachineName>?</ns1:MachineName>
            <!--Optional:-->
            <ns2:RadialDistance>
               <!--Optional:-->
               <ns3:UnitOfMeasureType>?</ns3:UnitOfMeasureType>
               <!--Optional:-->
               <ns3:Value>?</ns3:Value>
            </ns2:RadialDistance>
            <!--Optional:-->
            <ns2:ZipCode>?</ns2:ZipCode>
         </ns:request>
      </ns:GetStoresByZipCode>
   </soapenv:Body>
</soapenv:Envelope>
eos

end