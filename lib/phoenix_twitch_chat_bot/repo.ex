defmodule PhoenixTwitchChatBot.Repo do
  use Ecto.Repo,
    otp_app: :phoenix_twitch_chat_bot,
    adapter: Ecto.Adapters.Postgres
end
