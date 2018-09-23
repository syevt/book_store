module BatchActionsHelpers
  include Capybara::DSL

  def check_batch_all
    check('collection_selection_toggle_all')
  end

  def check_batch_items(*items)
    items.each { |item| check("batch_action_item_#{item}") }
  end

  def click_batch_delete
    click_link(t("#{batch_prefix}button_label"))
    click_link(t("#{batch_prefix}action_label",
                 title: t("#{batch_prefix}labels.destroy")))
    click_button('OK')
  end

  def batch_destroyed_label(count:, rejected: 0, model:)
    return fully_destroyed(count, model) if rejected.zero?
    partially_destroyed(count, rejected, model)
  end

  private

  def fully_destroyed(count, model)
    t('active_admin.batch_actions.fully_destroyed', count: count, model: model)
  end

  def partially_destroyed(count, rejected, model)
    t('active_admin.batch_actions.partially_destroyed',
      count: rejected, quantity: count, plural_model: model)
  end
end
