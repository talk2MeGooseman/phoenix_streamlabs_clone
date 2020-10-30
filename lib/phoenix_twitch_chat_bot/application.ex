defmodule PhoenixStreamlabsClone.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    config = [
      user: "codingzeal",
      pass: Application.fetch_env!(:twitch, :chat_oauth),
      chats: ["codingzeal"],
      handler: PhoenixStreamlabsClone.Twitch,
      capabilities: ['membership']
    ]

    children = [
      # Start the Ecto repository
      PhoenixStreamlabsClone.Repo,
      # Start the Telemetry supervisor
      PhoenixStreamlabsCloneWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: PhoenixStreamlabsClone.PubSub},
      # Start the Endpoint (http/https)
      PhoenixStreamlabsCloneWeb.Endpoint,
      # Start up twitch chat bot
      {TMI.Supervisor, config}
      # Start a worker by calling: PhoenixStreamlabsClone.Worker.start_link(arg)
      # {PhoenixStreamlabsClone.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixStreamlabsClone.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhoenixStreamlabsCloneWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
