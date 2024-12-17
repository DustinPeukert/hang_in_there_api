# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Poster.destroy_all

Poster.create!(name: "REGRET",
               description: "Hard work rarely pays off.",
               price: 89.00,
               year: 2019,
               vintage: true,
               img_url: "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
)

Poster.create!(name: "DISAPPOINTMENT",
               description: "This is what your parents think of you.",
               price: 108.00,
               year: 2020,
               vintage: false,
               img_url: "https://images.unsplash.com/photo-1620401537439-98e94c004b0d"
)

Poster.create!(name: "SADNESS",
               description: "Let the depression take over.",
               price: 65.00,
               year: 2018,
               vintage: false,
               img_url: "https://images.unsplash.com/photo-1551993005-75c4131b6bd8"
)

puts "Seeded Successfully!"