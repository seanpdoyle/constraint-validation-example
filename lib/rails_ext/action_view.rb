module AriaTagsExtension
  def render
    if object.respond_to?(:errors) && object.errors[@method_name].any?
      @options["aria-invalid"] ||= "true"
    end

    super
  end
end

module CheckableAriaTagsExtension
  def render
    if object.respond_to?(:errors) && object.errors[@method_name].any?
      @options["aria-invalid"] ||= ("true" if @options["checked"])
    end

    super
  end
end

module ValidationMessageExtension
  def render
    index = @options.fetch("index", @auto_index)

    @options["data-validation-message"] ||= tag_id(index) + "_validation_message"

    super
  end
end

ActiveSupport.on_load :action_view do
  module ActionView
    module Helpers
      module Tags
        class ActionText
          prepend AriaTagsExtension
          prepend ValidationMessageExtension
        end

        class Select
          prepend AriaTagsExtension
          prepend ValidationMessageExtension
        end

        class TextField
          prepend AriaTagsExtension
          prepend ValidationMessageExtension
        end

        class TextArea
          prepend AriaTagsExtension
          prepend ValidationMessageExtension
        end

        [RadioButton, CheckBox].each do |kls|
          prepend CheckableAriaTagsExtension
          prepend ValidationMessageExtension
        end
      end
    end
  end
end
