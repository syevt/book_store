describe ReviewsPresenter do
  describe '#verified_reviewer?' do
    let!(:book) { create(:book_with_reviews, reviews_count: 1) }

    it 'returns falsey value (nil) if book wasn`t bought by this user' do
      expect(subject.verified_reviewer?(book, 1)).to be_falsey
    end

    it 'returns truthy (LineItem instance) if book was ever bought by user' do
      user = User.first
      order = build(:order, customer: user)
      order.line_items << build(:line_item, product: book)
      user.orders << order
      user.save
      expect(subject.verified_reviewer?(book, 1)).to be_truthy
    end
  end
end
