defmodule Novu.Http do
  @moduledoc """
  A basic HTTP client for Novu using `Req`. Any request made with these modules
  will include base headers, authentication, response parsing, and error
  handling.
  """

  require Logger

  @user_agent "novu/elixir@ " <> Mix.Project.config()[:version]

  @type response() :: {:ok, map()} | {:error, list() | :timeout | any()}

  @max_retries 0

  @doc """
  Makes a `DELETE` request to Novu.
  """
  @spec delete(url :: Req.url()) :: response()
  def delete(url) do
    url
    |> build_req()
    |> Req.delete!()
    |> handle_response()
  rescue
    e -> handle_response(e)
  end

  @doc """
  Makes a `GET` request to Novu.
  """
  @spec get(url :: Req.url(), params :: map()) :: response()
  def get(url, params \\ %{}) do
    url
    |> build_req()
    |> Req.get!(params: params)
    |> handle_response()
  rescue
    e -> handle_response(e)
  end

  @doc """
  Makes a `PATCH` request to Novu.
  """
  @spec patch(url :: Req.url(), body :: map()) :: response()
  def patch(url, body) do
    url
    |> build_req()
    |> Req.patch!(json: body)
    |> handle_response()
  rescue
    e -> handle_response(e)
  end

  @doc """
  Makes a `POST` request to Novu.
  """
  @spec post(url :: Req.url(), body :: map()) :: response()
  def post(url, body) do
    url
    |> build_req()
    |> Req.post!(json: body)
    |> handle_response()
  rescue
    e -> handle_response(e)
  end

  @doc """
  Makes a `PUT` request to Novu.
  """
  @spec put(url :: Req.url(), params :: map()) :: response()
  def put(url, body) do
    url
    |> build_req()
    |> Req.put!(json: body)
    |> handle_response()
  rescue
    e -> handle_response(e)
  end

  defp api_key, do: Application.fetch_env!(:novu, :api_key)

  defp base_domain, do: Application.fetch_env!(:novu, :domain)

  defp wait_min, do: Application.get_env(:novu, :wait_min, 1000)
  defp wait_max, do: Application.get_env(:novu, :wait_max, 10_000)
  defp max_retries, do: Application.get_env(:novu, :max_retries, @max_retries)
  defp retry_log_level, do: Application.get_env(:novu, :retry_log_level, :warning)

  defp retry_delay_function(n) do
    min(Integer.pow(2, n) * wait_min(), wait_max())
  end

  defp build_req(url),
    do:
      Req.new(
        base_url: base_domain(),
        headers: request_headers(),
        url: url,
        user_agent: @user_agent,
        retry: :transient,
        retry_delay: &retry_delay_function/1,
        max_retries: max_retries(),
        retry_log_level: retry_log_level()
      )

  defp handle_response(%{body: body, status: status_code}) when status_code in 200..299, do: {:ok, body}
  defp handle_response(%{body: %{"errors" => errors}}), do: {:error, errors}
  defp handle_response(%Mint.TransportError{reason: :timeout}), do: {:error, :timeout}
  defp handle_response(response), do: {:error, response}

  defp request_headers do
    [
      {"accept", "application/json"},
      {"content-type", "application/json"},
      {"authorization", "ApiKey #{api_key()}"},
      {"idempotency-key", UUID.uuid4()}
    ]
  end
end
