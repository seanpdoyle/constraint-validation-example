class ApplicationRecord < ActiveRecord::Base
  include Restorable

  self.abstract_class = true
end
