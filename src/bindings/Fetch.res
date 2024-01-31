type fetchOptions = {
  method: string,
  headers: Js.Dict.t<string>,
  mode: string,
  // @todo complete bindings
}
type fetchResponse<'t> = {
  status: int,
  statusText: string,
  json: unit => Js.Json.t,
  // @todo complete bindings
}
@val external make: (string, fetchOptions) => promise<fetchResponse<'t>> = "fetch"
@send external responseToJson: 't => promise<Js.Json.t> = "json"
