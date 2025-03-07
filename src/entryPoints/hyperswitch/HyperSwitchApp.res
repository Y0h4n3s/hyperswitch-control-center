@react.component
let make = () => {
  open UIUtils
  open HSwitchUtils
  open HSwitchGlobalVars
  open APIUtils
  open PermissionUtils
  open LogicUtils

  let url = RescriptReactRouter.useUrl()
  let fetchDetails = useGetMethod()
  let {
    showFeedbackModal,
    setShowFeedbackModal,
    dashboardPageState,
    setDashboardPageState,
    setQuickStartPageState,
    isProdIntentCompleted,
  } = React.useContext(GlobalProvider.defaultContext)
  let (screenState, setScreenState) = React.useState(_ => PageLoaderWrapper.Loading)
  let fetchBusinessProfiles = MerchantAccountUtils.useFetchBusinessProfiles()
  let fetchMerchantAccountDetails = MerchantAccountUtils.useFetchMerchantDetails()
  let fetchConnectorListResponse = ConnectorUtils.useFetchConnectorList()
  let enumDetails =
    HyperswitchAtom.enumVariantAtom
    ->Recoil.useRecoilValueFromAtom
    ->safeParse
    ->QuickStartUtils.getTypedValueFromDict

  let featureFlagDetails = HyperswitchAtom.featureFlagAtom->Recoil.useRecoilValueFromAtom
  let (userPermissionJson, setuserPermissionJson) = Recoil.useRecoilState(
    HyperswitchAtom.userPermissionAtom,
  )
  let getEnumDetails = EnumVariantHook.useFetchEnumDetails()
  let verificationDays = HSLocalStorage.getFromMerchantDetails("verification")->getIntFromString(-1)
  let userRole = HSLocalStorage.getFromUserDetails("user_role")
  let modeText = featureFlagDetails.isLiveMode ? "Live Mode" : "Test Mode"
  let modeStyles = featureFlagDetails.isLiveMode
    ? "bg-hyperswitch_green_trans border-hyperswitch_green_trans text-hyperswitch_green"
    : "bg-orange-600/80 border-orange-500 text-grey-700"

  let merchantDetailsValue = useMerchantDetailsValue()
  let isReconEnabled =
    (merchantDetailsValue->MerchantAccountUtils.getMerchantDetails).recon_status === Active

  let hyperSwitchAppSidebars = SidebarValues.useGetSidebarValues(~isReconEnabled)

  sessionExpired := false

  let getAgreementEnum = async () => {
    try {
      let url = #ProductionAgreement->ProdOnboardingUtils.getProdOnboardingUrl
      let response = await fetchDetails(url)

      let productionAgreementResponse =
        response
        ->getArrayFromJson([])
        ->Array.find(ele => {
          ele->getDictFromJsonObject->getBool("ProductionAgreement", false)
        })
        ->Option.getWithDefault(Js.Json.null)

      if productionAgreementResponse->getDictFromJsonObject->getBool("ProductionAgreement", false) {
        setDashboardPageState(_ => #PROD_ONBOARDING)
      } else {
        setDashboardPageState(_ => #AGREEMENT_SIGNATURE)
      }
    } catch {
    | _ =>
      setDashboardPageState(_ => #HOME)
      setScreenState(_ => PageLoaderWrapper.Success)
    }
  }

  let fetchInitialEnums = async () => {
    try {
      let response = await getEnumDetails(QuickStartUtils.quickStartEnumIntialArray)
      let responseValueDict = response->Js.Nullable.toOption->Option.getWithDefault(Dict.make())
      let pageStateToSet = responseValueDict->QuickStartUtils.getCurrentStep
      setQuickStartPageState(_ => pageStateToSet->QuickStartUtils.enumToVarinatMapper)
      responseValueDict
    } catch {
    | Js.Exn.Error(e) => {
        let err = Js.Exn.message(e)->Option.getWithDefault("Failed to Fetch!")
        Js.Exn.raiseError(err)
      }
    }
  }

  let fetchPermissions = async () => {
    try {
      let url = getURL(~entityName=USERS, ~userType=#GET_PERMISSIONS, ~methodType=Get, ())
      let response = await fetchDetails(url)
      let permissionsValue =
        response
        ->getArrayFromJson([])
        ->Array.map(ele => ele->Js.Json.decodeString->Option.getWithDefault(""))
      let permissionJson =
        permissionsValue->Array.map(ele => ele->mapStringToPermissionType)->getPermissionJson
      setuserPermissionJson(._ => permissionJson)
    } catch {
    | Js.Exn.Error(e) => {
        let err = Js.Exn.message(e)->Option.getWithDefault("Failed to Fetch!")
        Js.Exn.raiseError(err)
      }
    }
  }

  let setUpDashboard = async () => {
    try {
      if featureFlagDetails.permissionBasedModule {
        let _ = await fetchPermissions()
      }
      Js.log(window)
      if userPermissionJson.merchantConnectorAccountRead === Access {
        let _ = await Window.connectorWasmInit()
        let _ = await fetchConnectorListResponse()
      }

      if userPermissionJson.merchantAccountRead === Access {
        let _ = await fetchBusinessProfiles()
        let _ = await fetchMerchantAccountDetails()
      }

      if featureFlagDetails.quickStart {
        let _ = await fetchInitialEnums()
      }

      if featureFlagDetails.isLiveMode {
        getAgreementEnum()->ignore
      } else {
        setDashboardPageState(_ => #HOME)
      }

      setScreenState(_ => PageLoaderWrapper.Success)
    } catch {
    | _ =>
      setDashboardPageState(_ => #HOME)
      setScreenState(_ => PageLoaderWrapper.Error(""))
    }
  }

  React.useEffect0(() => {
    setUpDashboard()->ignore
    None
  })

  let determineStripePlusPayPal = () => {
    enumDetails->checkStripePlusPayPal
      ? RescriptReactRouter.replace("/home")
      : setDashboardPageState(_ => #STRIPE_PLUS_PAYPAL)

    React.null
  }

  let determineWooCommerce = () => {
    enumDetails->checkWooCommerce
      ? RescriptReactRouter.replace("/home")
      : setDashboardPageState(_ => #WOOCOMMERCE_FLOW)

    React.null
  }

  let determineQuickStartPageState = () => {
    isProdIntentCompleted &&
    enumDetails.integrationCompleted &&
    !(enumDetails.testPayment.payment_id->isEmptyString)
      ? RescriptReactRouter.replace("/home")
      : setDashboardPageState(_ => #QUICK_START)

    React.null
  }

  <PageLoaderWrapper screenState={screenState} sectionHeight="!h-screen">
    <div>
      {switch dashboardPageState {
      | #POST_LOGIN_QUES_NOT_DONE => <PostLoginScreen />
      | #AUTO_CONNECTOR_INTEGRATION => <HSwitchSetupAccount />
      | #INTEGRATION_DOC => <UserOnboarding />
      | #AGREEMENT_SIGNATURE => <HSwitchAgreementScreen />
      | #PROD_ONBOARDING => <ProdOnboardingLanding />
      | #QUICK_START => <ConfigureControlCenter />
      | #HOME =>
        <div className="relative">
          <div className={`h-screen flex flex-col`}>
            //            <div className="flex relative overflow-auto h-screen">
            <div
              className="flex relative flex-col flex-1 overflow-hidden bg-jp-gray-50 dark:bg-black overflow-scroll md:overflow-x-hidden">
              <RenderIf condition={verificationDays > 0}>
                <DelayedVerificationBanner verificationDays={verificationDays} />
              </RenderIf>
              // TODO : To be removed after new navbar design
              <div className="border-b shadow-hyperswitch_box_shadow bg-white">
                <div className="w-full max-w-fixedPageWidth px-20">
                  <Navbar
                    headerActions={<div className="relative flex items-center gap-80">
                      <Icon
                        customWidth={"100"} customHeight={"50"} name="keoslogo" className="mb-8"
                      />
                      <HSwitchGlobalSearchBar />
                      <div className="flex gap-4">
                        <RenderIf condition={featureFlagDetails.switchMerchant}>
                          <SwitchMerchant userRole={userRole} isAddMerchantEnabled=true />
                        </RenderIf>
                        <div
                          className={`px-4 py-2 rounded whitespace-nowrap text-fs-13 ${modeStyles} font-semibold`}>
                          {modeText->React.string}
                        </div>
                      </div>
                    </div>}
                  />
                </div>
              </div>
              //sidebar and page
              <div className="flex relative overflow-auto h-screen">
                <div className="flex overflow-auto h-full">
                  <Sidebar path={url.path} sidebars={hyperSwitchAppSidebars} />
                </div>
                <div
                  className="w-full h-screen overflow-x-scroll xl:overflow-x-hidden overflow-y-scroll">
                  <div
                    className="p-6 md:px-16 md:pb-16 pt-[3rem] flex flex-col gap-10 max-w-fixedPageWidth">
                    <ErrorBoundary>
                      {switch url.path {
                      | list{"home"} => featureFlagDetails.quickStart ? <HomeV2 /> : <Home />
                      | list{"fraud-risk-management", ...remainingPath} =>
                        <AccessControl
                          isEnabled={featureFlagDetails.frm}
                          permission=userPermissionJson.merchantAccountRead>
                          <EntityScaffold
                            entityName="risk-management"
                            remainingPath
                            renderList={() => <FRMSelect />}
                            renderNewForm={() => <FRMConfigure />}
                            renderShow={_ => <FRMConfigure />}
                          />
                        </AccessControl>
                      | list{"connectors", ...remainingPath} =>
                        <AccessControl permission=userPermissionJson.merchantAccountRead>
                          <EntityScaffold
                            entityName="Connectors"
                            remainingPath
                            renderList={() => <ConnectorList />}
                            renderNewForm={() => <ConnectorHome />}
                            renderShow={_ => <ConnectorHome />}
                          />
                        </AccessControl>
                      | list{"payoutconnectors", ...remainingPath} =>
                        <AccessControl
                          isEnabled={featureFlagDetails.payOut}
                          permission=userPermissionJson.merchantAccountRead>
                          <EntityScaffold
                            entityName="PayoutConnectors"
                            remainingPath
                            renderList={() => <ConnectorList isPayoutFlow=true />}
                            renderNewForm={() => <ConnectorHome isPayoutFlow=true />}
                            renderShow={_ => <ConnectorHome isPayoutFlow=true />}
                          />
                        </AccessControl>
                      | list{"payments", ...remainingPath} =>
                        <AccessControl permission=userPermissionJson.paymentRead>
                          <FilterContext key="payments" index="payments" disableSessionStorage=true>
                            <EntityScaffold
                              entityName="Payments"
                              remainingPath
                              access=Access
                              renderList={() => <Orders />}
                              renderShow={id => <ShowOrder id />}
                            />
                          </FilterContext>
                        </AccessControl>
                      | list{"refunds", ...remainingPath} =>
                        <AccessControl permission=userPermissionJson.refundRead>
                          <FilterContext key="refunds" index="refunds" disableSessionStorage=true>
                            <EntityScaffold
                              entityName="Refunds"
                              remainingPath
                              access=Access
                              renderList={() => <Refund />}
                              renderShow={id => <ShowRefund id />}
                            />
                          </FilterContext>
                        </AccessControl>
                      | list{"disputes", ...remainingPath} =>
                        <AccessControl permission=userPermissionJson.disputeRead>
                          <EntityScaffold
                            entityName="Disputes"
                            remainingPath
                            access=Access
                            renderList={() => <Disputes />}
                            renderShow={id => <ShowDisputes id />}
                          />
                        </AccessControl>
                      | list{"customers", ...remainingPath} =>
                        <AccessControl
                          isEnabled=featureFlagDetails.customersModule
                          permission=userPermissionJson.customerRead>
                          <EntityScaffold
                            entityName="Customers"
                            remainingPath
                            access=Access
                            renderList={() => <Customers />}
                            renderShow={id => <ShowCustomers id />}
                          />
                        </AccessControl>
                      | list{"routing", ...remainingPath} =>
                        <AccessControl permission=userPermissionJson.routingRead>
                          <EntityScaffold
                            entityName="Routing"
                            remainingPath
                            renderList={() => <RoutingStack remainingPath />}
                            renderShow={routingType => <RoutingConfigure routingType />}
                          />
                        </AccessControl>
                      | list{"users", "invite-users"} =>
                        <AccessControl permission=userPermissionJson.usersWrite>
                          <InviteUsers />
                        </AccessControl>
                      | list{"users", ...remainingPath} =>
                        <AccessControl permission=userPermissionJson.usersRead>
                          <EntityScaffold
                            entityName="UserManagement"
                            remainingPath
                            access=Access
                            renderList={() => <UserRoleEntry />}
                            renderShow={_ => <UserRoleShowData />}
                          />
                        </AccessControl>
                      | list{"analytics-payments"} =>
                        <AccessControl permission=userPermissionJson.analytics>
                          <FilterContext key="PaymentsAnalytics" index="PaymentsAnalytics">
                            <PaymentAnalytics />
                          </FilterContext>
                        </AccessControl>
                      | list{"analytics-refunds"} =>
                        <AccessControl permission=userPermissionJson.analytics>
                          <FilterContext key="PaymentsRefunds" index="PaymentsRefunds">
                            <RefundsAnalytics />
                          </FilterContext>
                        </AccessControl>
                      | list{"analytics-user-journey"} =>
                        <AccessControl
                          isEnabled=featureFlagDetails.userJourneyAnalytics
                          permission=userPermissionJson.analytics>
                          <FilterContext key="UserJourneyAnalytics" index="UserJourneyAnalytics">
                            <UserJourneyAnalytics />
                          </FilterContext>
                        </AccessControl>
                      | list{"developer-api-keys"} =>
                        <AccessControl permission=userPermissionJson.apiKeyRead>
                          <KeyManagement.KeysManagement />
                        </AccessControl>
                      | list{"developer-system-metrics"} =>
                        <AccessControl
                          isEnabled={userRole->String.includes("internal_") &&
                            featureFlagDetails.systemMetrics}
                          permission=userPermissionJson.analytics>
                          <FilterContext key="SystemMetrics" index="SystemMetrics">
                            <SystemMetricsAnalytics />
                          </FilterContext>
                        </AccessControl>
                      | list{"payment-settings", ...remainingPath} =>
                        <AccessControl permission=userPermissionJson.merchantAccountRead>
                          <EntityScaffold
                            entityName="PaymentSettings"
                            remainingPath
                            renderList={() => <PaymentSettingsList />}
                            renderShow={profileId =>
                              <PaymentSettings webhookOnly=false showFormOnly=false />}
                          />
                        </AccessControl>
                      | list{"recon"} =>
                        <AccessControl isEnabled=featureFlagDetails.recon permission=Access>
                          <Recon />
                        </AccessControl>
                      | list{"sdk"} =>
                        <AccessControl isEnabled={!featureFlagDetails.isLiveMode} permission=Access>
                          <SDKPage />
                        </AccessControl>
                      | list{"3ds"} =>
                        <AccessControl permission=userPermissionJson.threeDsDecisionManagerRead>
                          <HSwitchThreeDS />
                        </AccessControl>
                      | list{"surcharge"} =>
                        <AccessControl
                          isEnabled={featureFlagDetails.surcharge}
                          permission=userPermissionJson.surchargeDecisionManagerRead>
                          <Surcharge />
                        </AccessControl>
                      | list{"account-settings"} =>
                        <AccessControl
                          isEnabled=featureFlagDetails.sampleData
                          permission=userPermissionJson.merchantAccountWrite>
                          <HSwitchSettings />
                        </AccessControl>
                      | list{"account-settings", "profile"} =>
                        <AccessControl
                          isEnabled=featureFlagDetails.sampleData
                          permission=userPermissionJson.merchantAccountWrite>
                          <HSwitchProfileSettings />
                        </AccessControl>
                      | list{"business-details"} =>
                        <AccessControl
                          isEnabled=featureFlagDetails.default
                          permission=userPermissionJson.merchantAccountRead>
                          <BusinessDetails />
                        </AccessControl>
                      | list{"business-profiles"} =>
                        <AccessControl
                          isEnabled=featureFlagDetails.businessProfile permission=Access>
                          <BusinessProfile />
                        </AccessControl>
                      | list{"quick-start"} => determineQuickStartPageState()
                      | list{"woocommerce"} => determineWooCommerce()
                      | list{"stripe-plus-paypal"} => determineStripePlusPayPal()
                      | list{"unauthorized"} => <UnauthorizedPage />
                      | _ =>
                        RescriptReactRouter.replace(`${hyperSwitchFEPrefix}/home`)
                        <Home />
                      }}
                    </ErrorBoundary>
                  </div>
                </div>
              </div>
            </div>
            <RenderIf condition={showFeedbackModal && featureFlagDetails.feedback}>
              <HSwitchFeedBackModal
                modalHeading="We'd love to hear from you!"
                showModal={showFeedbackModal}
                setShowModal={setShowFeedbackModal}
              />
            </RenderIf>
            <RenderIf
              condition={featureFlagDetails.productionAccess || featureFlagDetails.quickStart}>
              <ProdIntentForm />
            </RenderIf>
          </div>
        </div>
      | #WOOCOMMERCE_FLOW => <WooCommerce />
      | #DEFAULT =>
        <div className="h-screen flex justify-center items-center">
          <Loader />
        </div>
      | #STRIPE_PLUS_PAYPAL => <StripePlusPaypal />
      }}
    </div>
  </PageLoaderWrapper>
}