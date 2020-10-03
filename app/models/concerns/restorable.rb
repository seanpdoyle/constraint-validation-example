module Restorable
  extend ActiveSupport::Concern

  class_methods do
    def restore_submission(attributes)
      new(attributes).tap { |model| model.validate unless attributes.empty? }
    end
  end
end
