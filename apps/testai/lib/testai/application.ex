defmodule Testai.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DNSCluster, query: Application.get_env(:testai, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Testai.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Testai.Finch},
      # Start a worker by calling: Testai.Worker.start_link(arg)
      # {Testai.Worker, arg}
      {Testai.Ollama, "http://localhost:11434/api"},
      {SingleQuery, []}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Testai.Supervisor)
  end
end
