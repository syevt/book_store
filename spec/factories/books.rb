FactoryBot.define do
  factory :book do
    title "MyString"
    description "MyText"
    year 1
    width 1
    height 1
    thickness 1
    price "9.99"
    main_image ""
    images ""
    category nil
  end
end
