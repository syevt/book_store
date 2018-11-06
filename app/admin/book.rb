ActiveAdmin.register Book do
  permit_params(:category_id, :title, :description, :year, :height,
                :width, :thickness, :price, :main_image,
                author_ids: [], material_ids: [], images: [])

  batch_confirmation = I18n.t(
    'active_admin.batch_actions.delete_confirmation',
    plural_model: I18n.t('activerecord.models.book.other').downcase
  )

  batch_action :destroy, confirm: batch_confirmation do |ids|
    rejected = Book.where(id: ids).destroy_all.map(&:destroyed?).count(false)
    redirect_to(
      collection_path,
      ActiveAdmin::SetBooksBatchDestroyedFlash.call(ids.size, rejected)
    )
  end

  ActiveAdmin::RenderActiveAdminBooksIndex.call(self)
  ActiveAdmin::RenderActiveAdminBookShow.call(self)
  ActiveAdmin::RenderActiveAdminBookForm.call(self)

  controller do
    include ActiveAdmin::TranslationHelpers

    def new
      @book = BookForm.new
    end

    def create
      @book = BookForm.from_params(params)
      return render('new') if @book.invalid?
      Book.create(@book.attributes)
      flash.notice = aa_tr(:book, :create)
      redirect_to(collection_path)
    end

    def edit
      @book = BookForm.from_model(Book.find(params[:id]))
    end

    def update
      @book = BookForm.from_params(params)
      return render('edit') if @book.invalid?
      Book.find(params[:id]).update_attributes(@book.attributes)
      flash.notice = aa_tr(:book, :update)
      redirect_to(resource_path)
    end

    def destroy
      success = Book.find(params[:id]).destroy
      action_show = Rails.application.routes
                         .recognize_path(request.referrer)[:action] == 'show'
      path = action_show && !success ? resource_path(resource) : collection_path
      redirect_to(path, ActiveAdmin::SetBookDestroyedFlash.call(success))
    end
  end
end
