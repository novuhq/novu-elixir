defmodule Novu.MessagesTest do
  use ExUnit.Case

  import Novu.ApiTestHelpers

  alias Novu.Messages

  @test_api_key "test-api-key"

  setup do
    bypass = Bypass.open()

    current_domain = Application.get_env(:novu, :domain)

    Application.put_env(:novu, :domain, "http://localhost:#{bypass.port}")
    Application.put_env(:novu, :api_key, @test_api_key)

    on_exit(fn ->
      Application.put_env(:novu, :domain, current_domain)
    end)

    {:ok, bypass: bypass}
  end

  describe "get_messages/1" do
    test "creates a GET to /v1/messages", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/v1/messages", fn conn ->
        novu_response(conn, 200, %{page: 0, totalCount: 0, pageSize: 10, data: []})
      end)

      assert {:ok, _body} = Messages.get_messages()
    end
  end

  describe "delete_subscriber/1" do
    test "creates a DELETE to /v1/messages/{messageId}", %{bypass: bypass} do
      message_id = "example-id"

      Bypass.expect(bypass, "DELETE", "/v1/messages/#{URI.encode(message_id)}", fn conn ->
        novu_response(conn, 200, %{acknowledged: true, status: "deleted"})
      end)

      assert {:ok, _body} = Messages.delete_message(message_id)
    end
  end
end
