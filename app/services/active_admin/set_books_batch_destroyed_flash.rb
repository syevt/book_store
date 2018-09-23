module ActiveAdmin
  class SetBooksBatchDestroyedFlash < Ecomm::BaseService
    include AbstractController::Translation

    def call(count, rejected)
      @aa_prefix = 'active_admin.batch_actions.'
      @ar_prefix = 'activerecord.models.book.'
      return { notice: fully_destroyed(count) } if rejected.zero?
      { alert: partially_destroyed(count, rejected) }
    end

    private

    def fully_destroyed(count)
      model = t("#{@ar_prefix}#{count == 1 ? 'one' : 'other'}")
      t("#{@aa_prefix}fully_destroyed", count: count, model: model.downcase)
    end

    def partially_destroyed(count, rejected)
      t("#{@aa_prefix}.partially_destroyed",
        count: rejected, quantity: count,
        plural_model: t("#{@ar_prefix}other").downcase)
    end
  end
end
