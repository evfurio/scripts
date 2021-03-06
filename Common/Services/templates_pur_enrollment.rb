module LoyaltyMembershipServiceRequestTemplates

  ENROLL_CUSTOMER_FOR_MEMBERSHIP = <<eos
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://schemas.gamestop.com/shared/commonschemas/v1.0" xmlns:v11="http://schemas.gamestop.com/marketing/loyaltylifecycle/loyaltymembershipservice/messagetypes/v1.0">
   <soapenv:Header>
      <v1:MessageHeaders>
         <!--Optional:-->
         <MachineName>?</MachineName>
         <!--Optional:-->
         <KeyValuePairs>
            <!--Zero or more repetitions:-->
            <KeyValuePair>
               <Key>?</Key>
               <Value>?</Value>
            </KeyValuePair>
         </KeyValuePairs>
         <CultureInfo>
            <Locale>?</Locale>
            <TimeZone>?</TimeZone>
            <CountryCode>?</CountryCode>
         </CultureInfo>
         <!--Optional:-->
         <SecutiryToken>?</SecutiryToken>
      </v1:MessageHeaders>
   </soapenv:Header>
   <soapenv:Body>
      <v11:EnrollCustomerForMembershipRequest>
         <v11:Customer>
            <!--Optional:-->
            <Addresses>
               <!--Zero or more repetitions:-->
               <Address>
                  <!--Optional:-->
                  <AddressGuid>?</AddressGuid>
                  <!--Optional:-->
                  <AddressID>?</AddressID>
                  <!--Optional:-->
                  <AddressLine1>?</AddressLine1>
                  <!--Optional:-->
                  <AddressLine2>?</AddressLine2>
                  <!--Optional:-->
                  <AddressLine3>?</AddressLine3>
                  <!--Optional:-->
                  <AddressLine4>?</AddressLine4>
                  <!--Optional:-->
                  <AddressType>?</AddressType>
                  <!--Optional:-->
                  <City>?</City>
                  <!--Optional:-->
                  <CompanyName>?</CompanyName>
                  <!--Optional:-->
                  <Country>?</Country>
                  <!--Optional:-->
                  <County>?</County>
                  <!--Optional:-->
                  <FirstName>?</FirstName>
                  <!--Optional:-->
                  <IsDefault>?</IsDefault>
                  <!--Optional:-->
                  <LastName>?</LastName>
                  <!--Optional:-->
                  <PostalCode>?</PostalCode>
                  <!--Optional:-->
                  <StateOrProvince>?</StateOrProvince>
               </Address>
            </Addresses>
            <!--Optional:-->
            <DateOfBirth>?</DateOfBirth>
            <!--Optional:-->
            <EdgeCardDiscountNumber>?</EdgeCardDiscountNumber>
            <!--Optional:-->
            <DisplayName>?</DisplayName>
            <!--Optional:-->
            <EmailAddress>?</EmailAddress>
            <!--Optional:-->
            <EmailOptOut>?</EmailOptOut>
            <!--Optional:-->
            <FirstName>?</FirstName>
            <!--Optional:-->
            <Gender>?</Gender>
            <!--Optional:-->
            <Phones>
               <!--Zero or more repetitions:-->
               <Phone>
                  <!--Optional:-->
                  <HomePhoneNumber>?</HomePhoneNumber>
                  <!--Optional:-->
                  <MobilePhoneNumber>?</MobilePhoneNumber>
                  <!--Optional:-->
                  <PrimaryPhone>?</PrimaryPhone>
                  <!--Optional:-->
                  <WorkPhoneNumber>?</WorkPhoneNumber>
               </Phone>
            </Phones>
            <!--Optional:-->
            <HomeStoreNumber>?</HomeStoreNumber>
            <!--Optional:-->
            <Identifications>
               <!--Zero or more repetitions:-->
               <Identification>
                  <!--Optional:-->
                  <Expiration>?</Expiration>
                  <!--Optional:-->
                  <IDNumber>?</IDNumber>
                  <!--Optional:-->
                  <IDType>?</IDType>
                  <!--Optional:-->
                  <IdentificationGuid>?</IdentificationGuid>
                  <!--Optional:-->
                  <IdentificationID>?</IdentificationID>
                  <!--Optional:-->
                  <IssueDate>?</IssueDate>
                  <!--Optional:-->
                  <Issuer>?</Issuer>
               </Identification>
            </Identifications>
            <!--Optional:-->
            <IssuedUser>?</IssuedUser>
            <!--Optional:-->
            <LastName>?</LastName>
            <!--Optional:-->
            <LoyaltyInfo>
               <!--Optional:-->
               <ValidLoyaltyMembership>?</ValidLoyaltyMembership>
               <!--Optional:-->
               <CardStatus>?</CardStatus>
               <!--Optional:-->
               <DetailedCardStatus>?</DetailedCardStatus>
               <!--Optional:-->
               <DetailedMembershipStatus>?</DetailedMembershipStatus>
               <!--Optional:-->
               <EndDate>?</EndDate>
               <!--Optional:-->
               <FailedLoginAttempts>?</FailedLoginAttempts>
               <!--Optional:-->
               <IsLockedOut>?</IsLockedOut>
               <!--Optional:-->
               <LoginTimeStamp>?</LoginTimeStamp>
               <!--Optional:-->
               <LoyaltyCardNumber>?</LoyaltyCardNumber>
               <!--Optional:-->
               <MembershipId>?</MembershipId>
               <!--Optional:-->
               <MembershipStatus>?</MembershipStatus>
               <!--Optional:-->
               <OnlineAccountStatus>?</OnlineAccountStatus>
               <!--Optional:-->
               <Roles>
                  <!--Zero or more repetitions:-->
                  <string>?</string>
               </Roles>
               <!--Optional:-->
               <Tier>?</Tier>
               <!--Optional:-->
               <TierExpirationDate>?</TierExpirationDate>
               <!--Optional:-->
               <TierSignUpDate>?</TierSignUpDate>
               <!--Optional:-->
               <TotalPowerUpSavings>?</TotalPowerUpSavings>
            </LoyaltyInfo>
            <!--Optional:-->
            <MembershipIds>
               <!--Zero or more repetitions:-->
               <int>?</int>
            </MembershipIds>
            <!--Optional:-->
            <MiddleName>?</MiddleName>
            <!--Optional:-->
            <Prefix>?</Prefix>
            <!--Optional:-->
            <Race>?</Race>
            <!--Optional:-->
            <Suffix>?</Suffix>
            <!--Optional:-->
            <Title>?</Title>
            <!--Optional:-->
            <UserName>?</UserName>
            <!--Optional:-->
            <CustomerActivities>?</CustomerActivities>
            <!--Optional:-->
            <MembershipType>
               <!--Optional:-->
               <CardNumber>?</CardNumber>
               <Tier>?</Tier>
               <ExpirationDate>?</ExpirationDate>
               <!--Optional:-->
               <MembershipStatus>?</MembershipStatus>
            </MembershipType>
            <!--Optional:-->
            <ValidEmailAddress>?</ValidEmailAddress>
         </v11:Customer>
      </v11:EnrollCustomerForMembershipRequest>
   </soapenv:Body>
</soapenv:Envelope>
eos

  ACTIVATE_MEMBERSHIP = <<eos
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://schemas.gamestop.com/shared/commonschemas/v1.0" xmlns:v11="http://schemas.gamestop.com/marketing/loyaltylifecycle/loyaltymembershipservice/messagetypes/v1.0">
   <soapenv:Header>
      <v1:MessageHeaders>
         <!--Optional:-->
         <MachineName>?</MachineName>
         <!--Optional:-->
         <KeyValuePairs>
            <!--Zero or more repetitions:-->
            <KeyValuePair>
               <Key>?</Key>
               <Value>?</Value>
            </KeyValuePair>
         </KeyValuePairs>
         <CultureInfo>
            <Locale>?</Locale>
            <TimeZone>?</TimeZone>
            <CountryCode>?</CountryCode>
         </CultureInfo>
        <SecutiryToken>?</SecutiryToken>
      </v1:MessageHeaders>
   </soapenv:Header>
   <soapenv:Body>
      <v11:ActivateCustomerMembershipRequest>
         <v11:LoyaltyCardNumber>?</v11:LoyaltyCardNumber>
         <v11:OpenIdClaimedIdentifier>?</v11:OpenIdClaimedIdentifier>
         <v11:CardStatus>?</v11:CardStatus>
      </v11:ActivateCustomerMembershipRequest>
   </soapenv:Body>
</soapenv:Envelope>
eos

  ACTIVATE_LOYALTY_MEMBERSHIP = <<eos
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.gamestop.com/CSL/Membership/V1.0">
   <soapenv:Header>
      <v1:MachineName>?</v1:MachineName>
      <v1:CorrelationID>?</v1:CorrelationID>
   </soapenv:Header>
   <soapenv:Body>
      <v1:ActivateMembershipRequest>
         <v1:CardNumber>?</v1:CardNumber>
         <v1:MembershipId>?</v1:MembershipId>
         <v1:OpenIdClaimedIdentifier>?</v1:OpenIdClaimedIdentifier>
      </v1:ActivateMembershipRequest>
   </soapenv:Body>
</soapenv:Envelope>
eos

end

