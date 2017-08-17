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
          case message
          when Telegram::Bot::Types::CallbackQuery
            # Here you can handle your callbacks from inline buttons
            if message.data == 'touch'
              bot.api.send_message(chat_id: message.from.id, text: "Don't touch me!")
            end

            # when Telegram::Bot::Types::InlineQuery
            #   results = [
            #     [1, 'First article', 'Very interesting text goes here.'],
            #     [2, 'Second article', 'Another interesting text here.']
            #   ].map do |arr|
            #     Telegram::Bot::Types::InlineQueryResultArticle.new(
            #       id: arr[0],
            #       title: arr[1],
            #       input_message_content:
            #         Telegram::Bot::Types::InputTextMessageContent.new(message_text: arr[2])
            #     )
            #   end

            bot.api.answer_inline_query(inline_query_id: message.id, results: results)
          when Telegram::Bot::Types::Message
            return unless message.text.present?

            if message.text == '/start'
              question = 'Pick a language'
              # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
              answers =
                Telegram::Bot::Types::ReplyKeyboardMarkup.new(
                  keyboard: [%w[Русский Украинский], %w[Английский]],
                  one_time_keyboard: true
                )
              bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)
              return
            end

            if message.text == '/stop'
              # See more: https://core.telegram.org/bots/api#replykeyboardremove
              kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
              bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)
              return
            end

            if message.text == '/help'
              kb = Telegram::Bot::Types::ReplyKeyboardRemove.new(remove_keyboard: true)
              bot.api.send_message(chat_id: message.chat.id, text: 'List of commands', reply_markup: kb)
              return
            end

            if message.text == '/loc'
              kb = [
                Telegram::Bot::Types::KeyboardButton.new(text: 'Give me your phone number', request_contact: true),
                Telegram::Bot::Types::KeyboardButton.new(text: 'Show me your location', request_location: true)
              ]
              markup = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: kb)
              bot.api.send_message(chat_id: message.chat.id, text: 'Hey!', reply_markup: markup)
              return
            end

            if greetings?(message.text)
              bot.api.send_message(
                chat_id: message.chat.id,
                text: "Здравствуйте, #{message.from.first_name}. Хотите заказать столик в ресторане?"
              )
              return
            end

            if disagree?(message.text)
              bot.api.send_message(
                chat_id: message.chat.id,
                text: "Окей, пиши если передумаешь. А пока можешь посетить наш сайт #{@restaurant.site}"
              )
              return
            end

            if agree?(message.text)
              bot.api.send_message(
                chat_id: message.chat.id,
                text: 'На какое число вы хотите заказать столик?'
              )
              return
            end

            if goodbye?(message.text)
              bot.api.send_message(
                chat_id: message.chat.id,
                text: "Увидимся, #{message.from.first_name}"
              )
              return
            end

            if date?(message.text)
              bot.api.send_message(
                chat_id: message.chat.id,
                text: "Выбрана дата: #{message.text.to_time}"
              )
              return
            end

            # else
            bot.api.send_message(chat_id: message.chat.id, text: 'Я не понимаю тебя')

            # когда(время дата), сколько людей, имя, телефон
            # else
            #   bot.api.send_message(
            #     chat_id: message.chat.id,
            #     text: 'Я не понимаю тебя. Отвечай Да или Нет'
            #   )
            # end
          end
        end

        def disagree?(message)
          %w[нет].include? message.downcase
        end

        def agree?(message)
          %w[да].include? message.downcase
        end

        def greetings?(message)
          %w[привет].include? message.downcase
        end

        def goodbye?(message)
          %w[пока прощай].include? message.downcase
        end

        def date?(message)
          message.to_date
        end
      end
    end

    TelegramBotService.run
  end
end
