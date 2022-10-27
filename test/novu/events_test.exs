defmodule Novu.EventsTest do
  use ExUnit.Case

  import Novu.ApiTestHelpers

  alias Novu.Events

  @test_api_key "test-api-key"
  @recipient "test-user"

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

  describe "broadcast_to_all/3" do
    test "creates a POST to /v1/events/trigger/broadcast", %{bypass: bypass} do
      Bypass.expect(bypass, "POST", "/v1/events/trigger/broadcast", fn conn ->
        novu_response(conn, 201, %{status: "pending", acknowledged: true})
      end)

      assert {:ok, _body} = Events.broadcast_to_all("test-event", %{one: "uno"})
    end

    test "supports optional transactionId", %{bypass: bypass} do
      transaction_id = "example-id"

      Bypass.expect(bypass, "POST", "/v1/events/trigger/broadcast", fn conn ->
        assert %{"transactionId" => ^transaction_id} = read_json_body(conn)
        novu_response(conn, 201, %{status: "pending", acknowledged: true, transactionId: transaction_id})
      end)

      assert {:ok, _body} = Events.broadcast_to_all("test-event", %{one: "uno"}, transaction_id: transaction_id)
    end

    test "supports optional overrides", %{bypass: bypass} do
      Bypass.expect(bypass, "POST", "/v1/events/trigger/broadcast", fn conn ->
        assert %{"overrides" => %{"two" => "dos"}} = read_json_body(conn)
        novu_response(conn, 201, %{status: "pending", acknowledged: true})
      end)

      assert {:ok, _body} = Events.broadcast_to_all("test-event", %{one: "uno"}, overrides: %{two: "dos"})
    end
  end

  describe "cancel_event/1" do
    test "creates a DELETE to /v1/events/cancel/{transactionId}", %{bypass: bypass} do
      transaction_id = "example-id"

      Bypass.expect(bypass, "DELETE", "/v1/events/trigger/#{transaction_id}", fn conn ->
        novu_response(conn, 200, %{})
      end)

      assert {:ok, _body} = Events.cancel_event(transaction_id)
    end
  end

  describe "trigger_event/4" do
    test "creates a POST to /v1/events/trigger", %{bypass: bypass} do
      Bypass.expect(bypass, "POST", "/v1/events/trigger", fn conn ->
        novu_response(conn, 201, %{status: "pending", acknowledged: true})
      end)

      assert {:ok, _body} = Events.trigger_event("test-event", %{one: "uno"}, @recipient)
    end

    test "supports optional transactionId", %{bypass: bypass} do
      transaction_id = "example-id"

      Bypass.expect(bypass, "POST", "/v1/events/trigger", fn conn ->
        assert %{"transactionId" => ^transaction_id} = read_json_body(conn)
        novu_response(conn, 201, %{status: "pending", acknowledged: true, transactionId: transaction_id})
      end)

      assert {:ok, _body} =
               Events.trigger_event("test-event", %{one: "uno"}, @recipient, transaction_id: transaction_id)
    end

    test "supports optional overrides", %{bypass: bypass} do
      Bypass.expect(bypass, "POST", "/v1/events/trigger", fn conn ->
        assert %{"overrides" => %{"two" => "dos"}} = read_json_body(conn)
        novu_response(conn, 201, %{status: "pending", acknowledged: true})
      end)

      assert {:ok, _body} = Events.trigger_event("test-event", %{one: "uno"}, @recipient, overrides: %{two: "dos"})
    end
  end
end
