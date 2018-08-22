# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Source.create(url: 'http://static.ozone.ru/multimedia/yml/facet/div_soft.xml')
Source.create(url: 'http://www.trenazhery.ru/market2.xml')
Source.create(url: 'http://www.radio-liga.ru/yml.php')
Source.create(url: 'http://armprodukt.ru/bitrix/catalog_export/yandex.php')
