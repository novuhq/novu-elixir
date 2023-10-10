defmodule Novu.Messages do
  @moduledoc """
  Provide access to the Novu Messages API
  """

  alias Novu.Http

  @doc """
  Retrieves messages
  [API Documentation](https://docs.novu.co/api-reference/messages/get-messages)
  """
  @spec get_messages :: Http.response()
  def get_messages do
    Http.get("/v1/messages")
  end

  @doc """
  Delete messages
  [API Documentation](https://docs.novu.co/api-reference/messages/delete-message)
  """
  @spec delete_messages(message_id :: String.t()) :: Http.response()
  def delete_messages(message_id) do
    Http.delete("/v1/messages/#{message_id}")
  end
end
