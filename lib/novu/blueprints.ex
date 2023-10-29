defmodule Novu.Blueprints do
  @moduledoc """
  Provide access to the Novu Blueprints API
  """

  alias Novu.Http

  @doc """
  Retrieve the current environment

  [API Documentation](https://docs.novu.co/api-reference/get-v1blueprints)
  """
  @spec get_blueprints(transaction_id :: String.t()) :: Http.response()
  def get_blueprints(transaction_id) do
    Http.get("/v1/blueprints/#{URI.encode(transaction_id)}")
  end

  @doc """
  Returns a list of API keys

  [API Documentation](https://docs.novu.co/api-reference/get-v1blueprintsgroup-by-category)
  """
  @spec get_group_by_category :: Http.response()
  def get_group_by_category do
    Http.get("/v1/blueprints/group-by-category")
  end
end
