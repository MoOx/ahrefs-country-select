type asyncData<'t> =
  | NotAsked
  | Loading
  | Done('t)

type country = {label: string, value: string, metric: float}

type countries = array<country>
let fetchCountries = (): promise<Result.t<countries, string>> => {
  Fetch.make(
    "/api/countries",
    {
      method: "GET",
      mode: "cors",
      headers: Js.Dict.fromArray([
        ("Accept", "application/json"),
        ("Content-Type", "application/json;charset=utf-8"),
      ]),
    },
  )
  ->Promise.then(Fetch.responseToJson)
  ->Promise.then(result => {
    // @todo don't use Obj.magic, properly decode JS instead
    let jsonCoutriesAsCountries: countries = result->Obj.magic
    jsonCoutriesAsCountries->Promise.resolve
  })
  ->Promise.then((countries: countries) => {
    Result.Ok(countries)->Promise.resolve
  })
  ->Promise.catch(err => {
    Console.error2("fetchCountries: Error while fetching countries", err)
    switch err {
    | Exn.Error(jsExn) =>
      Result.Error(jsExn->Exn.message->Option.getOr("Unknown error"))->Promise.resolve
    | _ => Result.Error("fetchCountries: Something unexpected happened")->Promise.resolve
    }
  })
}

let triangle =
  <svg width="8" height="5" viewBox="0 0 8 5" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path fillRule="evenodd" clipRule="evenodd" d="M0 0H8L4 5L0 0Z" fill="#333333" />
  </svg>

let magnifier =
  <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M6 11C7.01929 11 7.96734 10.695 8.75787 10.1713L12.06 13.47L13.47 12.06L10.1713 8.75783C10.695 7.96731 11 7.01927 11 6C11 3.23858 8.76142 1 6 1C3.23858 1 1 3.23858 1 6C1 8.76142 3.23858 11 6 11ZM9.2 6C9.2 7.76731 7.76731 9.2 6 9.2C4.23269 9.2 2.8 7.76731 2.8 6C2.8 4.23269 4.23269 2.8 6 2.8C7.76731 2.8 9.2 4.23269 9.2 6Z"
      fill="#333333"
    />
  </svg>

// @todo choose an actual CSS-in-JS solution
// most of the time I use React Native (with StyleSheet module), even on the web via React Native for Web
// but here I am too lazy to setup this, hope you understand :)
module Styles = {
  let currentValue = ReactDOM.Style.make(
    ~cursor="default",
    ~userSelect="none",
    ~boxSizing="border-box",
    ~display="flex",
    ~minWidth="140px",
    ~height="26px",
    ~padding="4px 9px",
    ~borderRadius="3px",
    ~border="1px solid #00000033",
    ~alignItems="center",
    (),
  )

  let selectContainer = ReactDOM.Style.make(
    ~borderRadius="3px",
    ~boxShadow="0px 3px 18px 0px rgba(0, 0, 0, 0.15)",
    // box-shadow 0px 0px 0px 1px rgba(0, 0, 0, 0.08)
    // since react-select have some constraint, we cannot really use this box-shadow border
    // so back to a simple border
    ~border="1px solid #E0E0E0",
    ~marginLeft="-1px",
    (),
  )

  let selectControl = ReactDOM.Style.make(
    ~minHeight="26px",
    ~padding="4px 0",
    ~borderWidth="0",
    ~boxShadow="none",
    ~zIndex="2",
    ~borderTopLeftRadius="3px",
    ~borderTopRightRadius="3px",
    ~borderBottomLeftRadius="0",
    ~borderBottomRightRadius="0",
    (),
  )
  let selectMenu = ReactDOM.Style.make(
    ~marginTop="0px",
    ~marginLeft="-1px",
    ~width="calc(100% + 2px)",
    ~marginBottom="0",
    ~borderTopLeftRadius="0",
    ~borderTopRightRadius="0",
    ~borderBottomLeftRadius="2px",
    ~borderBottomRightRadius="2px",
    ~boxShadow="0px 3px 18px 0px rgba(0, 0, 0, 0.15)",
    // box-shadow 0px 0px 0px 1px rgba(0, 0, 0, 0.08)
    // since react-select have some constraint, we cannot really use this box-shadow border
    // so back to a simple border
    ~border="1px solid #E0E0E0",
    (),
  )

  let selectPlaceholder = ReactDOM.Style.make(
    ~fontSize="14px",
    ~fontWeight="400",
    ~lineHeight="18px",
    ~color="rgba(0, 0, 0, 0.32)",
    (),
  )
  let selectValueContainerWrapper = ReactDOM.Style.make(
    ~display="flex",
    ~flexDirection="row",
    ~alignItems="center",
    ~padding="0 10px",
    (),
  )
  let selectValueContainer = ReactDOM.Style.make(~padding="0 2px", ~marginLeft="4px", ())

  let selectOption = ReactDOM.Style.make(
    ~display="flex",
    ~flexDirection="row",
    ~alignItems="center",
    ~boxSizing="border-box",
    ~padding="4px 10px",
    (),
  )

  let flag = ReactDOM.Style.make(~width="14px", ())

  let labelText = ReactDOM.Style.make(
    ~fontWeight="400",
    ~fontSize="14px",
    ~lineHeight="18px",
    ~letterSpacing="0em",
    ~textAlign="left",
    ~paddingLeft="8px",
    (),
  )

  // @todo discuss about widget size, so selected value style to see if 85px is enough
  let labelTextCurrentValue =
    labelText->ReactDOM.Style.combine(
      ReactDOM.Style.make(
        ~maxWidth="85px",
        ~textOverflow="ellipsis",
        ~whiteSpace="nowrap",
        ~overflow="hidden",
        (),
      ),
    )

  let metric = ReactDOM.Style.make(
    ~fontWeight="400",
    ~fontSize="12px",
    ~lineHeight="14px",
    ~color="rgba(0, 0, 0, 0.52)",
    (),
  )

  let selectWrapper = ReactDOM.Style.make(~position="relative", ())
  let select = ReactDOM.Style.make(
    ~boxSizing="border-box",
    ~position="absolute",
    ~top="3px",
    ~left="0px",
    ~minWidth="230px",
    (),
  )

  let flexGrow = ReactDOM.Style.make(~flexGrow="1", ())
}

module FlexSpace = {
  @react.component
  let make = () => <div style={Styles.flexGrow} />
}

// @todo limit ~country prop to a specific list ?
@react.component
let make = (~className: string, ~country: option<string>, ~onChange: string => unit) => {
  let (countries, countries_set) = React.useState(() => NotAsked)
  // @todo optimise this fetch to avoid duplicate requests during dev (react strict mode thing)
  // maybe use SWR in fetchCountries or something similar
  React.useEffect(() => {
    countries_set(_ => Loading)
    fetchCountries()
    ->Promise.then(countriesResult => {
      countries_set(
        _ => Done(
          switch countriesResult {
          | Ok(cs) =>
            Ok(cs->Array.toSorted((a, b) => Float.compare(a.metric, b.metric))->Array.toReversed)
          | _ => countriesResult
          },
        ),
      )
      Promise.resolve()
    })
    ->Promise.catch(err => {
      Console.error2("Error while fetching countries", err)
      switch err {
      | Exn.Error(jsExn) =>
        countries_set(_ => Done(Result.Error(jsExn->Exn.message->Option.getOr("Unknown error"))))
      | _ => countries_set(_ => Done(Result.Error("Something unexpected happened")))
      }
      Promise.resolve()
    })
    ->ignore

    None
  }, [])

  let (countriesOpened, countriesOpened_set) = React.useState(() => false)
  let handleCountryClick = React.useCallback(
    _ => countriesOpened_set(v => !v),
    [countriesOpened_set],
  )
  let handleCountryPress = React.useCallback(_event => {
    countriesOpened_set(v => !v)
  }, [countriesOpened_set])

  let handleChange = React.useCallback((event: country) => {
    countriesOpened_set(_ => false)
    onChange(event.value)
  }, [])

  let handleKeyDown = React.useCallback((event: ReactEvent.Keyboard.t) => {
    if event->ReactEvent.Keyboard.key === "Escape" {
      countriesOpened_set(_ => false)
    }
  }, [])

  <div className>
    {switch countries {
    | NotAsked =>
      <div style={Styles.currentValue}>
        <span style={Styles.flag} className="fi fi-xx" />
        <FlexSpace />
        {triangle}
      </div>
    | Loading =>
      <div style={Styles.currentValue}>
        <span style={Styles.flag} className="fi fi-xx" />
        <span style={Styles.labelTextCurrentValue}> {"Loading..."->React.string} </span>
        <FlexSpace />
        {triangle}
      </div>
    | Done(Result.Ok(countries)) =>
      <div>
        <div
          style={Styles.currentValue}
          onClick={handleCountryClick}
          onKeyDown={handleCountryPress}
          tabIndex={0}>
          {country
          ->Option.flatMap(country => countries->Array.find(cty => cty.value === country))
          ->Option.map(country => <>
            <span style={Styles.flag} className={"fi fi-" ++ {country.value}} />
            <span style={Styles.labelTextCurrentValue}> {country.label->React.string} </span>
          </>)
          ->Option.getOr(<>
            <span style={Styles.flag} className="fi fi-xx" />
            <span style={Styles.labelTextCurrentValue}> {"Select a country"->React.string} </span>
          </>)}
          <FlexSpace />
          {triangle}
        </div>
        <div style={Styles.selectWrapper}>
          <div style={Styles.select}>
            {!countriesOpened
              ? React.null
              : <ReactSelect
                  options={countries}
                  defaultMenuIsOpen={true}
                  autoFocus={true}
                  isSearchable={true}
                  menuIsOpen={countriesOpened}
                  closeMenuOnSelect={true}
                  controlShouldRenderValue={false}
                  placeholder={"Search"}
                  onChange={handleChange}
                  onKeyDown={handleKeyDown}
                  components={{
                    "SelectContainer": (props: ReactSelect.containerProps) => {
                      <div
                        {...props.innerProps}
                        style={props.getStyles("container", props)->ReactDOM.Style.combine(
                          Styles.selectContainer,
                        )}>
                        {props.children}
                      </div>
                    },
                    "Control": (props: ReactSelect.controlProps) => {
                      <div
                        {...props.innerProps}
                        style={props.getStyles("control", props)->ReactDOM.Style.combine(
                          Styles.selectControl,
                        )}>
                        {props.children}
                      </div>
                    },
                    "Menu": (props: ReactSelect.menuProps) => {
                      <div
                        {...props.innerProps}
                        style={props.getStyles("menu", props)->ReactDOM.Style.combine(
                          Styles.selectMenu,
                        )}>
                        {props.children}
                      </div>
                    },
                    // not needed
                    "IndicatorsContainer": () => React.null,
                    "Placeholder": (props: ReactSelect.placeholderProps) => {
                      <div
                        {...props.innerProps}
                        style={props.getStyles("placeholder", props)->ReactDOM.Style.combine(
                          Styles.selectPlaceholder,
                        )}>
                        {props.children}
                      </div>
                    },
                    // custom select with magnifier icon
                    "ValueContainer": (props: ReactSelect.valueContainerProps) => {
                      <div style={Styles.selectValueContainerWrapper}>
                        {magnifier}
                        <div
                          {...props.innerProps}
                          style={props.getStyles("valueContainer", props)->ReactDOM.Style.combine(
                            Styles.selectValueContainer,
                          )}>
                          {props.children}
                        </div>
                      </div>
                    },
                    // lets add the flag & stuff
                    "Option": (props: ReactSelect.optionProps<country>) => {
                      <div
                        {...props.innerProps}
                        ref=?{props.innerRef->Js.Undefined.toOption}
                        style={props.getStyles("option", props)
                        ->ReactDOM.Style.combine(Styles.selectOption)
                        ->ReactDOM.Style.combine(
                          ReactDOM.Style.make(
                            ~backgroundColor=props.isFocused
                              ? "#FFDBB3"
                              : props.isSelected
                              ? "#FFDBB3"
                              : "transparent",
                            (),
                          ),
                        )}>
                        <span style={Styles.flag} className={"fi fi-" ++ props.data.value} />
                        <span style={Styles.labelText}> {props.data.label->React.string} </span>
                        <FlexSpace />
                        <span style={Styles.metric}>
                          {(props.data.metric->Js.Float.toFixedWithPrecision(~digits=1) ++ "K")
                            ->React.string}
                        </span>
                      </div>
                    },
                  }}
                />}
          </div>
        </div>
      </div>
    | Done(Result.Error(err)) =>
      // @todo display error in a more user friendly way
      <div style={Styles.currentValue}>
        <span style={Styles.flag} className="fi fi-xx" />
        <span style={Styles.labelTextCurrentValue}> {err->React.string} </span>
      </div>
    }}
  </div>
}
