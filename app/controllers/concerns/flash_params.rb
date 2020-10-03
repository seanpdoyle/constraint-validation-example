module FlashParams
  extend ActiveSupport::Concern

  included do
    self._flash_types += [:params]

    def params
      flash_params = flash[:params].to_h
      request_params = super.to_unsafe_hash

      ActionController::Parameters.new(request_params.deep_merge(flash_params))
    end
  end
end
