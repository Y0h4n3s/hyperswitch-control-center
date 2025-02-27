open HeadlessUI
open SidebarTypes

let defaultLinkSelectionCheck = (firstPart, tabLink) => {
  firstPart === tabLink
}

let getIconSize = buttonType => {
  switch buttonType {
  | "large" => 42
  | "larger" => 65
  | _ => 20
  }
}

module MenuOption = {
  @react.component
  let make = (~text=?, ~children=?, ~onClick=?) => {
    <button
      className={`px-4 py-3 flex text-sm w-full text-text-grey-900 cursor-pointer bg-transparent hover:bg-blue-400 hover:text-grey-850`} //bottom Nav
      ?onClick>
      {switch text {
      | Some(str) => React.string(str)
      | None => React.null
      }}
      {switch children {
      | Some(elem) => elem
      | None => React.null
      }}
    </button>
  }
}

module SidebarOption = {
  @react.component
  let make = (~isExpanded, ~name, ~icon, ~isSelected) => {
    let textBoldStyles = isSelected ? "font-normal" : "font-normal" //ntn
    let iconColor = isSelected ? "text-blue-800" : "text-grey-450 hover:text-blue-800" //icon color

    if isExpanded {
      <div className="flex items-start pr-2 gap-5">
        <Icon size={getIconSize("small")} name=icon className=iconColor />
        <div className={`text-sm ${textBoldStyles} whitespace-nowrap`}>
          //ntn
          {React.string(name)}
        </div>
      </div>
    } else {
      <Icon size={getIconSize("small")} name=icon className=iconColor />
    }
  }
}

module SidebarSubOption = {
  @react.component
  let make = (~name, ~isSectionExpanded, ~isSelected, ~children=React.null, ~isSideBarExpanded) => {
    let subOptionClass = isSelected ? "px-4" : "px-4" //suboption text width
    let alignmentClasses = children == React.null ? "" : "flex flex-row items-center"

    <div
      className={`text-fs-13 font-normal w-full hover:bg-blue-200 ${alignmentClasses} p-3 ${isSectionExpanded
          ? "transition duration-[250ms] animate-textTransitionSideBar"
          : "transition duration-[1000ms] animate-textTransitionSideBarOff"} ${isSideBarExpanded
          ? "mr-0.5"
          : "mr-0.5"}`}>
      //subOption hover is here
      <div className="w-6" />
      <div className={`${subOptionClass} w-full flex items-center whitespace-nowrap`}>
        //suboption hover bg
        {React.string(name)}
        {children}
      </div>
    </div>
  }
}

module SidebarItem = {
  @react.component
  let make = (~tabInfo, ~isSelected, ~isExpanded) => {
    let sidebarItemRef = React.useRef(Js.Nullable.null)
    let {getSearchParamByLink} = React.useContext(UserPrefContext.userPrefContext)
    let getSearchParamByLink = link => getSearchParamByLink(String.substringToEnd(link, ~start=0))

    let selectedClass = if isSelected {
      // selected border design and clicked for home and processor!
      "border-r-2 rounded-sm border-blue-950 bg-blue-200"
    } else {
      `border-r-2 rounded-sm border-transparent rounded-sm hover:transition hover:duration-300 rounded-lg`
    }

    let textColor = if isSelected {
      //text for home and processor
      "text-fs-14 font-medium text-mon-100"
    } else {
      `text-fs-14 font-normal text-grey-450 hover:text-grey-950`
    }
    let isMobileView = MatchMedia.useMobileChecker()
    let {setIsSidebarExpanded} = React.useContext(SidebarProvider.defaultContext)

    RippleEffectBackground.useHorizontalRippleHook(sidebarItemRef)

    let tabLinklement = switch tabInfo {
    | Link(tabOption) => {
        let {name, icon, link, access} = tabOption
        let redirectionLink = `${link}${getSearchParamByLink(link)}`

        <UIUtils.RenderIf condition={access !== NoAccess}>
          <Link to_=redirectionLink>
            <div
              ref={sidebarItemRef->ReactDOM.Ref.domRef}
              onClick={_ => isMobileView ? setIsSidebarExpanded(_ => false) : ()} //home&proccessor
              className={`${textColor}group relative overflow-hidden flex flex-row items-center cursor-pointer hover:bg-blue-200 ${selectedClass} p-3 ${isExpanded
                  ? "mr-2"
                  : "mr-2"}`}>
              <SidebarOption name icon isExpanded isSelected />
            </div>
          </Link>
        </UIUtils.RenderIf>
      }

    | RemoteLink(tabOption) => {
        let {name, icon, link, access, ?remoteIcon} = tabOption
        let (remoteUi, link) = if remoteIcon->Option.getWithDefault(false) {
          (<Icon name="external-link-alt" size=14 className="ml-3" />, link)
        } else {
          (React.null, `${link}${getSearchParamByLink(link)}`)
        }
        <UIUtils.RenderIf condition={access !== NoAccess}>
          <a
            href={link}
            target="_blank"
            className={`${textColor} flex flex-row items-center  cursor-pointer hover:bg-blue-200 ${selectedClass} p-3`}>
            //ntn
            <SidebarOption name icon isExpanded isSelected />
            remoteUi
          </a>
        </UIUtils.RenderIf>
      }

    | LinkWithTag(tabOption) => {
        let {name, icon, iconTag, link, access, ?iconStyles, ?iconSize} = tabOption

        <UIUtils.RenderIf condition={access !== NoAccess}>
          <Link to_={`${link}${getSearchParamByLink(link)}`}>
            <div
              onClick={_ => isMobileView ? setIsSidebarExpanded(_ => false) : ()}
              className={`${textColor} group flex flex-row items-center hover:text-grey-950 cursor-pointer transition font-normal duration-300 bg-blue-200 ${selectedClass} p-3 ${isExpanded
                  ? "mr-2"
                  : "mr-2"} `}>
              //ntn
              <SidebarOption name icon isExpanded isSelected />
              <UIUtils.RenderIf condition={isExpanded}>
                <Icon
                  size={iconSize->Option.getWithDefault(26)}
                  name=iconTag
                  className={`ml-2 ${iconStyles->Option.getWithDefault("w-26 h-26")}`}
                />
              </UIUtils.RenderIf>
            </div>
          </Link>
        </UIUtils.RenderIf>
      }

    | Heading(_) | Section(_) | CustomComponent(_) => React.null
    }

    tabLinklement
  }
}

module NestedSidebarItem = {
  @react.component
  let make = (~tabInfo, ~isSelected, ~isSideBarExpanded, ~isSectionExpanded) => {
    let {getSearchParamByLink} = React.useContext(UserPrefContext.userPrefContext)
    let getSearchParamByLink = link => getSearchParamByLink(Js.String2.substr(link, ~from=0))

    let selectedClass = if isSelected {
      // inner of suboption full bg
      "bg-blue-200"
    } else {
      ``
    }

    let textColor = if isSelected {
      // inner of suboption text
      `text-sm font-normal text-mon-100 `
    } else {
      `text-sm font-normal text-grey-450 hover:text-grey-950`
    }
    let {setIsSidebarExpanded} = React.useContext(SidebarProvider.defaultContext)
    let paddingClass = if isSideBarExpanded {
      "mr-2.5"
    } else {
      "mr-2.5"
    }
    let isMobileView = MatchMedia.useMobileChecker()

    let nestedSidebarItemRef = React.useRef(Js.Nullable.null)

    <UIUtils.RenderIf condition={isSideBarExpanded}>
      {switch tabInfo {
      | SubLevelLink(tabOption) => {
          let {name, link, access, ?iconTag, ?iconStyles, ?iconSize} = tabOption
          let linkTagPadding = "pl-2"

          <UIUtils.RenderIf condition={access !== NoAccess}>
            <Link to_={`${link}${getSearchParamByLink(link)}`}>
              <div
                ref={nestedSidebarItemRef->ReactDOM.Ref.domRef}
                onClick={_ => isMobileView ? setIsSidebarExpanded(_ => false) : ()} //second suboption
                className={`${textColor} relative overflow-hidden flex flex-row font-normal items-center cursor-pointer ${paddingClass} ${selectedClass}`}>
                <SidebarSubOption name isSectionExpanded isSelected isSideBarExpanded>
                  <UIUtils.RenderIf condition={iconTag->Option.isSome && isSideBarExpanded}>
                    <div className=linkTagPadding>
                      <Icon
                        size={iconSize->Option.getWithDefault(26)}
                        name={iconTag->Option.getWithDefault("")}
                        className={iconStyles->Option.getWithDefault("w-26 h-26")}
                      />
                    </div>
                  </UIUtils.RenderIf>
                </SidebarSubOption>
              </div>
            </Link>
          </UIUtils.RenderIf>
        }
      }}
    </UIUtils.RenderIf>
  }
}

module NestedSectionItem = {
  @react.component
  let make = (
    ~section: sectionType,
    ~isSectionExpanded,
    ~isAnySubItemSelected,
    ~textColor,
    ~cursor,
    ~toggleSectionExpansion,
    ~expandedTextColor,
    ~isElementShown,
    ~isSubLevelItemSelected,
    ~isSideBarExpanded,
  ) => {
    let iconColor = isAnySubItemSelected ? "text-blue-800" : "text-grey-450" //icon color

    let iconOuterClass = if !isSideBarExpanded {
      `${isAnySubItemSelected ? "bg-blue-200" : ""} rounded-sm p-4 rounded-lg `
    } else {
      ""
    }

    let bgColor = if isSectionExpanded || isAnySubItemSelected {
      "bg-blue-200 border border-r-2 border-blue-800 rounded-sm"
    } else {
      ""
    }

    let sidebarNestedSectionRef = React.useRef(Js.Nullable.null)

    let sectionExpandedAnimation = if isSectionExpanded {
      "rounded-sm transition duration-[250ms] ease-in-out bg-blue-200"
    } else {
      "hover:bg-blue-200"
    }

    <div className={`transition duration-300`}>
      <div
        ref={sidebarNestedSectionRef->ReactDOM.Ref.domRef}
        className={`${isSideBarExpanded
            ? "mr-2"
            : "mr-2"} text-sm ${textColor} ${bgColor} relative overflow-hidden flex flex-row items-center justify-between p-3 ${cursor} ${isSectionExpanded
            ? ""
            : sectionExpandedAnimation} border-l-2 ${isAnySubItemSelected
            ? "border-white"
            : "border-transparent"}`}
        onClick=toggleSectionExpansion>
        <div className="flex flex-row items-center select-none min-w-max flex items-center gap-5">
          {if isSideBarExpanded {
            <div className=iconOuterClass>
              <Icon size={getIconSize("medium")} name={section.icon} className=iconColor />
            </div>
          } else {
            <Icon size={getIconSize("small")} name=section.icon className=iconColor />
          }}
          <UIUtils.RenderIf condition={isSideBarExpanded}>
            <div
              className={`font-normal text-fs-14 hover:text-grey-950 ${expandedTextColor} whitespace-nowrap`}>
              {React.string(section.name)}
            </div>
          </UIUtils.RenderIf>
        </div>
        <UIUtils.RenderIf condition={isSideBarExpanded}>
          <Icon
            name={"Nested_arrow_down"}
            className={isSectionExpanded
              ? `-rotate-180 transition duration-[250ms] mr-2 text-blue-800 opacity-80`
              : `-rotate-0 transition duration-[250ms] mr-2 text-blue-800 opacity-80`} //right icon
            size=16
          />
        </UIUtils.RenderIf>
      </div>
      <UIUtils.RenderIf condition={isElementShown}>
        {section.links
        ->Array.mapWithIndex((subLevelItem, index) => {
          let isSelected = subLevelItem->isSubLevelItemSelected
          <NestedSidebarItem
            key={string_of_int(index)}
            isSelected
            isSideBarExpanded
            isSectionExpanded
            tabInfo=subLevelItem
          />
        })
        ->React.array}
      </UIUtils.RenderIf>
    </div>
  }
}

module SidebarNestedSection = {
  @react.component
  let make = (
    ~section: sectionType,
    ~linkSelectionCheck,
    ~firstPart,
    ~isSideBarExpanded,
    ~setIsSidebarExpanded,
  ) => {
    let isSubLevelItemSelected = tabInfo => {
      switch tabInfo {
      | SubLevelLink(item) => linkSelectionCheck(firstPart, item.link)
      }
    }

    let (isSectionExpanded, setIsSectionExpanded) = React.useState(_ => false)
    let (isElementShown, setIsElementShown) = React.useState(_ => false)

    let isAnySubItemSelected = section.links->Array.find(isSubLevelItemSelected)->Option.isSome

    React.useEffect2(() => {
      if isSectionExpanded {
        setIsElementShown(_ => true)
      } else if isElementShown {
        let _ = Js.Global.setTimeout(() => {
          setIsElementShown(_ => false)
        }, 200)
      }
      None
    }, (isSectionExpanded, isSideBarExpanded))

    React.useEffect2(() => {
      if isSideBarExpanded {
        setIsSectionExpanded(_ => isAnySubItemSelected)
      } else {
        setIsSectionExpanded(_ => false)
      }
      None
    }, (isSideBarExpanded, isAnySubItemSelected))

    let toggleSectionExpansion = React.useCallback4(_ev => {
      if !isSideBarExpanded {
        setIsSidebarExpanded(_ => true)
        Js.Global.setTimeout(() => {
          setIsSectionExpanded(_ => true)
        }, 200)->ignore
      } else if isAnySubItemSelected {
        setIsSectionExpanded(_ => true)
      } else {
        setIsSectionExpanded(p => !p)
      }
    }, (setIsSectionExpanded, isSideBarExpanded, setIsSidebarExpanded, isAnySubItemSelected))

    let textColor = {
      if isSideBarExpanded {
        if isAnySubItemSelected {
          "text-gray-900"
        } else {
          "text-unselected_white"
        }
      } else if isAnySubItemSelected {
        "text-white"
      } else {
        "text-unselected_white"
      }
    }

    let cursor = if isAnySubItemSelected && isSideBarExpanded {
      `cursor-default rounded-sm bg-blue-200`
    } else {
      `cursor-pointer rounded-sm`
    }
    let expandedTextColor = isAnySubItemSelected ? "text-grey-950" : "text-grey-450" //items with drop downs
    let areAllSubLevelsHidden = section.links->Array.reduce(true, (acc, subLevelItem) => {
      acc &&
      switch subLevelItem {
      | SubLevelLink({access}) => access === NoAccess
      }
    })
    <UIUtils.RenderIf condition={!areAllSubLevelsHidden}>
      <NestedSectionItem
        section
        isSectionExpanded
        isAnySubItemSelected
        textColor
        cursor
        toggleSectionExpansion
        expandedTextColor
        isElementShown
        isSubLevelItemSelected
        isSideBarExpanded
      />
    </UIUtils.RenderIf>
  }
}

module PinIconComponentStates = {
  @react.component
  let make = (~isHSSidebarPinned, ~setIsSidebarExpanded, ~isSidebarExpanded) => {
    let isMobileView = MatchMedia.useMobileChecker()
    let {setIsSidebarDetails} = React.useContext(SidebarProvider.defaultContext)

    let toggleExpand = React.useCallback0(_ => {
      setIsSidebarExpanded(x => !x)
    })

    let onClick = ev => {
      ev->ReactEvent.Mouse.preventDefault
      ev->ReactEvent.Mouse.stopPropagation
      ev->toggleExpand
      setIsSidebarDetails("isPinned", !isHSSidebarPinned->Js.Json.boolean)
    }

    <>
      <UIUtils.RenderIf condition={isSidebarExpanded && !isHSSidebarPinned && !isMobileView}>
        <Icon size=35 name="sidebar-pin-default" onClick className="cursor-pointer bg-white" />
      </UIUtils.RenderIf>
      <UIUtils.RenderIf condition={isHSSidebarPinned && !isMobileView}>
        <Icon size=35 name="sidebar-pin-pinned" onClick className="cursor-pointer bg-white" />
      </UIUtils.RenderIf>
      <UIUtils.RenderIf condition={isMobileView}>
        <div className="flex align-center mt-4 pl-3 mb-6 pr-4 ml-1 gap-5 cursor-default">
          <Icon
            className="mr-1"
            size=20
            name="collapse-cross"
            customIconColor="#FEFEFE"
            onClick={_ => setIsSidebarExpanded(_ => false)}
          />
        </div>
      </UIUtils.RenderIf>
    </>
  }
}

@react.component
let make = (
  ~sidebars: Js.Array2.t<topLevelItem>,
  ~path,
  ~linkSelectionCheck=defaultLinkSelectionCheck,
  ~verticalOffset="120px",
) => {
  let fetchApi = AuthHooks.useApiFetcher()
  let isMobileView = MatchMedia.useMobileChecker()
  let sideBarRef = React.useRef(Js.Nullable.null)
  let email = HSLocalStorage.getFromMerchantDetails("email")
  let (_authStatus, setAuthStatus) = React.useContext(AuthInfoProvider.authStatusContext)
  let {getFromSidebarDetails} = React.useContext(SidebarProvider.defaultContext)
  let {isSidebarExpanded, setIsSidebarExpanded} = React.useContext(SidebarProvider.defaultContext)
  let {setIsSidebarDetails} = React.useContext(SidebarProvider.defaultContext)
  let minWidthForPinnedState = MatchMedia.useMatchMedia("(min-width: 1280px)")

  React.useEffect1(() => {
    if minWidthForPinnedState {
      setIsSidebarDetails("isPinned", true->Js.Json.boolean)
      setIsSidebarExpanded(_ => true)
    } else {
      setIsSidebarDetails("isPinned", false->Js.Json.boolean)
      setIsSidebarExpanded(_ => false)
    }

    None
  }, [minWidthForPinnedState])

  let isHSSidebarPinned = getFromSidebarDetails("isPinned")
  let isExpanded = isSidebarExpanded || isHSSidebarPinned

  let sidebarWidth = isExpanded ? isMobileView ? "100%" : "270px" : "55px"
  let profileMaxWidth = "145px"

  let firstPart = switch Belt.List.head(path) {
  | Some(x) => `/${x}`
  | None => "/"
  }

  let expansionClass = !isExpanded ? "-translate-x-full" : ""

  let sidebarClass = ""
  let sidebarMaxWidth = isMobileView ? "w-screen" : "w-max"

  let onMouseHoverEvent = () => {
    if !isHSSidebarPinned {
      setIsSidebarExpanded(_ => true)
    } else {
      ()
    }
  }

  let onMouseHoverLeaveEvent = () => {
    if !isHSSidebarPinned {
      setIsSidebarExpanded(_ => false)
    } else {
      ()
    }
  }
  let sidebarContainerClassWidth = isMobileView ? "0px" : isHSSidebarPinned ? "270px" : "50px"

  let transformClass = "transform md:translate-x-0 transition"

  let handleLogout = _ => {
    let _ = APIUtils.handleLogout(~fetchApi, ~setAuthStatus, ~setIsSidebarExpanded)
  }

  <div className={`bg-white flex`}>
    <div
      ref={sideBarRef->ReactDOM.Ref.domRef}
      className={`flex h-full flex-col transition-all duration-100 ${sidebarClass} relative inset-0`}
      style={ReactDOMStyle.make(~width=sidebarContainerClassWidth, ())}
    />
    <div
      className={`absolute z-40 h-screen flex ${transformClass} duration-300 ease-in-out ${sidebarMaxWidth} ${expansionClass}`}
      onMouseOver={_ => onMouseHoverEvent()}
      onMouseLeave={_ => onMouseHoverLeaveEvent()}>
      <div
        ref={sideBarRef->ReactDOM.Ref.domRef}
        className={`bg-white flex h-full flex-col transition-all duration-100 ${sidebarClass} relative inset-0`}
        style={ReactDOMStyle.make(~width=sidebarWidth, ())}>
        <div className="flex items-center justify-between p-1 mr-2">
          <div
            className={`flex align-center mt-4 pl-3 mb-6 pr-4 ml-1 gap-5 cursor-default`}
            onClick={ev => {
              ev->ReactEvent.Mouse.preventDefault
              ev->ReactEvent.Mouse.stopPropagation
            }}>
            <Icon
              size=20
              name="kd_hamburger"
              className={"cursor-pointer  stroke-blue-900"}
              customIconColor="#E6F5FF"
            />
          </div>
          <PinIconComponentStates isHSSidebarPinned setIsSidebarExpanded isSidebarExpanded />
        </div>
        <div
          className="h-full overflow-y-scroll transition-transform duration-1000 overflow-x-hidden show-scrollbar"
          style={ReactDOMStyle.make(~height=`calc(100vh - ${verticalOffset})`, ())}>
          {sidebars
          ->Array.mapWithIndex((tabInfo, index) => {
            switch tabInfo {
            | RemoteLink(record)
            | Link(record) => {
                let isSelected = linkSelectionCheck(firstPart, record.link)
                <SidebarItem
                  key={string_of_int(index)} tabInfo isSelected isExpanded={isExpanded}
                />
              }

            | LinkWithTag(record) => {
                let isSelected = linkSelectionCheck(firstPart, record.link)
                <SidebarItem
                  key={string_of_int(index)} tabInfo isSelected isExpanded={isExpanded}
                />
              }

            | Section(section) =>
              <UIUtils.RenderIf condition={section.showSection} key={string_of_int(index)}>
                <SidebarNestedSection
                  key={string_of_int(index)}
                  section
                  linkSelectionCheck
                  firstPart
                  isSideBarExpanded={isExpanded}
                  setIsSidebarExpanded
                />
              </UIUtils.RenderIf>
            | Heading(headingOptions) =>
              <div
                key={string_of_int(index)}
                className={`text-xs font-medium leading-5 text-[#5B6376] overflow-hidden border-l-2 rounded-sm border-transparent px-3 ${isExpanded
                    ? "mx-2"
                    : "mx-1"} mt-5 mb-3`}>
                {{isExpanded ? headingOptions.name : ""}->React.string}
              </div>

            | CustomComponent(customComponentOptions) =>
              <UIUtils.RenderIf condition={isExpanded} key={string_of_int(index)}>
                customComponentOptions.component
              </UIUtils.RenderIf>
            }
          })
          ->React.array}
        </div>
        <div
          className="flex items-center justify-between mb-5 mt-2 mx-2 mr-2 hover:bg-blue-200 rounded-lg">
          <UIUtils.RenderIf condition={isExpanded}>
            <Popover className="relative inline-block text-left">
              {popoverProps => <>
                <Popover.Button
                  className={
                    let openClasses = if popoverProps["open"] {
                      `group pl-3 border py-2 rounded-lg inline-flex text-grey-450 items-center bg-blue-200 font-medium hover:text-opacity-100 focus:outline-none`
                    } else {
                      `text-opacity-90 group pl-3 border py-2 rounded-md inline-flex items-center text-grey-450 font-medium hover:text-opacity-100 focus:outline-none`
                    }
                    `${openClasses} border-none`
                  }>
                  {buttonProps => <>
                    <div className="flex items-center">
                      <div
                        className="inline-block text-grey-900 hover:text-mon-100 bg-white text-center w-10 h-10 leading-10 rounded-full mr-4">
                        {email->String.charAt(0)->String.toUpperCase->React.string}
                      </div>
                      <ToolTip
                        description=email
                        toolTipFor={<UIUtils.RenderIf condition={isExpanded}>
                          <div
                            className={`w-[${profileMaxWidth}] text-sm font-medium text-gray-400 dark:text-gray-600 text-ellipsis overflow-hidden`}>
                            {email->React.string}
                          </div>
                        </UIUtils.RenderIf>}
                        toolTipPosition=ToolTip.Top
                        tooltipWidthClass="!w-fit !z-50"
                      />
                    </div>
                    <div
                      className={`flex flex-row border-transparent dark:border-transparent rounded-2xl p-2 border-2`}>
                      <Icon name="dropdown-menu" className="cursor-pointer stroke-blue-200" />
                    </div>
                  </>}
                </Popover.Button>
                <Transition
                  \"as"="span"
                  enter={"transition ease-out duration-200"}
                  enterFrom="opacity-0 translate-y-1"
                  enterTo="opacity-100 translate-y-0"
                  leave={"transition ease-in duration-150"}
                  leaveFrom="opacity-100 translate-y-0"
                  leaveTo="opacity-0 translate-y-1">
                  <Popover.Panel className={`absolute !z-30 bottom-[100%] right-2`}>
                    {panelProps => {
                      <div
                        id="neglectTopbarTheme"
                        className="relative flex flex-col py-3 rounded-lg shadow-lg ring-1 ring-blue-200 w-60 bg-white text-grey-900">
                        <MenuOption
                          onClick={_ => {
                            RescriptReactRouter.replace(
                              `${HSwitchGlobalVars.hyperSwitchFEPrefix}/account-settings/profile`,
                            )
                          }}
                          text="Profile"
                        />
                        <MenuOption onClick={handleLogout} text="Sign out" />
                      </div>
                    }}
                  </Popover.Panel>
                </Transition>
              </>}
            </Popover>
          </UIUtils.RenderIf>
        </div>
      </div>
    </div>
  </div>
}
