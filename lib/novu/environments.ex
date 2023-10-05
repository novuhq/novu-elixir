defmodule Novu.Environments do
  @moduledoc """
  Provide access to the Novu Environments API
  """

  alias Novu.Http

  @doc """
  Retrieve the current environment

  [API Documentation](https://docs.novu.co/api-reference/environments/get-current-environment)
  """
  @spec get_current_environment :: Http.response()
  def get_current_environment do
    Http.get("/v1/environments/me")
  end

  @doc """
  Create a new environment using it's name. Optionally set the parent of the environment to create

  [API Documentation](https://docs.novu.co/api-reference/environments/create-environment)
  """
  @spec create_environment(name :: String.t(), opts :: Keyword.t()) :: Http.response()
  def create_environment(name, opts \\ []) do
    payload = add_optional_value(%{name: name}, :parentId, Keyword.get(opts, :parent_id))
    Http.post("/v1/environments", payload)
  end

  @doc """
  Returns a list of environments

  [API Documentation](https://docs.novu.co/api-reference/environments/get-environments)
  """
  @spec get_environments :: Http.response()
  def get_environments do
    Http.get("/v1/environments")
  end

  @doc """
  Update the environment entity with new information

  [API Documentation](https://docs.novu.co/api-reference/environments/update-env-by-id)
  """
  @spec update_environment(environment_id :: String.t(), opts :: Keyword.t()) :: Http.response()
  def update_environment(environment_id, opts \\ []) do
    dns = add_optional_value(%{}, :inboundParseDomain, Keyword.get(opts, :inbound_parse_domain))

    payload =
      %{}
      |> add_optional_value(:name, Keyword.get(opts, :name))
      |> add_optional_value(:identifier, Keyword.get(opts, :identifier))
      |> add_optional_value(:parentId, Keyword.get(opts, :parent_id))
      |> Map.put(:dns, dns)

    Http.put("/v1/environments/#{URI.encode(environment_id)}", payload)
  end

  @doc """
  Returns a list of API keys

  [API Documentation](https://docs.novu.co/api-reference/environments/get-api-keys)
  """
  @spec get_api_keys :: Http.response()
  def get_api_keys do
    Http.get("/v1/environments/api-keys")
  end

  @doc """
  Regenerate API keys

  [API Documentation](https://docs.novu.co/api-reference/environments/regenerate-api-keys)
  """
  @spec regenerate_api_keys :: Http.response()
  def regenerate_api_keys do
    Http.post("/v1/environments/api-keys/regenerate", %{})
  end

  defp add_optional_value(map, _key, nil), do: map
  defp add_optional_value(map, key, value), do: Map.put(map, key, value)
end
