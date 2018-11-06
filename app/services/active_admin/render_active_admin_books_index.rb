module ActiveAdmin
  class RenderActiveAdminBooksIndex < Ecomm::BaseService
    def call(config)
      config.instance_eval do
        index do
          selectable_column
          column(t('.book.image')) do |book|
            image_tag(book.main_image.url(:thumb))
          end
          column(:category) { |book| book.category.name.capitalize }
          column(:title)
          column(:authors) { |book| book.decorate.authors_short }
          column(:description) { |book| markdown_truncate(book.description) }
          column(:price) { |book| number_to_currency(book.price) }
          actions
        end
      end
    end
  end
end
