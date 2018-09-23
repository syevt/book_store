module ActiveAdmin
  class RenderActiveAdminBookShow < Ecomm::BaseService
    def call(config)
      config.instance_eval do
        show do
          attributes_table do
            row(:category) do |book|
              h5(b(capitalize_category(book.category.name)))
            end
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
      end
    end
  end
end
