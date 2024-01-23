module CardHeader = {
  @react.component
  let make = (~heading, ~subHeading, ~leftIcon=None, ~customSubHeadingStyle="") => {
    <div className="flex gap-3">
      {switch leftIcon {
      | Some(icon) => <img className="h-6 inline-block align-top" src={`/icons/${icon}.svg`} />
      | None => React.null
      }}
      <div className="">
        <div className="text-xl font-semibold"> {heading->React.string} </div>
        <div
          className={`text-md font-normal leading-7 opacity-50 mt-2 w-full max-w-sm ${customSubHeadingStyle}`}>
          {subHeading->React.string}
        </div>
      </div>
    </div>
  }
}

module CardFooter = {
  @react.component
  let make = (~customFooterStyle="", ~children) => {
    <div className={`lg:ml-9 lg:mt-7 lg:mb-3 flex gap-5 ${customFooterStyle}`}> children </div>
  }
}

module CardLayout = {
  @react.component
  let make = (~width="w-1/2", ~children, ~customStyle="rounded-2xl") => {
    <div
      className={`relative bg-white ${width} shadow-sma rounded-2xl p-6  flex flex-col justify-between ${customStyle}`}>
      children
    </div>
  }
}
