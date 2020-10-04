class ValidationMessageFormBuilder < ActionView::Helpers::FormBuilder
  def initialize(*)
    super

    @validation_message_template = proc { |messages, tag| tag.span(messages.to_sentence) }
  end

  def validation_message_template(&block)
    @validation_message_template = block

    content = @template.with_output_buffer { @validation_message_template.call([], @template.tag) }

    @template.tag.template content, data: { validation_message_template: true }
  end

  def validation_message(field, **attributes, &block)
    errors field do |messages|
      id = validation_message_id(field)

      if messages.any?
        @template.tag.with_options id: id, **attributes do |tag|
          if block_given?
            yield messages, tag
          else
            @validation_message_template.call(messages, tag)
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
