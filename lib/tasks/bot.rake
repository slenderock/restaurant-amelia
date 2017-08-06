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
              text: "Окей, пиши если передумаешь. А пока можешь посетить наш сайт #{ @restaurant.site }"
            )
            return
          end

          if agree?(message.text)
            bot.api.send_message(chat_id: message.chat.id, text: 'На какое число вы хотите заказать столик?')
            return
          end

          if goodbye?(message.text)
            bot.api.send_message(chat_id: message.chat.id, text: "Увидимся, #{message.from.first_name}")
            return
          end

          # else
          bot.api.send_message(chat_id: message.chat.id, text: 'Я не понимаю тебя')

          # когда(время дата), сколько людей, имя
          # else
          #   bot.api.send_message(chat_id: message.chat.id, text: 'Я не понимаю тебя. Отвечай Да или Нет')
          # end
        end

        def disagree?(message)
          %w(нет).include? message.downcase
        end

        def agree?(message)
          %w(да).include? message.downcase
        end

        def greetings?(message)
          %w(привет).include? message.downcase
        end

        def goodbye?(message)
          %w(пока прощай).include? message.downcase
        end
      end
    end

    TelegramBotService.run
  end
end
