module ActiveAdmin
  module TranslationHelpers
    def aa_tr(resource, action)
      t("active_admin.#{resource}s.#{action}.#{action}d_message")
    end
  end
end
