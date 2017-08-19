namespace :bot do
  desc 'launches bot'
  task start: :environment do
    require 'telegram/bot'

    module TelegramBotService
      class << self
        def run
          @restaurant ||= Restaurant.load

          Telegram::Bot::Client.run(@restaurant.api_token) do |bot|
            bot.listen { |message| perform(bot, message) }
          end
        end

        def perform(bot, message)
          return unless message.text.present?

          current_user ||= User.find_or_create_by(chat_id: message.from.id)
          current_reserve ||= current_user.load_reserve
          send_single_message = proc do |text|
            bot.api.send_message(
              chat_id: message.chat.id,
              text: text
            )
          end
          render_keyboard = proc do
            description = 'Нажимай кнопки внизу'
            keyboard_actions = []
            keyboard_actions << 'Количество гостей' if current_reserve.guests.nil?
            keyboard_actions << 'Дата и время' if current_reserve.datetime.nil?

            if current_user.phone.nil?
              keyboard_actions << Telegram::Bot::Types::KeyboardButton.new(
                text: 'Отправить номер телефона',
                request_contact: true
              )
            end

            under_keyboard_buttons =
              Telegram::Bot::Types::ReplyKeyboardMarkup.new(
                keyboard: [keyboard_actions],
                one_time_keyboard: false
              )
            bot.api.send_message(
              chat_id: message.chat.id,
              text: description,
              reply_markup: under_keyboard_buttons
            )
          end

          case message.text
          when '/stop'
            kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
            bot.api.send_message(
              chat_id: message.chat.id,
              text: 'Sorry to see you go :(',
              reply_markup: kb
            )
          when '/help'
            kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
            bot.api.send_message(
              chat_id: message.chat.id,
              text: 'List of commands',
              reply_markup: kb
            )
          when '/start'
            send_single_message.call(
              'Привет. Я бот для заказа столика в ресторане. Я могу помочь тебе заказать столик. Ecли хочешь сделать все быстро - используй кнопочки)'
            )
            render_keyboard.call
          when 'Количество гостей'
            current_user.update_attributes(action: 'choose_table_size')

            description = 'Выберите количество гостей'
            under_keyboard_buttons =
              Telegram::Bot::Types::ReplyKeyboardMarkup.new(
                keyboard: [
                  (1..@restaurant.table_size).to_a.map(&:to_s)
                ],
                one_time_keyboard: true
              )
            bot.api.send_message(
              chat_id: message.chat.id,
              text: description,
              reply_markup: under_keyboard_buttons
            )
          when 'Дата и время'
            current_user.update_attributes(action: 'choose_datetime')
            send_single_message.call("Теперь введите дату и время в формате(#{DateTime.now.strftime('%d.%m.%Y %H:00')})")
          else
            # actions
            case current_user.action
            when 'choose_table_size'
              return if message.text.to_i.zero?

              current_reserve.update_attributes(guests: message.text.to_i)

              bot.api.send_message(
                chat_id: message.chat.id,
                text:
                  "Выбран столик для #{current_reserve.guests} гост#{current_reserve.guests == 1 ? 'я' : 'ей'}"
              )
            when 'choose_datetime'
              return if message.text.to_time.nil?

              datetime = message.text.to_time.strftime('%d.%m.%Y %H:00')
              current_reserve.update_attributes(datetime: datetime)
              send_single_message.call datetime
            else
              p message
              send_single_message.call 'Я не понимаю тебя. Попробуй использовать кнопочки))'
            end

            current_user.update_attributes(action: 'choosing')
            render_keyboard.call
          end
        end
      end
    end

    TelegramBotService.run
  end
end
