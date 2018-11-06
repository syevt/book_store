class BooksController < ApplicationController
  include Rectify::ControllerHelpers

  def show
    set_back_to_results_path
    present(ReviewsPresenter.new)
    @book = Books::GetBookWithAssociated.call(params[:id], load_reviews: true)
  end

  private

  def set_back_to_results_path
    referrer = request.referrer
    return unless referrer
    name = Rails.application.routes.recognize_path(referrer)[:controller]
    session[:back_to_results] = referrer if %w(home catalog).include?(name)
  end
end
