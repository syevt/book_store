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
    redirect_to collection_path, batch_destroyed_flash(ids.size, rejected)
  end

  ActiveAdmin::RenderActiveAdminBooksIndex.call(self)

  show do
    attributes_table do
      row(:category) { |book| h5(b(capitalize_category(book.category.name))) }
      row(:title) { |book| h3(b(book.title)) }
      row(:authors) { |book| h4(book.decorate.authors_full) }
      row(:main_image) do |book|
        image_tag(book.main_image.url(:small))
      end
      row(t('.book.images')) do |book|
        if book.images.present?
          ul(class: 'images-row') do
            book.images.each do |image|
              li(image_tag(image.url(:small)))
            end
          end
        end
      end
      row(:description)
      row(:materials) { |book| book.decorate.materials_string }
      row(t('.book.dimensions')) { |book| book.decorate.dimensions }
      row(:price) { |book| number_to_currency(book.price) }
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs(t('.book.book_details'), multipart: true) do
      image_hint = if f.object.persisted? && f.object.main_image.present?
                     image_tag(f.object.main_image.url(:thumb))
                   end
      f.input(:main_image, as: :file, hint: image_hint)

      images_hint = if f.object.persisted? && f.object.images.present?
                      f.object.images.map { |image|
                        '<span class="row-thumb">' <<
                          image_tag(image.url(:thumb)) <<
                          '</span>'
                      }.join.html_safe
                    end
      f.input(:images, as: :file, input_html: { multiple: true },
                       hint: images_hint)

      f.input :category_id, label: t('.book.category'), as: :select,
                            collection: Category.all.map { |category|
                              [category.name.capitalize, category.id]
                            }.sort
      f.input(:title)
      f.input(:author_ids, label: t('.book.authors'), as: :check_boxes,
              collection: Author.all.map { |author|
                [[author.last_name, author.first_name].join(', '), author.id]
              }.sort)
      f.input(:description, as: :text, input_html: { rows: 5 })
      f.input(:material_ids, label: t('.book.materials'), as: :check_boxes,
                             collection: Material.all.map { |material|
                               [material.name.capitalize, material.id]
                             }.sort)
      f.input(:year)
      f.input(:height)
      f.input(:width)
      f.input(:thickness)
      f.input(:price)
    end
    f.actions
  end

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
      redirect_to(after_destroy_path(success), flash_destroyed(success))
    end

    private

    def after_destroy_path(success)
      action = Rails.application.routes
                    .recognize_path(request.referrer)[:action]
      action == 'show' && !success ? resource_path(resource) : collection_path
    end

    def batch_destroyed_flash(count, rejected)
      return { notice: fully_destroyed(count) } if rejected.zero?
      { alert: partially_destroyed(count, rejected) }
    end

    def fully_destroyed(count)
      model = t("activerecord.models.book.#{count == 1 ? 'one' : 'other'}")
      t('active_admin.batch_actions.fully_destroyed',
        count: count, model: model.downcase)
    end

    def partially_destroyed(count, rejected)
      t('active_admin.batch_actions.partially_destroyed',
        count: rejected, quantity: count,
        plural_model: t('activerecord.models.book.other').downcase)
    end

    def flash_destroyed(success)
      prefix = 'active_admin.books.'
      return { notice: t("#{prefix}destroyed") } if success
      { alert: t("#{prefix}cannot_destroy") }
    end
  end
end
