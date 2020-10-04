type FieldElement =
  HTMLButtonElement |
  HTMLInputElement |
  HTMLObjectElement |
  HTMLOutputElement |
  HTMLSelectElement |
  HTMLTextAreaElement

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

function clearValidity(input: FieldElement): void {
  input.setCustomValidity("")

  reportValidity(input)
}

function reportValidity(input: FieldElement): void {
  if (input.form?.hasAttribute("novalidate")) return

  const id = input.getAttribute("data-validation-message")
  const validationMessage = input.validationMessage
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
  }
}

function createValidationMessageFragment(form) {
  if (form) {
    const template = form.querySelector("[data-validation-message-template]")

    return template?.content.children[0].cloneNode()
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
