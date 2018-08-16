ActiveAdmin.register Ecomm::Order, as: 'Order' do
  actions(:index, :show)

  config.batch_actions = false
  config.filters = false

  tr_key = 'activerecord.attributes.order.state.'
  scope(I18n.t('.active_admin.resource.index.all'), :all, default: true)
  scope(I18n.t('.active_admin.resource.index.order.in_progress')) do |scope|
    scope.where(state: %w(in_progress in_queue in_delivery))
  end
  scope(I18n.t('.active_admin.resource.index.order.delivered'), :delivered)
  scope(I18n.t('.active_admin.resource.index.order.canceled'), :canceled)

  index do
    column(t('.order.order')) do |order|
      link_to(order.decorate.number, admin_order_path(order))
    end
    column(t('.order.state')) do |order|
      span(t(tr_key + order.state), class: "status_tag #{order.state}")
    end
    column(t('.order.date'), :created_at)
    column(t('.order.customer'), :customer, sortable: :customer_id)
    column(t('.order.total')) do |order|
      number_to_currency(order.subtotal + order.shipment.price)
    end
    column(t('.actions')) { |order| aasm_events_select(order) }
  end

  show do
    attributes_table do
      # state_row(order.decorate.number, :state)
      row(t('.order.state')) do |order|
        # span(order.state, class: "status_tag #{order.state}")
        # span(order.decorate.number, class: "status_tag #{order.state}")
        span(t(tr_key + order.state), class: "status_tag #{order.state}")
      end
      row(t('activerecord.models.user.one')) do |order|
        link_to(order.user.email, admin_user_path(order.user))
      end
      row(t('.actions')) { |order| aasm_events_select(order) }
      table_for(order.line_items) do |t|
        column(t('active_admin.resource.index.book.image')) do |item|
          image_tag(item.book.main_image.url(:thumb))
        end
        t.column(t('carts.product')) { |item| item.book.title }
        t.column(t('carts.price')) { |item| number_to_currency item.book.price }
        t.column(t('carts.quantity'), &:quantity)
        t.column(t('carts.subtotal')) do |item|
          number_to_currency(item.quantity * item.book.price)
        end

        right_align_span = { style: 'text-align: right;', colspan: 4 }

        tr(class: 'odd') do
          td(t('.order.items_total'), right_align_span)
          items_total = order.line_items.sum do |line_item|
            line_item.quantity * line_item.book.price
          end
          td(number_to_currency(items_total))
        end
        tr(class: 'odd') do
          td(t('activerecord.models.coupon.one'), right_align_span)
          cut = order.coupon&.discount
          td(number_to_percentage((cut ? cut : 0.0), precision: 0))
        end
        tr(class: 'odd') do
          td(t('checkout.order_subtotal'), right_align_span)
          td(number_to_currency(order.subtotal))
        end
        tr(class: 'odd') do
          td(t('activerecord.models.shipment.one'), right_align_span)
          td(number_to_currency(order.shipment.price))
        end
        tr(class: 'odd') do
          td(t('carts.show.order_total'), right_align_span)
          td(number_to_currency(order.subtotal + order.shipment.price))
        end
      end
    end
  end

  sidebar(I18n.t('checkout.address.billing_address'), only: :show) do
    render_address(order.billing_address)
  end

  sidebar(I18n.t('checkout.address.shipping_address'), only: :show) do
    render_address(order.shipping_address || order.billing_address)
  end

  sidebar(I18n.t('checkout.payment.credit_card'), only: :show) do
    render_credit_card(order.credit_card)
  end

  controller do
    %i(queue deliver complete cancel).each do |action|
      define_method(action) do
        Order.find(params[:order_id]).send(action.to_s << '!')
        redirect_to(request.referrer)
      end
    end
  end
end
