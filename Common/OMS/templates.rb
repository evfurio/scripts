module OMSTemplates

# This file contains input templates for the Sterling OMS API


CREATE_ORDER_SAMPLE = <<eos
<Order CustomerEMailID="svc_qa_auto@qagsecomprod.oib.com"
    CustomerPONo="4150414200682123" DocumentType="0001" EnteredBy="WEB"
    EnterpriseCode="GS_US" EntryType="GS"
    OrderDate="2015-04-14T20:06:31" OrderName="4150414200682123"
    OrderType="PhysicalNonISPU" SellerOrganizationCode="GS_US" ValidateItem="Y">
    <Extn ExtnFingerprintSessionID="9f57cf03-6a69-40f9-94e3-17018dad7e09"/>
    <OrderLines>
        <OrderLine CarrierServiceCode="16" LineType="Product"
            OrderedQty="1" PrimeLineNo="1" TransactionalLineId="1">
            <Extn ExtnQuotationCallMade="N" ExtnShipGroup="1"/>
            <Item ItemDesc="Logitech G930 Wireless Gaming Headset"
                ItemID="804178" UnitOfMeasure="EACH"/>
            <PersonInfoShipTo AddressLine1="625 Westport Pkwy"
                AddressLine2="" City="Grapevine" Country="US"
                DayPhone="8177227093"
                EMailID="svc_qa_auto@qagsecomprod.oib.com"
                FirstName="Accept" LastName="Shipper" MobilePhone=""
                State="TX" ZipCode="76051"/>
            <Instructions/>
            <LinePriceInfo IsPriceLocked="Y" UnitPrice="159.9900"/>
            <LineCharges/>
            <LineTaxes>
                <LineTax ChargeCategory="SalesTax" Reference1="TARRANT"
                    Tax="13.20" TaxName="SalesTax" TaxPercentage="8.25"/>
            </LineTaxes>
            <Notes/>
        </OrderLine>
    </OrderLines>
    <OrderLineRelationships/>
    <Notes>
        <Note
            NoteText="Free Value Ship 25 or more 2014 Pre order/Availa Free Value Shipping" ReasonCode="ShipDisc"/>
    </Notes>
    <PersonInfoShipTo AddressLine1="625 Westport Pkwy" AddressLine2=""
        City="Grapevine" Country="US" DayPhone="8177227093"
        EMailID="svc_qa_auto@qagsecomprod.oib.com" FirstName="Accept"
        LastName="Shipper" State="TX" ZipCode="76051"/>
    <PersonInfoBillTo AddressLine1="5615 High Point Dr" AddressLine2=""
        City="Irving" Country="US" DayPhone="8177226078"
        EMailID="svc_qa_auto@qagsecomprod.oib.com" FirstName="Accept"
        LastName="Billing" MobilePhone="" State="TX" ZipCode="75038"/>
    <PriceInfo Currency="USD"/>
    <PaymentMethods>
        <PaymentMethod ChargeSequence="1" CreditCardExpDate="12/2049"
            CreditCardNo="A9654B78D7EF4241" CreditCardType="PURCC"
            DisplayCreditCardNo="4241" FirstName="Accept"
            LastName="Billing" PaymentType="CREDIT_CARD" UnlimitedCharges="Y">
            <PaymentDetails AuthCode="ACCEPT" AuthReturnCode=""
                AuthorizationExpirationDate="2015-04-14T00:00:00"
                AuthorizationID="de518e56-da1a-46c9-9ba6-1ab9793f0dcf"
                ChargeType="AUTHORIZATION" ProcessedAmount="0.01" RequestAmount="0.01"/>
            <PersonInfoBillTo AddressLine1="5615 High Point Dr"
                AddressLine2="" City="Irving" Country="US"
                DayPhone="8177226078"
                EMailID="svc_qa_auto@qagsecomprod.oib.com"
                FirstName="Accept" LastName="Billing" State="TX" ZipCode="75038"/>
        </PaymentMethod>
    </PaymentMethods>
</Order>
eos

CREATE_ORDER = <<eos
<?xml version="1.0" encoding="UTF-8"?>
<!--createOrder Input XML-->
<Order AllocationRuleID="" ApplyDefaultTemplate="" AuditTransactionId=""
    AuthorizedClient="" AutoCancelDate="" BillToID="" BillToKey=""
    BuyerMarkForNodeId="" BuyerOrganizationCode=""
    BuyerReceivingNodeId="" BuyerUserId="" CancelOrderOnBackorder="Y"
    CarrierAccountNo="" CarrierServiceCode="" ChargeActualFreightFlag=""
    CreatedAtNode="" CustCustPONo="" CustomerClassificationCode=""
    CustomerContactID="" CustomerEMailID="" CustomerPONo=""
    DefaultCustomerInformation="" DefaultTemplate="" DeliveryCode=""
    DepartmentCode="" Division="" DoNotConsolidate="" DocumentType=""
    DraftOrderFlag="" EnteredBy="" EnterpriseCode="" EntryType=""
    ExchangeType="" ExpirationDate="" FreightTerms=""
    HasDerivedParent="" HoldFlag="" HoldReasonCode=""
    HoursBeforeNextIteration="" IsExpirationDateOverridden=""
    IsLineShipComplete="Y" IsLineShipSingleNode="Y" IsShipComplete="Y"
    IsShipSingleNode="Y" LevelOfService="" LinkedSourceKey=""
    NextIterationDate="" NextIterationSeqNo="" NotificationReference=""
    NotificationType="" NotifyAfterShipmentFlag="" OpportunityKey=""
    OptimizationType="" OrderDate="" OrderName="" OrderNo=""
    OrderPurpose="" OrderType="" OriginalContainerKey=""
    PaymentRuleId="" PaymentStatus="" PersonalizeCode=""
    PriceProgramKey="" PriceProgramName="" PricingClassificationCode=""
    PriorityCode="" PriorityNumber="" PurgeHistoryDate="" Purpose=""
    ReceivingNode="" ReqCancelDate="" ReqDeliveryDate="" ReqShipDate=""
    ReserveInventoryFlag="" ReturnByGiftRecipient=""
    ReturnOrderHeaderKeyForExchange="" SCAC="" ScacAndService=""
    ScacAndServiceKey="" SearchCriteria1="" SearchCriteria2=""
    SellerOrganizationCode="" ShipNode="" ShipToID="" ShipToKey=""
    SkipBOMValidations="N" SoldToKey="" SourceKey="" SourceType=""
    SourcingClassification="" TaxExemptFlag=""
    TaxExemptionCertificate="" TaxJurisdiction="" TaxPayerId=""
    TeamCode="" TermsCode="" ValidateItem="" ValidatePromotionAward="Y" VendorID="">
    <!-- Set DraftOrderFlag=Y for creating Draft Order.-->
    <OrderLines>
        <!--1 or more order line. Optional for Draft order-->
        <OrderLine AllocationDate="" BOMXML="" CarrierAccountNo=""
            CarrierServiceCode="" CommittedQuantity=""
            ConditionVariable1="" ConditionVariable2=""
            ConfigurationKey="" CustomerLinePONo="" CustomerPONo=""
            DeliveryCode="" DeliveryMethod="" DepartmentCode=""
            DependencyShippingRule="" DistributionRuleId=""
            EarliestScheduleDate="" FillQuantity=""
            FirstIterationSeqNo="" FreightTerms="" FulfillmentType=""
            GiftFlag="" GiftWrap="" HoldFlag="" HoldReasonCode=""
            ImportLicenseExpDate="" ImportLicenseNo=""
            IntentionalBackorder="" IsFirmPredefinedNode=""
            IsForwardingAllowed="" IsProcurementAllowed=""
            ItemGroupCode="" KitCode="" KitQty="" LastIterationSeqNo=""
            LevelOfService="" LineType="" MergeNode="" MinShipByDate=""
            OrderedQty="" PackListType="" PersonalizeCode=""
            PickableFlag="" PipelineId="" PrimeLineNo=""
            ProcureFromNode="" PromisedApptEndDate=""
            PromisedApptStartDate="" Purpose="" ReceivingNode=""
            ReqCancelDate="" ReqDeliveryDate="" ReqShipDate=""
            ReservationID="" ReservationMandatory="Y" ReturnReason=""
            SCAC="" ScacAndService="" ScacAndServiceKey="" Segment=""
            SegmentType="" SerialNo="" ShipNode="" ShipToID=""
            ShipToKey="" ShipTogetherNo="" SubLineNo="" Timezone=""
            TransactionalLineId="" ValidateItem="">
            <OrderLineTranQuantity FillQuantity="" KitQty=""
                OrderedQty="" TransactionalUOM=""/>
            <DerivedFrom DocumentType="" EnterpriseCode=""
                OrderHeaderKey="" OrderLineKey="" OrderNo=""
                OrderReleaseKey="" PrimeLineNo="" ReleaseNo="" SubLineNo=""/>
            <!-- The DerivedFrom element is required if the orderline is to be derived from an existing orderline. OrderLineKey or OrderHeaderKey, PrimeLineNo, SubLineNo or OrderNo, DocumentType, EnterpriseCode, PrimeLineNo, SubLineNo are required to identify the orderline to derive from. The OrderReleaseKey or OrderHeaderKey, ReleaseNo or OrderNo, DocumentType, EnterpriseCode, ReleaseNo are required to identify the orderrelease to derive from-->
            <ChainedFrom DocumentType="" EnterpriseCode=""
                OrderHeaderKey="" OrderLineKey="" OrderNo=""
                PrimeLineNo="" SubLineNo=""/>
            <!-- The ChainedFrom element is required if the orderline is to be created by chaining from an existing orderline. OrderLineKey or OrderHeaderKey, PrimeLineNo, SubLineNo or OrderNo, EnterpriseCode, DocumentType, PrimeLineNo, SubLineNo are required to identify the orderline to chain with. -->
            <OrderLineOptions>
                <OrderLineOption OptionDescription=""
                    OptionItemID="Required" OptionUOM="Required"
                    PricingUOM="" UnitPrice=""/>
            </OrderLineOptions>
            <OrderLineSourcingControls>
                <OrderLineSourcingCntrl InventoryCheckCode=""
                    Node="Required" ReasonText=""
                    SuppressProcurement="Y" SuppressSourcing="Y"/>
            </OrderLineSourcingControls>
            <Item AlternateItemID="" BundleFulfillmentMode=""
                CostCurrency="" CountryOfOrigin="" CustomerItem=""
                CustomerItemDesc="" ECCNNo="" HarmonizedCode="" ISBN=""
                ItemDesc="" ItemID="" ItemShortDesc="" ItemWeight=""
                ItemWeightUOM="" ManufacturerItem=""
                ManufacturerItemDesc="" ManufacturerName="" NMFCClass=""
                NMFCCode="" NMFCDescription="" ProductClass=""
                ProductLine="" ScheduleBCode="" SupplierItem=""
                SupplierItemDesc="" TaxProductCode="" UPCCode=""
                UnitCost="" UnitOfMeasure=""/>
            <PersonInfoShipTo AddressID="" AddressLine1=""
                AddressLine2="" AddressLine3="" AddressLine4=""
                AddressLine5="" AddressLine6="" AlternateEmailID=""
                Beeper="" City="" Company="" Country="" DayFaxNo=""
                DayPhone="" Department="" EMailID="" EveningFaxNo=""
                EveningPhone="" FirstName="" IsCommercialAddress=""
                JobTitle="" LastName="" MiddleName="" MobilePhone=""
                OtherPhone="" PersonID="" State="" Suffix=""
                TaxGeoCode="" Title="" ZipCode=""/>
            <!--Optional-->
            <PersonInfoMarkFor AddressID="" AddressLine1=""
                AddressLine2="" AddressLine3="" AddressLine4=""
                AddressLine5="" AddressLine6="" AlternateEmailID=""
                Beeper="" City="" Company="" Country="" DayFaxNo=""
                DayPhone="" Department="" EMailID="" EveningFaxNo=""
                EveningPhone="" FirstName="" IsCommercialAddress=""
                JobTitle="" LastName="" MiddleName="" MobilePhone=""
                OtherPhone="" PersonID="" State="" Suffix=""
                TaxGeoCode="" Title="" ZipCode=""/>
            <!--Optional-->
            <Instructions>
                <Instruction InstructionText="Required"
                    InstructionType="" InstructionURL="" SequenceNo=""/>
            </Instructions>
            <LinePriceInfo DiscountPercentage=""
                IsLinePriceForInformationOnly="" IsPriceLocked=""
                ListPrice="" PricingQtyConversionFactor=""
                PricingQuantityStrategy="" PricingUOM="" RetailPrice=""
                TaxExemptionCertificate="" TaxableFlag="" UnitPrice=""/>
            <LineCharges>
                <LineCharge ChargeCategory="Required" ChargeName=""
                    ChargePerLine="" ChargePerUnit="" Reference=""/>
            </LineCharges>
            <LineTaxes>
                <LineTax ChargeCategory="" ChargeName="" Reference1=""
                    Reference2="" Reference3="" Tax=""
                    TaxName="Required" TaxPercentage="" TaxableFlag=""/>
            </LineTaxes>
            <!--Optional-->
            <References>
                <Reference Name="Required" Value=""/>
            </References>
            <!--Optional-->
            <KitLines>
                <KitLine CustomerItem="" CustomerItemDesc=""
                    DepartmentCode="" ItemDesc="" ItemID="Required"
                    ItemShortDesc="" ItemWeight="" ItemWeightUOM=""
                    KitQty="Required" ProductClass="" SupplierItem=""
                    SupplierItemDesc="" UPCCode="" UnitCost="" UnitOfMeasure="">
                    <KitLineTranQuantity KitQty="" TransactionalUOM=""/>
                </KitLine>
            </KitLines>
            <AdditionalAddresses>
                <AdditionalAddress AddressType="Required">
                    <PersonInfo AddressID="" AddressLine1=""
                        AddressLine2="" AddressLine3="" AddressLine4=""
                        AddressLine5="" AddressLine6=""
                        AlternateEmailID="" Beeper="" City="" Company=""
                        Country="" DayFaxNo="" DayPhone="" Department=""
                        EMailID="" EveningFaxNo="" EveningPhone=""
                        FirstName="" IsCommercialAddress="" JobTitle=""
                        LastName="" MiddleName="" MobilePhone=""
                        OtherPhone="" PersonID="" State="" Suffix=""
                        TaxGeoCode="" Title="" ZipCode=""/>
                </AdditionalAddress>
            </AdditionalAddresses>
            <Schedules>
                <Schedule BatchNo="" ChangeInQuantity="Required"
                    LotNumber="" RevisionNo="">
                    <ScheduleTranQuantity ChangeInQuantity="" TransactionalUOM=""/>
                </Schedule>
            </Schedules>
            <Dependency DependentOnPrimeLineNo=""
                DependentOnSubLineNo="" DependentOnTransactionalLineId=""/>
            <OrderDates>
                <OrderDate ActualDate="" CommittedDate=""
                    DateTypeId="Required" ExpectedDate="" RequestedDate=""/>
            </OrderDates>
            <OrderLineInvAttRequest BatchNo="" LotAttribute1=""
                LotAttribute2="" LotAttribute3="" LotKeyReference=""
                LotNumber="" ManufacturingDate="" RevisionNo=""/>
            <ProductItems>
                <ProductItem ItemID="" Quantity="" UnitOfMeasure=""/>
            </ProductItems>
            <OrderLineReservations>
                <OrderLineReservation BatchNo="" DemandType=""
                    ItemID="Required" LotNumber="" Node="Required"
                    ProductClass="" Quantity="Required"
                    RequestedReservationDate="" ReservationID=""
                    RevisionNo="" UnitOfMeasure=""/>
            </OrderLineReservations>
            <Promotions Reset="N">
                <Promotion Action="" DenialReason=""
                    OverrideAdjustmentValue="" PromotionApplied=""
                    PromotionId="" PromotionType=""/>
            </Promotions>
            <Awards>
                <Award Action="" AwardAmount="" AwardApplied=""
                    AwardId="" AwardType="" ChargeCategory=""
                    ChargeName="" DenialReason="" Description=""
                    PosReasonCode="" PromotionId=""/>
            </Awards>
            <Notes>
                <Note AuditTransactionId="" ContactReference=""
                    ContactTime="" ContactType="" ContactUser=""
                    CustomerSatIndicator="" NoteText="Required"
                    Priority="" ReasonCode="" SequenceNo="" VisibleToAll=""/>
            </Notes>
            <BundleParentLine OrderLineKey="" PrimeLineNo=""
                SubLineNo="" TransactionalLineId=""/>
            <OrderHoldTypes>
                <OrderHoldType HoldType="Required" ReasonText=""/>
            </OrderHoldTypes>
            <OrderOverride QuantityLimitOverridden="" ValidateItem=""/>
        </OrderLine>
    </OrderLines>
    <ProductServiceAssocs>
        <ProductServiceAssoc>
            <ProductLine OrderLineKey="" PrimeLineNo="" SubLineNo="" TransactionalLineId=""/>
            <ServiceLine OrderLineKey="" PrimeLineNo="" SubLineNo="" TransactionalLineId=""/>
        </ProductServiceAssoc>
    </ProductServiceAssocs>
    <OrderLineRelationships>
        <OrderLineRelationship RelationshipType="Required">
            <ParentLine OrderLineKey="" PrimeLineNo="" SubLineNo="" TransactionalLineId=""/>
            <ChildLine OrderLineKey="" PrimeLineNo="" SubLineNo="" TransactionalLineId=""/>
        </OrderLineRelationship>
    </OrderLineRelationships>
    <Notes>
        <Note AuditTransactionId="" ContactReference="" ContactTime=""
            ContactType="" ContactUser="" CustomerSatIndicator=""
            NoteText="Required" Priority="" ReasonCode="" SequenceNo="" VisibleToAll=""/>
    </Notes>
    <Instructions>
        <Instruction InstructionText="Required" InstructionType=""
            InstructionURL="" SequenceNo=""/>
    </Instructions>
    <!--Optional-->
    <PersonInfoShipTo AddressID="" AddressLine1="" AddressLine2=""
        AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6=""
        AlternateEmailID="" Beeper="" City="" Company="" Country=""
        DayFaxNo="" DayPhone="" Department="" EMailID="" EveningFaxNo=""
        EveningPhone="" FirstName="" IsCommercialAddress="" JobTitle=""
        LastName="" MiddleName="" MobilePhone="" OtherPhone=""
        PersonID="" State="" Suffix="" TaxGeoCode="" Title="" ZipCode=""/>
    <!--Optional for Draft Order else Mandatory at header level-->
    <PersonInfoBillTo AddressID="" AddressLine1="" AddressLine2=""
        AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6=""
        AlternateEmailID="" Beeper="" City="" Company="" Country=""
        DayFaxNo="" DayPhone="" Department="" EMailID="" EveningFaxNo=""
        EveningPhone="" FirstName="" IsCommercialAddress="" JobTitle=""
        LastName="" MiddleName="" MobilePhone="" OtherPhone=""
        PersonID="" State="" Suffix="" TaxGeoCode="" Title="" ZipCode=""/>
    <PersonInfoMarkFor AddressID="" AddressLine1="" AddressLine2=""
        AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6=""
        AlternateEmailID="" Beeper="" City="" Company="" Country=""
        DayFaxNo="" DayPhone="" Department="" EMailID="" EveningFaxNo=""
        EveningPhone="" FirstName="" IsCommercialAddress="" JobTitle=""
        LastName="" MiddleName="" MobilePhone="" OtherPhone=""
        PersonID="" State="" Suffix="" TaxGeoCode="" Title="" ZipCode=""/>
    <PersonInfoContact AddressID="" AddressLine1="" AddressLine2=""
        AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6=""
        AlternateEmailID="" Beeper="" City="" Company="" Country=""
        DayFaxNo="" DayPhone="" Department="" EMailID="" EveningFaxNo=""
        EveningPhone="" FirstName="" IsCommercialAddress="" JobTitle=""
        LastName="" MiddleName="" MobilePhone="" OtherPhone=""
        PersonID="" State="" Suffix="" TaxGeoCode="" Title="" ZipCode=""/>
    <AdditionalAddresses>
        <AdditionalAddress AddressType="Required">
            <!--  Additional Address description is in previous instance. Do not place a description here. -->
            <PersonInfo AddressID="" AddressLine1="" AddressLine2=""
                AddressLine3="" AddressLine4="" AddressLine5=""
                AddressLine6="" AlternateEmailID="" Beeper="" City=""
                Company="" Country="" DayFaxNo="" DayPhone=""
                Department="" EMailID="" EveningFaxNo="" EveningPhone=""
                FirstName="" IsCommercialAddress="" JobTitle=""
                LastName="" MiddleName="" MobilePhone="" OtherPhone=""
                PersonID="" State="" Suffix="" TaxGeoCode="" Title="" ZipCode=""/>
        </AdditionalAddress>
    </AdditionalAddresses>
    <PriceInfo Currency="" EnterpriseCurrency=""
        ReportingConversionDate="" ReportingConversionRate=""/>
    <HeaderCharges>
        <HeaderCharge ChargeAmount="" ChargeCategory="Required"
            ChargeName="" Reference=""/>
    </HeaderCharges>
    <HeaderTaxes>
        <HeaderTax ChargeCategory="" ChargeName="" Reference1=""
            Reference2="" Reference3="" Tax="" TaxName="Required"
            TaxPercentage="" TaxableFlag=""/>
    </HeaderTaxes>
    <References>
        <Reference Name="Required" Value=""/>
    </References>
    <PaymentMethods>
        <PaymentMethod BillToKey="" ChargeSequence="" CheckNo=""
            CheckReference="" CreditCardExpDate="" CreditCardName=""
            CreditCardNo="" CreditCardType="" CustomerAccountNo=""
            CustomerPONo="" DisplayCreditCardNo=""
            DisplayCustomerAccountNo="" DisplayPaymentReference1=""
            DisplaySvcNo="" FirstName="" LastName="" MaxChargeLimit=""
            MiddleName="" PaymentReference1="" PaymentReference2=""
            PaymentReference3="" PaymentType="Required" SvcNo="" UnlimitedCharges="">
            <PaymentDetails AuditTransactionId="" AuthAvs="" AuthCode=""
                AuthReturnCode="" AuthReturnFlag="" AuthReturnMessage=""
                AuthTime="" AuthorizationExpirationDate=""
                AuthorizationID="" CVVAuthCode="" ChargeType="Required"
                CollectionDate="" HoldAgainstBook=""
                InternalReturnCode="" InternalReturnFlag=""
                InternalReturnMessage="" ProcessedAmount=""
                Reference1="" Reference2="" RequestAmount=""
                RequestId="" RequestProcessed="" TranRequestTime=""
                TranReturnCode="" TranReturnFlag="" TranReturnMessage="" TranType=""/>
            <PaymentDetailsList>
                <PaymentDetails AuditTransactionId="" AuthAvs=""
                    AuthCode="" AuthReturnCode="" AuthReturnFlag=""
                    AuthReturnMessage="" AuthTime=""
                    AuthorizationExpirationDate="" AuthorizationID=""
                    CVVAuthCode="" ChargeType="Required"
                    CollectionDate="" HoldAgainstBook=""
                    InternalReturnCode="" InternalReturnFlag=""
                    InternalReturnMessage="" ProcessedAmount=""
                    Reference1="" Reference2="" RequestAmount=""
                    RequestId="" RequestProcessed="" TranRequestTime=""
                    TranReturnCode="" TranReturnFlag=""
                    TranReturnMessage="" TranType=""/>
            </PaymentDetailsList>
            <PersonInfoBillTo AddressID="" AddressLine1=""
                AddressLine2="" AddressLine3="" AddressLine4=""
                AddressLine5="" AddressLine6="" AlternateEmailID=""
                Beeper="" City="" Company="" Country="" DayFaxNo=""
                DayPhone="" Department="" EMailID="" EveningFaxNo=""
                EveningPhone="" FirstName="" IsAddressVerified=""
                IsCommercialAddress="" JobTitle="" LastName=""
                Latitude="" Longitude="" MiddleName="" MobilePhone=""
                OtherPhone="" PersonID="" PersonInfoKey="" State=""
                Suffix="" TaxGeoCode="" Title="" ZipCode=""/>
        </PaymentMethod>
    </PaymentMethods>
    <OrderDates>
        <OrderDate ActualDate="" CommittedDate="" DateTypeId="Required"
            ExpectedDate="" RequestedDate=""/>
    </OrderDates>
    <SpecialServices>
        <SpecialService SpecialServicesCode=""/>
    </SpecialServices>
    <OrderHoldTypes>
        <OrderHoldType HoldType="Required" ReasonText=""/>
    </OrderHoldTypes>
    <AnswerSets>
        <AnswerSet PersonInfoKey="" QuestionType="Required">
            <Answers>
                <Answer AnswerValue="" QuestionID=""/>
            </Answers>
        </AnswerSet>
    </AnswerSets>
    <Promotions Reset="N">
        <Promotion Action="" DenialReason="" OverrideAdjustmentValue=""
            PromotionApplied="" PromotionGroup="" PromotionId="" PromotionType=""/>
    </Promotions>
    <Awards>
        <Award Action="" AwardAmount="" AwardApplied="" AwardId=""
            AwardType="" ChargeCategory="" ChargeName="" DenialReason=""
            Description="" PosReasonCode="" PromotionId=""/>
    </Awards>
    <PersonInfoSoldTo AddressID="" AddressLine1="" AddressLine2=""
        AddressLine3="" AddressLine4="" AddressLine5="" AddressLine6=""
        AlternateEmailID="" Beeper="" City="" Company="" Country=""
        DayFaxNo="" DayPhone="" Department="" EMailID="" EveningFaxNo=""
        EveningPhone="" FirstName="" IsAddressVerified=""
        IsCommercialAddress="" JobTitle="" LastName="" Latitude=""
        Longitude="" MiddleName="" MobilePhone="" OtherPhone=""
        PersonID="" PersonInfoKey="" State="" Suffix="" TaxGeoCode=""
        Title="" ZipCode=""/>
    <OrderTags>
        <OrderTag TagId="" TagType=""/>
    </OrderTags>
    <Opportunity BillToID="" BuyerContactAddressKey=""
        BuyerOrganizationCode="" CoOwnerUserID="" CurrencyValue=""
        CustomerContactID="" Description="" DocumentType=""
        EnterpriseCode="Required" ExpectedCloseDate="" LeadOrigin=""
        LostReasonCode="" OpportunityDate="" OpportunityID=""
        OpportunityName="" OwnerUserID="" PipelineKey=""
        ProbableSuccessRate="" TeamCode="">
        <BuyerContactAddress AddressID="" AddressLine1=""
            AddressLine2="" AddressLine3="" AddressLine4=""
            AddressLine5="" AddressLine6="" AlternateEmailID=""
            Beeper="" City="" Company="" Country="" DayFaxNo=""
            DayPhone="" Department="" EMailID="" EveningFaxNo=""
            EveningPhone="" FirstName="" IsAddressVerified=""
            IsCommercialAddress="" JobTitle="" LastName="" Latitude=""
            Longitude="" MiddleName="" MobilePhone="" OtherPhone=""
            PersonID="" PersonInfoKey="" State="" Suffix=""
            TaxGeoCode="" Title="" ZipCode=""/>
        <Notes>
            <Note AuditTransactionId="" ContactReference=""
                ContactTime="" ContactType="" ContactUser=""
                CustomerSatIndicator="" NoteText="Required" Priority=""
                ReasonCode="" SequenceNo="" Tranid="" VisibleToAll=""/>
        </Notes>
    </Opportunity>
</Order>
eos


ORDER_DETAILS = <<eos
<Order ApproverUserID="" DocumentType="" EnterpriseCode=""
    GetFundsAvailable="" IgnorePendingChanges="" OrderHeaderKey="" OrderNo=""/>
eos

SCHEDULE_ORDER = <<eos
  <ScheduleOrder AllocationRuleID="" CheckInventory="Y" DocumentType=""
  EnterpriseCode="" IgnoreMinNotificationTime="Y" IgnoreReleaseDate=""
  IgnoreTransactionDependencies="Y" MaximumRecords=""
  OptimizationType="" OrderHeaderKey="" OrderLineKey="" OrderNo=""
  PrimeLineNo="" ScheduleAndRelease="" SubLineNo=""/>
eos


RELEASE_ORDER = <<eos
<ReleaseOrder AllocationRuleID="" CheckInventory="" DocumentType=""
    EnterpriseCode="" IgnoreReleaseDate=""
    IgnoreTransactionDependencies="Y" OrderHeaderKey="" OrderNo=""/>
eos

#  Currently only used for Trigger Payment Collection
MULTI_API = <<eos
<MultiApi>
    <!-- There can be one or more api elements -->
    <!-- Version attribute is optional, Optional values are "ver45", "ver40" -->
    <API FlowName="" IsExtendedDbApi="" Name="" Version="">
        <!-- The Input element must contain a child element that corresponds to
 the document element of the api input -->
        <Input>
          <TriggerAgent CriteriaId=""/>
        </Input>
        <!-- The Template element (if given) may contain a child element that corresponds to
 the document element of the template to use for the API call -->
        <Template/>
    </API>
</MultiApi>
eos

INF_SHIPPED_UPDATE = <<eos
<OrderLineStatus ActualShipmentDate="2015-02-25T13:25:34.993" DocumentType="0001" EnterpriseCode="GS_US" OrderNo="104216157" ReleaseNo="1" CarrierServiceCode="GR" >
  <Containers>
    <Container>
      <ContainerDetails>
        <ContainerDetail>
          <ShipmentLine DocumentType="0001" OrderNo="104216157" PrimeLineNo="1" ReleaseNo="1" SubLineNo="1" ></ShipmentLine>
        </ContainerDetail>
      </ContainerDetails>
    </Container>
  </Containers>
  <ShipmentCharges ActualCharge="0" ChargeCategory="Handling" ></ShipmentCharges>
  <ShipmentLines>
    <ShipmentLine OrderNo="104216157" PrimeLineNo="1" Quantity="1" ReleaseNo="1" SubLineNo="1" ></ShipmentLine>
  </ShipmentLines>
</OrderLineStatus>
eos

end