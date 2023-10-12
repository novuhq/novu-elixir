defmodule Novu.ApiTestHelpers do
  @moduledoc false

  def read_json_body(conn) do
    {:ok, body, _} = Plug.Conn.read_body(conn)
    Jason.decode!(body)
  end

  def novu_response(conn, status, body, opts \\ []) do
    %{"content-type" => "application/json"}
    |> Map.merge(Keyword.get(opts, :headers, %{}))
    |> Map.to_list()
    |> List.foldl(conn, fn {header, value}, acc_conn ->
      Plug.Conn.put_resp_header(acc_conn, header, value)
    end)
    |> Plug.Conn.resp(status, Jason.encode!(body))
  end
end
