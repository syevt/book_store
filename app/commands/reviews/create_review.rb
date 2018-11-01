module Reviews
  class CreateReview < Ecomm::BaseCommand
    def call(params, user)
      review = ReviewForm.from_params(params)
      if review.invalid?
        publish(:invalid, review,
                Books::GetBookWithAssociated.call(params[:book_id]))
      else
        Review.create(review.attributes.merge(user: user))
        publish(:ok, I18n.t('reviews.form.success_message'))
      end
    end
  end
end
