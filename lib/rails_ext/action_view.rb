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

ActiveSupport.on_load :action_view do
  module ActionView
    module Helpers
      module Tags
        class ActionText
          prepend AriaTagsExtension
        end

        class Select
          prepend AriaTagsExtension
        end

        class TextField
          prepend AriaTagsExtension
        end

        class TextArea
          prepend AriaTagsExtension
        end

        [RadioButton, CheckBox].each do |kls|
          prepend CheckableAriaTagsExtension
        end
      end
    end
  end
end
