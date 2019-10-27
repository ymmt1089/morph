# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create!(
  [
    {
      email:"aaa@aaa",
      password: "aaaaaa",
      admin_name:"admin_name",
    }
  ]
)

User.create!(
  [
    {
      email:"xxx@xxx",
      password:"xxxxxx",
      user_name:"xxx_name",
    },
    {
      email:"yyy@yyy",
      password: "yyyyyy",
      user_name:"yyy_name",
    },
    {
      email: "zzz@zzz",
      password: "zzzzzz",
      user_name:"zzz_name",
    }
  ]
)