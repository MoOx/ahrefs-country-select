@react.component
let make = () => {
  let (country, setCountry) = React.useState(() => Some("us"))
  let handleChange = React.useCallback(country => {
    Js.log(country)
    setCountry(_ => Some(country))
  }, [])
  <CountrySelect className="custom-class" country onChange={handleChange} />
}

let default = make
