class ReviewsPresenter < Rectify::Presenter
  def verified_reviewer?(book, user_id)
    book.line_items.find { |line_item| line_item.order.customer.id == user_id }
  end
end
