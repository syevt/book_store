require_relative '../../../support/admin/batch_actions'

feature 'Admin Books index page' do
  include BatchActionsHelpers

  include_examples 'not authorized', :admin_books_path

  context 'with admin' do
    given(:book_label) { t('activerecord.models.book.one') }
    given(:books_label) { t('activerecord.models.book.other') }

    background { login_as(create(:admin_user), scope: :user) }

    scenario 'shows admin books index' do
      visit admin_books_path
      expect(page).to have_content(books_label)
      expect(page).to have_link(t('active_admin.new_model',
                                  model: book_label))
    end

    scenario 'shows list of available books' do
      create_list(:book_with_authors_and_materials, 3, title: 'Thetis')
      visit admin_books_path
      expect(page).to have_content('Thetis', count: 3)
    end

    scenario "click on 'new book' redirects to 'new book' page" do
      visit admin_books_path
      click_link(t('active_admin.new_model', model: book_label))
      expect(page).to have_content(
        t('active_admin.new_model', model: book_label)
      )
      expect(page).to have_field('book_title')
    end

    scenario "click on 'view' link redirects to 'show book' page" do
      create(:book_with_authors_and_materials,
             title: 'Dwarf',
             images: load_images(%w(16 24 32)))
      visit admin_books_path
      click_link(t('active_admin.view'))
      expect(page).to have_content('Dwarf')
      expect(page).to have_link(t('active_admin.edit_model',
                                  model: book_label))
      expect(page).to have_link(t('active_admin.delete_model',
                                  model: book_label))
    end

    scenario "click on 'edit' link redirects to 'edit book' page" do
      create(:book_with_authors_and_materials)
      visit admin_books_path
      click_link(t('active_admin.edit'))
      expect(page).to have_content(
        t('active_admin.edit_model', model: book_label)
      )
      expect(page).to have_field('book_year')
    end

    context "click on 'delete'", use_selenium: true do
      given!(:book) { create(:book_with_authors_and_materials) }

      scenario 'removes book from list' do
        visit admin_books_path
        click_link(t('active_admin.delete'))
        accept_alert
        expect(page).to have_text(t('active_admin.books.destroyed'))
      end

      scenario 'does not remove book from list if it has line items' do
        create(:line_item, product: book)
        visit admin_books_path
        click_link(t('active_admin.delete'))
        accept_alert
        expect(page).to have_text(t('active_admin.books.cannot_destroy'))
      end
    end

    context 'batch actions', use_selenium: true do
      scenario 'delete all' do
        create_list(:book_with_authors_and_materials, 3)
        visit admin_books_path
        check_batch_all
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(3, books_label.downcase)
        )
        expect(page).to have_content(
          t('active_admin.blank_slate.content', resource_name: books_label)
        )
      end

      scenario 'delete selected' do
        create_list(:book_with_authors_and_materials, 4, title: 'Troy')
        visit admin_books_path
        check_batch_items(1, 3)
        click_batch_delete
        expect(page).to have_content(
          batch_destroyed_label(2, books_label.downcase)
        )
        expect(page).to have_content('Troy', count: 2)
      end
    end
  end
end
