module Books
  class GetBookWithAssociated < Ecomm::BaseService
    def call(id, options = {})
      load_reviews = options[:load_reviews]
      books = Book.where(id: id).includes(:authors, :materials)
      if load_reviews
        books.includes(line_items: [order: :customer],
                       approved_reviews: [user: :billing_address])
      end
      books.first.decorate
    end
  end
end
