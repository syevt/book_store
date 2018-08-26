class BooksController < ApplicationController
  include Rectify::ControllerHelpers

  def show
    set_back_to_results_path
    present(ReviewsPresenter.new)
    @book = BookWithAssociated.new(params[:id], load_reviews: true)
                              .first.decorate
  end

  private

  def set_back_to_results_path
    referrer = request.referrer
    name = Rails.application.routes.recognize_path(referrer)[:controller]
    session[:back_to_catalog] = referrer if %w(home catalog).include?(name)
  end
end
