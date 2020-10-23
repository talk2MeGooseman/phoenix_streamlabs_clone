defmodule PhoenixTwitchChatBot.Twitch do
  use TMI.Handler

  @impl true
  def handle_message("!" <> command, _sender, chat) do
    case command do
      _ -> Logger.debug("Command #{command} was sent.")
    end
  end

  def handle_message(message, sender, chat) do
    Logger.debug("Message in #{chat} from #{sender}: #{message}")
  end

  def handle_join(_chat, user) do
    Logger.debug("#{user} joined the channel")
  end

  def handle_unrecognized(msg) do
    Logger.debug("Unrecognized: #{msg}")
  end
end
