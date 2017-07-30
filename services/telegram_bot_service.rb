require 'telegram/bot'
load 'config/shared.rb'

module TelegramBotService
  class << self
    def run
      Telegram::Bot::Client.run(Restaurant::DETAILS[:api_token]) do |bot|
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
          text: "Окей, пиши если передумаешь.А пока можешь посетить наш сайт #{Restaurant::DETAILS[:site]}"
        )
        return
      end

      if agree?(message.text)
        bot.api.send_message(chat_id: message.chat.id, text: 'На какое число вы хотите заказать столик?')
        return
      end

      if goodbye?(message.text)
        bot.api.send_message(chat_id: message.chat.id, text: "Увидимся , #{message.from.first_name}")
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
      %w[Нет нет].include? message
    end

    def agree?(message)
      %w[да Да].include? message
    end

    def greetings?(message)
      %w[Привет привет].include? message
    end

    def goodbye?(message)
      %w[Пока пока Прощай прощай].include? message
    end
  end
end

TelegramBotService.run
