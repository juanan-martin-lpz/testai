defmodule Testai.Ollama do
  use GenServer

  @moduledoc """
  Testai keeps the contexts that define your domain
  and business logic.
  """

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init_ollama(host) do
    GenServer.call(__MODULE__, {:init, host})
  end

  def pull_model(client, model) do
    GenServer.call(__MODULE__, {:pull_model, client, model}, :infinity)
  end


  def list_models(client) do
    GenServer.call(__MODULE__, {:list_models, client}, :infinity)
  end

  @impl true
  def init(_args) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:init, host}, _from, state) do
    client = Ollama.init(host)
    {:reply, client, state}
  end

  @impl true
  def handle_call({:pull_model, client, model}, _from, state) do
    { :ok, status } = Ollama.pull_model(client, name: model)
    {:reply, { status, client, model}, state}
  end

  @impl true
  def handle_call({:list_models, client}, _from, state) do
    {:ok, models} = Ollama.list_models(client)
    {:reply, models, state}
  end
end
