module Settings
  class GenerateAddressUpdatedMessage < Ecomm::BaseService
    def call(type)
      t('settings.show.address_saved',
        address_type: I18n.t("ecomm.checkout.address.#{type}"))
    end
  end
end
