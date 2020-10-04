class ValidationMessageFormBuilder < ActionView::Helpers::FormBuilder
  def validation_message(field, **attributes, &block)
    errors field do |messages|
      id = validation_message_id(field)

      if messages.any?
        @template.tag.with_options id: id, **attributes do |tag|
          if block_given?
            yield messages, tag
          else
            tag.span(messages.to_sentence)
          end
        end
      end
    end
  end

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
