restaurant_title = 'Amelia'
desc = "
  Ресторан #{restaurant_title} вобрал в себя лучшие традиции европейской, испанской и средиземноморской кухни.
  Уютная, доброжелательная атмосфера и достойный сервис  - это основные преимущества ресторана.
  Все вышеперечисленное и плюс доступный уровень цен позволили заведению оказаться в списке лучших ресторанов.
  Секрет популярности прост - побывав здесь однажды и ощутив радушие и гостеприимство, теплый прием и
  заботливое обслуживание, гости непременно возвращаются вновь и рекомендуют  #{restaurant_title} своим друзьям.
"
lorem = '
  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore
  magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
  consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
  Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
'
Restaurant.load.update(
  title: restaurant_title,
  site: 'http://restaurant-amelia.ml',
  reserve_price: '5',
  meta_description: desc,
  address: 'Черкассы',
  api_token: Rails.application.secrets.bot_token,
  table_size: 8,
  table_count: 20,
  home_title_2: "В '#{restaurant_title}' уютно",
  home_description_2: desc,
  home_title_3: 'Lorem ipsum',
  home_description_3: lorem
)
