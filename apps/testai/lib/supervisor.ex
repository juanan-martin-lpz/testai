defmodule Supervisor.TestAI.Configurator do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(name) do
    children = [
      {Testai.Ollama, "http://localhost:11434/api"},
    ]

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
