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
          # Variables
          @current_user = User.find_or_create_by(
            chat_id: message.from.id,
          )
          @current_reserve = @current_user.load_reserve

          send_single_message = proc do |text|
            bot.api.send_message(
              chat_id: message.chat.id,
              text: text
            )
          end
          render_keyboard = proc do
            @current_reserve ||= @current_user.load_reserve

            description = 'Нажимай кнопки внизу'
            keyboard_actions = []
            keyboard_actions << 'Количество гостей' if @current_reserve.guests.nil?
            keyboard_actions << 'Дата и время' if @current_reserve.datetime.nil?

            if @current_user.phone.nil?
              keyboard_actions << Telegram::Bot::Types::KeyboardButton.new(
                text: 'Отправить номер телефона',
                request_contact: true
              )
            end

            keyboard_actions = ['Подтвердить заказ', 'Отменить заказ'] if keyboard_actions.empty?
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
          # end of variables

          # share phone number
          unless message.contact.nil?

            @current_user.update_attributes(
              phone: message.contact.phone_number,
              name: message.from.first_name
            )
            send_single_message.call("Номер #{@current_user.phone} будет использоватся для проверки заказа")

            render_keyboard.call
          end
          # end of share phone number

          # messages
          return unless message.text.present?

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
            @current_user.update_attributes(action: 'choose_table_size')

            description = 'Выберите количество гостей'
            under_keyboard_buttons =
              Telegram::Bot::Types::ReplyKeyboardMarkup.new(
                keyboard: [(1..@restaurant.table_size).to_a.map(&:to_s)],
                one_time_keyboard: false
              )
            bot.api.send_message(
              chat_id: message.chat.id,
              text: description,
              reply_markup: under_keyboard_buttons
            )
          when 'Дата и время'
            @current_user.update_attributes(action: 'choose_datetime')
            send_single_message.call("Теперь введите дату и время в формате(#{DateTime.now.strftime('%d.%m.%Y %H:00')})")
          when 'Подтвердить заказ'
            return send_single_message.call 'Вы не можете подтвердить заказ пока не предоставили все данные. Используйте кнопки внизу' unless @current_reserve.completed?

            text = 'Ваш заказ подтвержден. Вы можете увидеть страницу заказа по ссылке указаной ниже'

            markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(
              inline_keyboard: [
                Telegram::Bot::Types::InlineKeyboardButton.new(
                  text: 'Ваш заказ',
                  url: "#{@restaurant.site}/reserve/#{@current_reserve.id}"
                )
              ]
            )

            @current_reserve.confirm!
            @current_reserve = @current_user.reserves.create

            bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: markup)

            send_single_message.call 'Я готов принять ещё один заказ.'

            render_keyboard.call
          when 'Отменить заказ'
            @current_reserve.delete
            @current_reserve = @current_user.reserves.create

            send_single_message.call('Не очень то и хотелось. Можете попробовать еще раз)')

            render_keyboard.call
          else
            # actions
            case @current_user.action
            when 'choose_table_size'
              if (message.text.to_i > 1 rescue false) && message.text.to_i <= @restaurant.table_size
                @current_reserve.update_attributes(guests: message.text.to_i)

                bot.api.send_message(
                  chat_id: message.chat.id,
                  text:
                    "Выбран столик для #{@current_reserve.guests} гост#{@current_reserve.guests == 1 ? 'я' : 'ей'}"
                )

                @current_user.update_attributes action: 'choosing'
                render_keyboard.call
              else
                send_single_message.call "Пожайлуста выберите из ниже представленых вариантов или обратитесь к администации #{@restaurant.manager_phone}"
              end
            when 'choose_datetime'
              # return if (message.text.to_time.nil? rescue true)
              if (!message.text.to_time rescue true)
                return send_single_message.call 'Такой даты не существует! Попробуй еще раз'
              end

              if message.text =~ /\d{2}\.\d{2}\.\d{4} \d{2}:\d{2}/ && message.text.to_time > DateTime.now
                datetime = message.text.to_time.strftime('%d.%m.%Y %H:00')
                @current_reserve.update_attributes(datetime: datetime)
                send_single_message.call "Мы ждем Вас #{datetime}"

                @current_user.update_attributes action: 'choosing'
                render_keyboard.call
              elsif message.text =~ /\d{2}\.\d{2}\.\d{4} \d{2}:\d{2}/ && message.text.to_time < DateTime.now
                send_single_message.call 'Машину времени еще не изобрели). Попробуйте еще раз'
              else
                send_single_message.call 'Неверный формат даты. Попробуйте еще раз'
              end
            else
              puts message
              send_single_message.call 'Я не понимаю тебя. Попробуй использовать кнопочки))'
              render_keyboard.call
            end
          end
        end
      end
    end

    TelegramBotService.run
  end
end
