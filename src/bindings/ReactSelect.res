type rec containerProps = {
  children: React.element,
  getStyles: (string, containerProps) => ReactDOM.Style.t,
  innerProps: JsxDOM.domProps,
  // @todo complete containerProps
}
type rec controlProps = {
  children: React.element,
  getStyles: (string, controlProps) => ReactDOM.Style.t,
  innerProps: JsxDOM.domProps,
  // @todo complete controlProps
}
type rec menuProps = {
  children: React.element,
  getStyles: (string, menuProps) => ReactDOM.Style.t,
  innerProps: JsxDOM.domProps,
  // @todo complete menuProps
}

type rec optionProps<'selectOption> = {
  data: 'selectOption,
  innerRef: Js.undefined<ReactDOM.Ref.t>,
  isFocused: bool,
  isSelected: bool,
  getStyles: (string, optionProps<'selectOption>) => ReactDOM.Style.t,
  innerProps: JsxDOM.domProps,
  // @todo complete optionProps
}

type rec placeholderProps = {
  children: React.element,
  getStyles: (string, placeholderProps) => ReactDOM.Style.t,
  innerProps: JsxDOM.domProps,
  // @todo complete placeholderProps
}
type rec valueContainerProps = {
  children: React.element,
  getStyles: (string, valueContainerProps) => ReactDOM.Style.t,
  innerProps: JsxDOM.domProps,
  // @todo complete valueContainerProps
}

// @todo change this if needed elsewhere to make this list optional
type selectComponents<'selectOption> = {
  "SelectContainer": containerProps => React.element,
  "Control": controlProps => React.element,
  "Menu": menuProps => React.element,
  "IndicatorsContainer": unit => React.element,
  "Option": optionProps<'selectOption> => React.element,
  "Placeholder": placeholderProps => React.element,
  "ValueContainer": valueContainerProps => React.element,
}

@react.component @module("react-select")
external make: (
  ~autoFocus: bool=?,
  ~closeMenuOnSelect: bool=?,
  ~components: selectComponents<'selectOption>=?,
  ~controlShouldRenderValue: bool=?,
  ~defaultMenuIsOpen: bool=?,
  ~isSearchable: bool=?,
  ~menuIsOpen: bool=?,
  ~onChange: 'selectOption => unit=?,
  ~onKeyDown: ReactEvent.Keyboard.t => unit=?,
  ~options: array<'selectOption>,
  ~placeholder: string=?,
) => React.element = "default"
