class ValidationMessageFormBuilder < ActionView::Helpers::FormBuilder
  def errors(field, &block)
    validation_messages = object.respond_to?(:errors) ? object.errors[field] : []

    block ? yield(validation_messages) : validation_messages
  end
end
