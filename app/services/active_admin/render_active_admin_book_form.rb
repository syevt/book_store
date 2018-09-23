module ActiveAdmin
  class RenderActiveAdminBookForm < Ecomm::BaseService
    def call(config)
      config.instance_eval do
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
                                   [
                                     [author.last_name,
                                      author.first_name].join(', '),
                                     author.id
                                   ]
                                 }.sort)
            f.input(:description, as: :text, input_html: { rows: 5 })
            f.input(:material_ids, label: t('.book.materials'),
                                   as: :check_boxes,
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
      end
    end
  end
end
