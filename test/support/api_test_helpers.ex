defmodule Novu.ApiTestHelpers do
  @moduledoc false

  def read_json_body(conn) do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    Jason.decode!(body)
  end

  def novu_response(conn, status, body) do
    conn
    |> Plug.Conn.put_resp_header("content-type", "application/json")
    |> Plug.Conn.resp(status, Jason.encode!(body))
  end
end
