class ValidationMessageFormBuilder < ActionView::Helpers::FormBuilder
  def validation_message_id(field)
    if errors(field).any?
      field_id(field, :validation_message)
    end
  end

  def errors(field, &block)
    validation_messages = object.respond_to?(:errors) ? object.errors[field] : []

    block ? yield(validation_messages) : validation_messages
  end
end
