type FieldElement =
  HTMLButtonElement |
  HTMLInputElement |
  HTMLObjectElement |
  HTMLOutputElement |
  HTMLSelectElement |
  HTMLTextAreaElement

type SubmitElement = HTMLButtonElement | HTMLInputElement

addEventListener("invalid", (event) => {
  if (isFieldElement(event.target)) {
    reportValidity(event.target)

    event.preventDefault()
  }
}, { capture: true, passive: false })

addEventListener("focusout", ({ target }) => {
  if (isFieldElement(target)) {
    clearValidity(target)
    reportValidity(target)

    target.reportValidity()
  }
})

addEventListener("input", ({ target }) => {
  if (isFieldElement(target)) {
    disableSubmit(target.form)
  }
})

function clearValidity(input: FieldElement): void {
  input.setCustomValidity("")

  if (input.form) disableSubmit(input.form)

  reportValidity(input)
}

function reportValidity(input: FieldElement): void {
  if (input.form?.hasAttribute("novalidate")) return

  const id = input.getAttribute("data-validation-message")
  const validationMessage = getValidationMessage(input)
  const element = document.getElementById(id) || createValidationMessageFragment(input.form)

  if (element) {
    element.id = id
    element.innerHTML = validationMessage

    if (validationMessage) {
      input.setAttribute("aria-describedby", id)
      input.setAttribute("aria-invalid", "true")
    } else {
      input.removeAttribute("aria-describedby")
      input.removeAttribute("aria-invalid")
    }

    if (!element.parentElement) {
      input.parentElement.append(element)
    }

    if (input.form) disableSubmit(input.form)
  }
}

function disableSubmit(form: HTMLFormElement): void {
  const submitButtons = Array.from(form.querySelectorAll('[type="submit"], button:not([type])')).filter(isSubmitElement)
  const fields = Array.from(form.elements).filter(isFieldElement)
  const isValid = fields.every(input => input.validity.valid)

  for (const submitButton of submitButtons) submitButton.disabled = !isValid
}

function createValidationMessageFragment(form) {
  if (form) {
    const template = form.querySelector("[data-validation-message-template]")

    return template?.content.children[0].cloneNode()
  }
}

function getValidationMessage(input) {
  const validationMessages = Object.entries(readValidationMessages(input))

  const [ _, validationMessage ] = validationMessages.find(([ key ]) => input.validity[key]) || [ null, null ]

  return validationMessage || input.validationMessage
}

function readValidationMessages(input) {
  try {
    return JSON.parse(input.getAttribute("data-validation-messages"))
  } catch(_) {
    return {}
  }
}

function isFieldElement(element: any): element is FieldElement {
  return [
    HTMLButtonElement,
    HTMLInputElement,
    HTMLObjectElement,
    HTMLOutputElement,
    HTMLSelectElement,
    HTMLTextAreaElement,
  ].some(field => element instanceof field)
}

function isSubmitElement(element: any): element is SubmitElement {
  return [ HTMLButtonElement, HTMLInputElement ].some(field => element instanceof field)
}
