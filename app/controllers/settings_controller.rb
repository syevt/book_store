class SettingsController < ApplicationController
  before_action(:authenticate_user!)

  def show
    ns = Ecomm::Common
    @countries = ns::GetCountries.call
    address_service = ns::GetOrCreateAddress
    @billing = address_service.call(session, 'billing', current_user.id)
    @shipping = address_service.call(session, 'shipping', current_user.id)
  end
end
