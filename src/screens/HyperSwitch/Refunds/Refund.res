@react.component
let make = () => {
  open APIUtils
  open HSwitchRemoteFilter
  open LogicUtils
  open RefundUtils
  let updateDetails = useUpdateMethod()
  let (screenState, setScreenState) = React.useState(_ => PageLoaderWrapper.Loading)
  let (refundData, setRefundsData) = React.useState(_ => [])
  let (totalCount, setTotalCount) = React.useState(_ => 0)
  let (searchText, setSearchText) = React.useState(_ => "")
  let (filters, setFilters) = React.useState(_ => None)
  let defaultValue: LoadedTable.pageDetails = {offset: 0, resultsPerPage: 10}
  let pageDetailDict = Recoil.useRecoilValueFromAtom(LoadedTable.table_pageDetails)
  let pageDetail = pageDetailDict->Dict.get("Refunds")->Option.getWithDefault(defaultValue)
  let (offset, setOffset) = React.useState(_ => pageDetail.offset)

  React.useEffect3(() => {
    switch filters {
    | Some(dict) =>
      let filters = Dict.make()

      filters->Dict.set("offset", offset->Belt.Int.toFloat->Js.Json.number)
      if !(searchText->isEmptyString) {
        filters->Dict.set("payment_id", searchText->String.trim->Js.Json.string)
        filters->Dict.set("refund_id", searchText->String.trim->Js.Json.string)
      }

      dict
      ->Dict.toArray
      ->Array.forEach(item => {
        let (key, value) = item
        filters->Dict.set(key, value)
      })

      filters
      ->getRefundsList(
        ~updateDetails,
        ~setRefundsData,
        ~setScreenState,
        ~offset,
        ~setOffset,
        ~setTotalCount,
      )
      ->ignore
    | _ => ()
    }
    None
  }, (offset, filters, searchText))

  let {generateReport} = HyperswitchAtom.featureFlagAtom->Recoil.useRecoilValueFromAtom

  <ErrorBoundary>
    <div className="min-h-[10vh] flex flex-col gap-6">
      <div className="flex justify-between whitespace-nowrap">
        <PageUtils.PageHeading title="Refunds" subTitle="View and manage all refunds" />
        <div className="flex w-full justify-end">
          <UIUtils.RenderIf condition={generateReport}>
            <GenerateReport entityName={REFUND_REPORT} />
          </UIUtils.RenderIf>
        </div>
      </div>
      <RemoteTableFilters
        placeholder="Search payment id or refund id"
        setSearchVal=setSearchText
        searchVal=searchText
        filterUrl={`${HSwitchGlobalVars.hyperSwitchApiPrefix}/refunds/filter`}
        setFilters
        endTimeFilterKey
        startTimeFilterKey
        initialFilters
        initialFixedFilter
        setOffset
      />
      <PageLoaderWrapper screenState customUI>
        <LoadedTableWithCustomColumns
          hideTitle=true
          title="Refunds"
          actualData=refundData
          entity={RefundEntity.refundEntity}
          resultsPerPage=10
          showSerialNumber=true
          totalResults={totalCount}
          offset
          setOffset
          currrentFetchCount={refundData->Array.length}
          defaultColumns={RefundEntity.defaultColumns}
          customColumnMapper=RefundEntity.refundsMapDefaultCols
          showSerialNumberInCustomizeColumns=false
          sortingBasedOnDisabled=false
          showResultsPerPageSelector=false
        />
      </PageLoaderWrapper>
    </div>
  </ErrorBoundary>
}
