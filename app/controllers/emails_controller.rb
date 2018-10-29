class EmailsController < ApplicationController
  before_action(:authenticate_user!)

  def update
    current_user.email = params.require(:user).permit(:email)[:email]
    flash[:show_privacy] = true
    if current_user.save
      flash[:notice] = t('settings.change_email.email_updated')
    else
      flash[:alert] = current_user.errors.full_messages.first
    end
    redirect_to(settings_path)
  end
end
