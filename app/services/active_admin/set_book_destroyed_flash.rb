module ActiveAdmin
  class SetBookDestroyedFlash < Ecomm::BaseService
    include AbstractController::Translation

    def call(success)
      prefix = 'active_admin.books.'
      return { notice: t("#{prefix}destroyed") } if success
      { alert: t("#{prefix}cannot_destroy") }
    end
  end
end
