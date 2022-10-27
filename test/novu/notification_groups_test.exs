defmodule Novu.NotificationGroupsTest do
  use ExUnit.Case

  import Novu.ApiTestHelpers

  alias Novu.NotificationGroups

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

  describe "create_notification_group/1" do
    test "creates a POST to /v1/notification-groups", %{bypass: bypass} do
      notification_group_name = "Test"

      Bypass.expect(bypass, "POST", "/v1/notification-groups", fn conn ->
        assert %{"name" => ^notification_group_name} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{name: notification_group_name}})
      end)

      assert {:ok, _body} = NotificationGroups.create_notification_group(notification_group_name)
    end
  end

  describe "get_notification_groups/0" do
    test "creates a GET to /v1/notification-groups", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/v1/notification-groups", fn conn ->
        novu_response(conn, 201, %{data: []})
      end)

      assert {:ok, _body} = NotificationGroups.get_notification_groups()
    end
  end
end
