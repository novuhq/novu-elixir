defmodule Novu.Http do
  @moduledoc """
  Helper functions for interacting with Req.
  """
  require Logger

  @user_agent "novuhq-elixir/ " <> Mix.Project.config()[:version] <> " (+https://github.com/novuhq/elixir)"

  def delete(url) do
    url
    |> build_req()
    |> Req.delete!()
    |> handle_response()
  rescue
    e -> handle_response(e)
  end

  def post(url, body) do
    url
    |> build_req()
    |> Req.post!(json: body)
    |> handle_response()
  rescue
    e -> handle_response(e)
  end

  defp api_key, do: Application.fetch_env!(:novu, :api_key)

  defp base_domain, do: Application.fetch_env!(:novu, :domain)

  defp build_req(url),
    do: Req.new(base_url: base_domain(), headers: request_headers(), url: url, user_agent: @user_agent)

  defp handle_response(%{body: body, status: status_code}) when status_code in 200..299, do: {:ok, body}
  defp handle_response(%{body: %{"errors" => errors}}), do: {:error, errors}
  defp handle_response(%Mint.TransportError{reason: :timeout}), do: {:error, :timeout}
  defp handle_response(response), do: {:error, response}

  defp request_headers do
    [
      {"accept", "application/json"},
      {"content-type", "application/json"},
      {"authorization", "ApiKey #{api_key()}"}
    ]
  end
end
