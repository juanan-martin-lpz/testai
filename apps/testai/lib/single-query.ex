defmodule SingleQuery do
  use GenServer

  alias LangChain.Chains.LLMChain
  alias LangChain.ChatModels.ChatOllamaAI
  alias LangChain.Message


  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def user_message(model, message) do
    GenServer.call(__MODULE__, {:user_message, model, message}, :infinity)
  end

  def system_message(model, message) do
    GenServer.call(__MODULE__, {:system_message, model, message}, :infinity)
  end

  def handle_call({:user_message, model, message}, _from, state) do
    {:ok, _updated_chain, response} =
      %{llm: ChatOllamaAI.new!(%{model: model})}
        |> LLMChain.new!()
        |> LLMChain.add_message(Message.new_user!(message))
      |> LLMChain.run()

    {:reply, response, state}
  end


  def handle_call({:system_message, model, message}, _from, state) do
    {:ok, _updated_chain, response} =
      %{llm: ChatOllamaAI.new!(%{model: model})}
        |> LLMChain.new_system!()
        |> LLMChain.add_message(Message.new_user!(message))
      |> LLMChain.run()

    {:reply, response, state}
  end

end
