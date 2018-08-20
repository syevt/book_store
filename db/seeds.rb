require 'database_cleaner'
require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

DatabaseCleaner.clean_with(:truncation)

numbers = { users: 5, categories: 4, authors: 20, books: 50 }

User.skip_callback(:create, :after, :send_welcome_user)

create(:user, admin: true, email: 'admin@bookstore.com', password: '11111111')
create_list(:user, numbers[:users])

User.set_callback(:create, :after, :send_welcome_user)

categories = create_list(:category, numbers[:categories])

materials =
  ['hardcover', 'paperback', 'leather', 'vinyl', 'ivory',
   'off-white paper', 'low-white paper', 'glossy paper'].map do |material|
    create(:material, name: material)
  end

authors = create_list(:author, numbers[:authors])

portraits_glob = Dir.glob('~/Pictures/books/portrait/*.*')
portrait_images = portraits_glob.map { |file| File.open(file) }

landscapes_glob = Dir.glob('~/Pictures/books/landscape/*.*')
landscape_images = landscapes_glob.map { |file| File.open(file) }

numbers[:books].times do |i|
  book = Book.new
  book.main_image = portrait_images.sample
  book.images = landscape_images.sample(3)
  book.title = Faker::Book.title.truncate(70)
  book.year = (1997..2016).to_a.sample
  book.description = Faker::Hipster.paragraph(9, false, 17).truncate(990)
  book.height = rand(8..15)
  book.width = rand(4..7)
  book.thickness = rand(1..3)
  book.category = categories.sample
  book.price = (rand(4.99..119.99) * 20).round / 20.0
  book.materials.concat [materials[rand(0..4)], materials[rand(5..7)]]
  book.authors.concat authors.sample(rand(1..3))
  book.created_at = DateTime.now - (numbers[:books] - i).days
  book.save!
end

10.times { |i| create(:coupon, code: i.to_s * 6, expires: DateTime.now + 2.year) }
