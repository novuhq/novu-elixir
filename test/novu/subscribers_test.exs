defmodule Novu.SubscribersTest do
  use ExUnit.Case

  import Novu.ApiTestHelpers

  alias Novu.Subscribers

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

  describe "get_subscribers/1" do
    test "creates a GET to /v1/subscribers", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/v1/subscribers", fn conn ->
        novu_response(conn, 200, %{page: 0, totalCount: 0, pageSize: 10, data: []})
      end)

      assert {:ok, _body} = Subscribers.get_subscribers()
    end

    test "supports optional page", %{bypass: bypass} do
      page = 2

      Bypass.expect(bypass, "GET", "/v1/subscribers", fn conn ->
        page_param = to_string(page)
        assert %{"page" => ^page_param} = conn.query_params
        novu_response(conn, 200, %{page: 2, totalCount: 0, pageSize: 10, data: []})
      end)

      assert {:ok, _body} = Subscribers.get_subscribers(page: page)
    end
  end

  describe "create_subscriber/2" do
    test "creates a POST to /v1/subscribers", %{bypass: bypass} do
      subscriber_id = "example-id"

      Bypass.expect(bypass, "POST", "/v1/subscribers", fn conn ->
        assert %{"subscriberId" => ^subscriber_id} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.create_subscriber(subscriber_id)
    end

    test "supports optional email", %{bypass: bypass} do
      subscriber_id = "example-id"
      email = "test@example.com"

      Bypass.expect(bypass, "POST", "/v1/subscribers", fn conn ->
        assert %{"subscriberId" => ^subscriber_id, "email" => ^email} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.create_subscriber(subscriber_id, email: email)
    end

    test "supports optional first_name", %{bypass: bypass} do
      subscriber_id = "example-id"
      first_name = "test"

      Bypass.expect(bypass, "POST", "/v1/subscribers", fn conn ->
        assert %{"subscriberId" => ^subscriber_id, "firstName" => ^first_name} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.create_subscriber(subscriber_id, first_name: first_name)
    end

    test "supports optional last_name", %{bypass: bypass} do
      subscriber_id = "example-id"
      last_name = "test"

      Bypass.expect(bypass, "POST", "/v1/subscribers", fn conn ->
        assert %{"subscriberId" => ^subscriber_id, "lastName" => ^last_name} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.create_subscriber(subscriber_id, last_name: last_name)
    end

    test "supports optional phone", %{bypass: bypass} do
      subscriber_id = "example-id"
      phone = "+15551234567"

      Bypass.expect(bypass, "POST", "/v1/subscribers", fn conn ->
        assert %{"subscriberId" => ^subscriber_id, "phone" => ^phone} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.create_subscriber(subscriber_id, phone: phone)
    end

    test "supports optional avatar", %{bypass: bypass} do
      subscriber_id = "example-id"
      avatar = "https://i.pravatar.cc/150"

      Bypass.expect(bypass, "POST", "/v1/subscribers", fn conn ->
        assert %{"subscriberId" => ^subscriber_id, "avatar" => ^avatar} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.create_subscriber(subscriber_id, avatar: avatar)
    end
  end

  describe "get_subscriber/1" do
    test "creates a GET to /v1/subscribers/{subscriberId}", %{bypass: bypass} do
      subscriber_id = "example-id"

      Bypass.expect(bypass, "GET", "/v1/subscribers/#{URI.encode(subscriber_id)}", fn conn ->
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.get_subscriber(subscriber_id)
    end
  end

  describe "update_subscriber/2" do
    test "creates a POST to /v1/subscribers/{subscriberId}", %{bypass: bypass} do
      subscriber_id = "example-id"

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}", fn conn ->
        assert %{} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.update_subscriber(subscriber_id)
    end

    test "supports optional email", %{bypass: bypass} do
      subscriber_id = "example-id"
      email = "test@example.com"

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}", fn conn ->
        assert %{"email" => ^email} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.update_subscriber(subscriber_id, email: email)
    end

    test "supports optional first_name", %{bypass: bypass} do
      subscriber_id = "example-id"
      first_name = "test"

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}", fn conn ->
        assert %{"firstName" => ^first_name} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.update_subscriber(subscriber_id, first_name: first_name)
    end

    test "supports optional last_name", %{bypass: bypass} do
      subscriber_id = "example-id"
      last_name = "test"

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}", fn conn ->
        assert %{"lastName" => ^last_name} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.update_subscriber(subscriber_id, last_name: last_name)
    end

    test "supports optional phone", %{bypass: bypass} do
      subscriber_id = "example-id"
      phone = "+15551234567"

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}", fn conn ->
        assert %{"phone" => ^phone} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.update_subscriber(subscriber_id, phone: phone)
    end

    test "supports optional avatar", %{bypass: bypass} do
      subscriber_id = "example-id"
      avatar = "https://i.pravatar.cc/150"

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}", fn conn ->
        assert %{"avatar" => ^avatar} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.update_subscriber(subscriber_id, avatar: avatar)
    end
  end

  describe "delete_subscriber/1" do
    test "creates a DELETE to /v1/subscribers/{subscriberId}", %{bypass: bypass} do
      subscriber_id = "example-id"

      Bypass.expect(bypass, "DELETE", "/v1/subscribers/#{URI.encode(subscriber_id)}", fn conn ->
        novu_response(conn, 200, %{acknowledged: true, status: "deleted"})
      end)

      assert {:ok, _body} = Subscribers.delete_subscriber(subscriber_id)
    end
  end

  describe "update_subscriber_credentials/3" do
    test "creates a PUT to /v1/subscribers/{subscriberId}/credentials", %{bypass: bypass} do
      subscriber_id = "example-id"
      provider_id = "provider-id"

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}/credentials", fn conn ->
        assert %{"providerId" => ^provider_id} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} = Subscribers.update_subscriber_credentials(subscriber_id, provider_id)
    end

    test "supports optional webhook_url", %{bypass: bypass} do
      subscriber_id = "example-id"
      provider_id = "provider-id"
      webhook_url = "https://example.com/webhooks"

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}/credentials", fn conn ->
        assert %{"providerId" => ^provider_id, "credentials" => %{"webhookUrl" => ^webhook_url}} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} =
               Subscribers.update_subscriber_credentials(subscriber_id, provider_id, webhook_url: webhook_url)
    end

    test "supports optional device_tokens array", %{bypass: bypass} do
      subscriber_id = "example-id"
      provider_id = "provider-id"
      device_tokens = ["abc", "123"]

      Bypass.expect(bypass, "PUT", "/v1/subscribers/#{URI.encode(subscriber_id)}/credentials", fn conn ->
        assert %{"providerId" => ^provider_id, "credentials" => %{"deviceTokens" => ^device_tokens}} =
                 read_json_body(conn)

        novu_response(conn, 200, %{data: %{subscriberId: subscriber_id}})
      end)

      assert {:ok, _body} =
               Subscribers.update_subscriber_credentials(subscriber_id, provider_id, device_tokens: device_tokens)
    end
  end

  describe "get_subscriber_preferences/1" do
    test "creates a GET to /v1/subscribers/{subscriberId}/preferences", %{bypass: bypass} do
      subscriber_id = "example-id"

      Bypass.expect(bypass, "GET", "/v1/subscribers/#{URI.encode(subscriber_id)}/preferences", fn conn ->
        novu_response(conn, 200, %{data: []})
      end)

      assert {:ok, _body} = Subscribers.get_subscriber_preferences(subscriber_id)
    end
  end

  describe "update_subscriber_preferences/4" do
    test "creates a PATCH to /v1/subscribers/{subscriberId}/preferences/{templateId}", %{bypass: bypass} do
      subscriber_id = "example-id"
      template_id = "template-id"
      type = "in_app"
      enabled = false

      Bypass.expect(
        bypass,
        "PATCH",
        "/v1/subscribers/#{URI.encode(subscriber_id)}/preferences/#{template_id}",
        fn conn ->
          assert %{"channel" => %{"type" => ^type, "enabled" => ^enabled}} = read_json_body(conn)
          novu_response(conn, 200, %{data: []})
        end
      )

      assert {:ok, _body} = Subscribers.update_subscriber_preferences(subscriber_id, template_id, type, enabled)
    end
  end

  describe "get_notification_feed/2" do
    test "creates a GET to /v1/subscribers/{subscriberId}/notifications/feed", %{bypass: bypass} do
      subscriber_id = "example-id"

      Bypass.expect(bypass, "GET", "/v1/subscribers/#{URI.encode(subscriber_id)}/notifications/feed", fn conn ->
        assert %{"page" => "0"} = conn.query_params
        novu_response(conn, 200, %{data: []})
      end)

      assert {:ok, _body} = Subscribers.get_notification_feed(subscriber_id)
    end

    test "supports optional page", %{bypass: bypass} do
      subscriber_id = "example-id"
      page = 2

      Bypass.expect(bypass, "GET", "/v1/subscribers/#{URI.encode(subscriber_id)}/notifications/feed", fn conn ->
        page_param = to_string(page)
        assert %{"page" => ^page_param} = conn.query_params
        novu_response(conn, 200, %{data: []})
      end)

      assert {:ok, _body} = Subscribers.get_notification_feed(subscriber_id, page: page)
    end

    test "supports optional feed_identifier", %{bypass: bypass} do
      subscriber_id = "example-id"
      feed_identifier = "feed-id"

      Bypass.expect(bypass, "GET", "/v1/subscribers/#{URI.encode(subscriber_id)}/notifications/feed", fn conn ->
        assert %{"page" => "0", "feedIdentifier" => ^feed_identifier} = conn.query_params
        novu_response(conn, 200, %{data: []})
      end)

      assert {:ok, _body} = Subscribers.get_notification_feed(subscriber_id, feed_identifier: feed_identifier)
    end

    test "supports optional seen", %{bypass: bypass} do
      subscriber_id = "example-id"
      seen = false

      Bypass.expect(bypass, "GET", "/v1/subscribers/#{URI.encode(subscriber_id)}/notifications/feed", fn conn ->
        seen_param = to_string(seen)
        assert %{"page" => "0", "seen" => ^seen_param} = conn.query_params
        novu_response(conn, 200, %{data: []})
      end)

      assert {:ok, _body} = Subscribers.get_notification_feed(subscriber_id, seen: seen)
    end
  end

  describe "get_unseen_count/2" do
    test "creates a GET to /v1/subscribers/{subscriberId}/notifications/unseen", %{bypass: bypass} do
      subscriber_id = "example-id"

      Bypass.expect(bypass, "GET", "/v1/subscribers/#{URI.encode(subscriber_id)}/notifications/unseen", fn conn ->
        novu_response(conn, 200, %{data: %{"count" => 0}})
      end)

      assert {:ok, _body} = Subscribers.get_unseen_count(subscriber_id)
    end

    test "supports optional seen", %{bypass: bypass} do
      subscriber_id = "example-id"
      seen = true

      Bypass.expect(bypass, "GET", "/v1/subscribers/#{URI.encode(subscriber_id)}/notifications/unseen", fn conn ->
        seen_param = to_string(seen)
        assert %{"seen" => ^seen_param} = conn.query_params
        novu_response(conn, 200, %{data: %{"count" => 0}})
      end)

      assert {:ok, _body} = Subscribers.get_unseen_count(subscriber_id, seen: seen)
    end
  end

  describe "mark_message_as_seen/2" do
    test "creates a POST to /v1/subscribers/{subscriberId}/messages/{messageId}/seen", %{bypass: bypass} do
      subscriber_id = "example-id"
      message_id = "message-id"

      Bypass.expect(
        bypass,
        "POST",
        "/v1/subscribers/#{URI.encode(subscriber_id)}/messages/#{message_id}/seen",
        fn conn ->
          novu_response(conn, 201, %{data: %{"seen" => true}})
        end
      )

      assert {:ok, _body} = Subscribers.mark_message_as_seen(subscriber_id, message_id)
    end
  end

  describe "mark_action_as_seen/3" do
    test "creates a POST to /v1/subscribers/{subscriberId}/messages/{messageId}/actions/{type}", %{bypass: bypass} do
      subscriber_id = "example-id"
      message_id = "message-id"
      type = "secondary"

      Bypass.expect(
        bypass,
        "POST",
        "/v1/subscribers/#{URI.encode(subscriber_id)}/messages/#{message_id}/actions/#{type}",
        fn conn ->
          novu_response(conn, 201, %{data: %{"seen" => true}})
        end
      )

      assert {:ok, _body} = Subscribers.mark_action_as_seen(subscriber_id, message_id, type)
    end
  end
end
