require_relative '../../support/forms/new_address_form'
require 'ecomm/test_helpers'

feature 'User address settings page' do
  context 'with guest user' do
    scenario 'redirects to login page' do
      visit settings_path
      expect(page).to have_content(t('devise.failure.unauthenticated'))
    end
  end

  context 'with logged in user' do
    include Ecomm::TranslationHelpers

    def find_error_span(address_type, field)
      xpath = "//input[@name='address[#{address_type}][#{field}]']/"\
              "../../following-sibling::span[@class='help-block'][1]"
      find(:xpath, xpath)
    end

    given!(:user) { create(:user) }

    given(:billing_form) { NewAddressForm.new('address', 'billing') }
    given(:shipping_form) { NewAddressForm.new('address', 'shipping') }

    context 'filling in' do
      background do
        login_as(user, scope: :user)
        visit settings_path
      end

      context 'billing address' do
        scenario 'with valid data shows updated message' do
          billing_form.fill_in_form(attributes_for(:address,
                                                   country: 'Portugal'))
          first("input[type='submit']").click
          expect(page).to have_content(
            t('settings.show.address_saved', address_type: 'billing')
          )
        end

        scenario "with empty field shows 'can`t be blank' errors" do
          billing_form.fill_in_form(attributes_for(:address, city: ''))
          first("input[type='submit']").click
          error_span = find_error_span('billing', 'city')
          expect(error_span).to have_content(attr_blank_error(:address, :city))
        end

        scenario "with invalid field shows 'invalid' errors" do
          billing_form.fill_in_form(attributes_for(:address, zip: 'xyz'))
          first("input[type='submit']").click
          error_span = find_error_span('billing', 'zip')
          expect(error_span).to have_content(t('errors.messages.invalid'))
        end
      end

      context 'shipping address' do
        scenario 'with valid data shows updated message' do
          shipping_form.fill_in_form(attributes_for(:address,
                                                    country: 'Belgium'))
          all("input[type='submit']")[1].click
          expect(page).to have_content(
            t('settings.show.address_saved', address_type: 'shipping')
          )
        end

        scenario "with empty field shows 'can`t be blank' errors" do
          shipping_form.fill_in_form(attributes_for(:address, first_name: ''))
          all("input[type='submit']")[1].click
          error_span = find_error_span('shipping', 'first_name')
          expect(error_span).to have_content(
            attr_blank_error(:address, :first_name)
          )
        end

        scenario "with invalid field shows 'invalid' errors" do
          shipping_form.fill_in_form(
            attributes_for(:address, last_name: 'name#*&@')
          )
          all("input[type='submit']")[1].click
          error_span = find_error_span('shipping', 'last_name')
          expect(error_span).to have_content(t('errors.messages.invalid'))
        end
      end
    end

    context 'with user already having addresses', use_selenium: true do
      background do
        create(:address, customer: user)
        create(:address, customer: user, address_type: 'shipping',
                         country: 'France')
        login_as(user, scope: :user)
        visit settings_path
      end

      scenario 'has correct countries selected', use_selenium: false do
        expect(find('#address_billing_country').value).to eq('Italy')
        expect(find('#address_shipping_country').value).to eq('France')
      end

      context 'selecting another billing address country' do
        background { select('Austria', from: 'address[billing][country]') }

        scenario 'changes billing address country code' do
          expect(find('#billing-phone').value).to eq('+43')
        end

        scenario 'does not change shipping address country code' do
          expect(find('#shipping-phone').value).not_to eq('+43')
        end
      end

      context 'selecting another shipping address country' do
        background { select('Australia', from: 'address[shipping][country]') }

        scenario 'changes shipping address country code' do
          expect(find('#shipping-phone').value).to eq('+61')
        end

        scenario 'does not change billing address country code' do
          expect(find('#billing-phone').value).not_to eq('+61')
        end
      end
    end
  end
end
