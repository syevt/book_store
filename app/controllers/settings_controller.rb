class SettingsController < ApplicationController
  include Rectify::ControllerHelpers

  before_action(:authenticate_user!)

  def show
    present(SettingsPresenter.new, for: :main_app)
    present(Ecomm::CheckoutPresenter.new)
    address_service = Ecomm::Common::GetOrCreateAddress
    @billing = address_service.call(session, 'billing', current_user.id)
    @shipping = address_service.call(session, 'shipping', current_user.id)
  end
end
