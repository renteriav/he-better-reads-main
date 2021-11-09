20.times do
    Author.create!(
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      description: Faker::Lorem.paragraph
    )
end

20.times do
    Book.create!(
        author_id: rand(1..20),
        title: Faker::Book.title,
        description: Faker::Lorem.paragraph
    )
end