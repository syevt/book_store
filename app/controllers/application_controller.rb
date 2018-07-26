class ApplicationController < ActionController::Base
  protect_from_forgery(with: :exception)
  before_action { @categories = Common::GetCategoriesWithCounters.call }
end
