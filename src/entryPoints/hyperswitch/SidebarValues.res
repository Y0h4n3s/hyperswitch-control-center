open SidebarTypes
open PermissionUtils

// * Custom Component

module GetProductionAccess = {
  @react.component
  let make = () => {
    let mixpanelEvent = MixpanelHook.useSendEvent()
    let textStyles = HSwitchUtils.getTextClass(~textVariant=P2, ~paragraphTextVariant=Medium, ())
    let {isProdIntentCompleted, setShowProdIntentForm} = React.useContext(
      GlobalProvider.defaultContext,
    )
    let backgroundColor = isProdIntentCompleted ? "bg-light_green" : "bg-light_blue"
    let cursorStyles = isProdIntentCompleted ? "cursor-default" : "cursor-pointer"
    let productionAccessString = isProdIntentCompleted
      ? "Production Access Requested"
      : "Get Production Access"

    <div
      className={`flex items-center gap-2 ${backgroundColor} ${cursorStyles} px-4 py-3 m-2 ml-2 mb-3 !mx-4 whitespace-nowrap rounded`}
      onClick={_ => {
        isProdIntentCompleted
          ? ()
          : {
              setShowProdIntentForm(_ => true)
              mixpanelEvent(~eventName="get_production_access", ())
            }
      }}>
      <div className={`text-white ${textStyles} !font-semibold`}>
        {productionAccessString->React.string}
      </div>
      <UIUtils.RenderIf condition={!isProdIntentCompleted}>
        <Icon name="thin-right-arrow" customIconColor="white" size=20 />
      </UIUtils.RenderIf>
    </div>
  }
}

let emptyComponent = CustomComponent({
  component: React.null,
})

let productionAccessComponent = isProductionAccessEnabled =>
  isProductionAccessEnabled
    ? CustomComponent({
        component: <GetProductionAccess />,
      })
    : emptyComponent

// * Main Features

let home = isHomeEnabled =>
  isHomeEnabled
    ? Link({
        name: "Home",
        icon: "kd_desktop", //custom solid
        link: "/home",
        access: Access,
      })
    : emptyComponent

let payments = permissionJson => {
  SubLevelLink({
    name: "Payments",
    link: `/payments`,
    access: permissionJson.paymentRead,
    searchOptions: [("View payment operations", "")],
  })
}

let refunds = permissionJson => {
  SubLevelLink({
    name: "Refunds",
    link: `/refunds`,
    access: permissionJson.refundRead,
    searchOptions: [("View refund operations", "")],
  })
}

let disputes = permissionJson => {
  SubLevelLink({
    name: "Disputes",
    link: `/disputes`,
    access: permissionJson.disputeRead,
    searchOptions: [("View dispute operations", "")],
  })
}

let customers = permissionJson => {
  SubLevelLink({
    name: "Customers",
    link: `/customers`,
    access: permissionJson.customerRead,
    searchOptions: [("View customers", "")],
  })
}

let operations = (isOperationsEnabled, customersModule, ~permissionJson) => {
  let payments = payments(permissionJson)
  let refunds = refunds(permissionJson)
  let disputes = disputes(permissionJson)
  let customers = customers(permissionJson)

  isOperationsEnabled
    ? Section({
        name: "Operations",
        icon: "kd_control",
        showSection: true,
        links: customersModule
          ? [payments, refunds, disputes, customers]
          : [payments, refunds, disputes],
      })
    : emptyComponent
}

let connectors = (isConnectorsEnabled, isLiveMode, ~permissionJson) => {
  isConnectorsEnabled
    ? Link({
        name: "Processors",
        link: `/connectors`,
        icon: "kd_chip",
        access: permissionJson.merchantConnectorAccountRead,
        searchOptions: HSwitchUtils.getSearchOptionsForProcessors(
          ~processorList=isLiveMode
            ? ConnectorUtils.connectorListForLive
            : ConnectorUtils.connectorList,
          ~getNameFromString=ConnectorUtils.getConnectorNameString,
        ),
      })
    : emptyComponent
}

let paymentAnalytcis = SubLevelLink({
  name: "Payments",
  link: `/analytics-payments`,
  access: Access,
  searchOptions: [("View analytics", "")],
})

let refundAnalytics = SubLevelLink({
  name: "Refunds",
  link: `/analytics-refunds`,
  access: Access,
  searchOptions: [("View analytics", "")],
})

let userJourneyAnalytics = SubLevelLink({
  name: "User Journey",
  link: `/analytics-user-journey`,
  access: Access,
  iconTag: "betaTag",
  searchOptions: [("View analytics", "")],
})

let analytics = (isAnalyticsEnabled, userJourneyAnalyticsFlag, ~permissionJson) => {
  isAnalyticsEnabled
    ? Section({
        name: "Analytics",
        icon: "kd_analytics",
        showSection: permissionJson.analytics === Access,
        links: userJourneyAnalyticsFlag
          ? [paymentAnalytcis, refundAnalytics, userJourneyAnalytics]
          : [paymentAnalytcis, refundAnalytics],
      })
    : emptyComponent
}
let routing = permissionJson => {
  SubLevelLink({
    name: "Routing",
    link: `/routing`,
    access: permissionJson.routingRead,
    searchOptions: [
      ("Manage default routing configuration", "/default"),
      ("Create new volume based routing", "/volume"),
      ("Create new rule based routing", "/rule"),
      ("Manage smart routing", ""),
    ],
  })
}

let threeDs = permissionJson => {
  SubLevelLink({
    name: "3DS Decision Manager",
    link: `/3ds`,
    access: permissionJson.threeDsDecisionManagerRead,
    searchOptions: [("Configure 3ds", "")],
  })
}
let surcharge = permissionJson => {
  SubLevelLink({
    name: "Surcharge",
    link: `/surcharge`,
    access: permissionJson.surchargeDecisionManagerRead,
    searchOptions: [("Add Surcharge", "")],
  })
}

let workflow = (isWorkflowEnabled, isSurchargeEnabled, ~permissionJson) => {
  let routing = routing(permissionJson)
  let threeDs = threeDs(permissionJson)
  let surcharge = surcharge(permissionJson)

  isWorkflowEnabled
    ? Section({
        name: "Workflow",
        icon: "kd_work",
        showSection: true,
        links: isSurchargeEnabled ? [routing, threeDs, surcharge] : [routing, threeDs],
      })
    : emptyComponent
}

let userManagement = permissionJson => {
  SubLevelLink({
    name: "Team",
    link: `/users`,
    access: permissionJson.usersRead,
    searchOptions: [("View team management", "")],
  })
}

let accountSettings = permissionJson => {
  // Because it has delete sample data

  SubLevelLink({
    name: "Account Settings",
    link: `/account-settings`,
    access: permissionJson.merchantAccountWrite,
    searchOptions: [
      ("View profile", "/profile"),
      ("Change password", "/profile"),
      ("Manage your personal profile and preferences", "/profile"),
    ],
  })
}

let businessDetails = permissionJson => {
  SubLevelLink({
    name: "Business Details",
    link: `/business-details`,
    access: permissionJson.merchantAccountRead,
    searchOptions: [("Configure business details", "")],
  })
}

let businessProfiles = permissionJson => {
  SubLevelLink({
    name: "Business Profiles",
    link: `/business-profiles`,
    access: permissionJson.merchantAccountRead,
    searchOptions: [("Configure business profiles", "")],
  })
}
let settings = (
  ~isSampleDataEnabled,
  ~isUserManagementEnabled,
  ~isBusinessProfileEnabled,
  ~permissionJson,
) => {
  let settingsLinkArray = [businessDetails(permissionJson)]

  if isBusinessProfileEnabled {
    settingsLinkArray->Array.push(businessProfiles(permissionJson))->ignore
  }
  if isSampleDataEnabled {
    settingsLinkArray->Array.push(accountSettings(permissionJson))->ignore
  }
  if isUserManagementEnabled {
    settingsLinkArray->Array.push(userManagement(permissionJson))->ignore
  }

  Section({
    name: "Settings",
    icon: "kd_setting",
    showSection: true,
    links: settingsLinkArray,
  })
}

let apiKeys = permissionJson => {
  SubLevelLink({
    name: "API Keys",
    link: `/developer-api-keys`,
    access: permissionJson.apiKeyRead,
    searchOptions: [("View API Keys", "")],
  })
}

let systemMetric = permissionJson => {
  SubLevelLink({
    name: "System Metrics",
    link: `/developer-system-metrics`,
    access: permissionJson.analytics,
    iconTag: "betaTag",
    searchOptions: [("View System Metrics", "")],
  })
}

let paymentSettings = permissionJson => {
  SubLevelLink({
    name: "Payment Settings",
    link: `/payment-settings`,
    access: permissionJson.merchantAccountRead,
    searchOptions: [("View payment settings", ""), ("View webhooks", ""), ("View return url", "")],
  })
}

let developers = (isDevelopersEnabled, userRole, systemMetrics, ~permissionJson) => {
  let isInternalUser = userRole->String.includes("internal_")
  let apiKeys = apiKeys(permissionJson)
  let paymentSettings = paymentSettings(permissionJson)
  let systemMetric = systemMetric(permissionJson)

  isDevelopersEnabled
    ? Section({
        name: "Developers",
        icon: "kd_dev",
        showSection: true,
        links: isInternalUser && systemMetrics
          ? [apiKeys, paymentSettings, systemMetric]
          : [apiKeys, paymentSettings],
      })
    : emptyComponent
}

let fraudAndRisk = (isfraudAndRiskEnabled, ~permissionJson) => {
  isfraudAndRiskEnabled
    ? Link({
        name: "Fraud & Risk",
        icon: "shield-alt",
        link: `/fraud-risk-management`,
        access: permissionJson.merchantConnectorAccountRead,
        searchOptions: [],
      })
    : emptyComponent
}

let payoutConnectors = (isPayoutConnectorsEnabled, ~permissionJson) => {
  isPayoutConnectorsEnabled
    ? Link({
        name: "Payout Processors",
        link: `/payoutconnectors`,
        icon: "connectors",
        access: permissionJson.merchantConnectorAccountRead,
        searchOptions: HSwitchUtils.getSearchOptionsForProcessors(
          ~processorList=ConnectorUtils.payoutConnectorList,
          ~getNameFromString=ConnectorUtils.getConnectorNameString,
        ),
      })
    : emptyComponent
}

let reconTag = (recon, isReconEnabled) =>
  recon
    ? Link({
        name: "Reconcilation",
        icon: isReconEnabled ? "recon" : "recon-lock",
        link: `/recon`,
        access: Access,
      })
    : emptyComponent

let useGetSidebarValues = (~isReconEnabled: bool) => {
  let userRole = HSLocalStorage.getFromUserDetails("user_role")
  let featureFlagDetails = HyperswitchAtom.featureFlagAtom->Recoil.useRecoilValueFromAtom
  let permissionJson = Recoil.useRecoilValueFromAtom(HyperswitchAtom.userPermissionAtom)

  let {
    productionAccess,
    frm,
    payOut,
    recon,
    default,
    userManagement,
    sampleData,
    businessProfile,
    systemMetrics,
    userJourneyAnalytics: userJourneyAnalyticsFlag,
    surcharge: isSurchargeEnabled,
    isLiveMode,
    customersModule,
  } = featureFlagDetails

  let sidebar = [
    productionAccess->productionAccessComponent,
    default->home,
    default->operations(customersModule, ~permissionJson),
    default->analytics(userJourneyAnalyticsFlag, ~permissionJson),
    default->connectors(isLiveMode, ~permissionJson),
    default->workflow(isSurchargeEnabled, ~permissionJson),
    frm->fraudAndRisk(~permissionJson),
    payOut->payoutConnectors(~permissionJson),
    recon->reconTag(isReconEnabled),
    default->developers(userRole, systemMetrics, ~permissionJson),
    settings(
      ~isUserManagementEnabled=userManagement,
      ~isBusinessProfileEnabled=businessProfile,
      ~isSampleDataEnabled=sampleData,
      ~permissionJson,
    ),
  ]
  sidebar
}
