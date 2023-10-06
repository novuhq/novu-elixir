defmodule Novu.EnvironmentsTest do
  use ExUnit.Case

  import Novu.ApiTestHelpers

  alias Novu.Environments

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

  describe "get_current_environment/0" do
    test "creates a GET to /v1/environments/me", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/v1/environments/me", fn conn ->
        novu_response(conn, 200, %{data: %{data: %{name: "example-name"}}})
      end)

      assert {:ok, _body} = Environments.get_current_environment()
    end
  end

  describe "create_environment/2" do
    test "creates a POST to /v1/environments", %{bypass: bypass} do
      name = "example-name"

      Bypass.expect(bypass, "POST", "/v1/environments", fn conn ->
        assert %{"name" => ^name} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{data: %{name: "example-name"}}})
      end)

      assert {:ok, _body} = Environments.create_environment(name)
    end

    test "supports optional parentId", %{bypass: bypass} do
      name = "example-name"
      parent_id = "example-id"

      Bypass.expect(bypass, "POST", "/v1/environments", fn conn ->
        assert %{"name" => ^name, "parentId" => ^parent_id} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{data: %{name: name}}})
      end)

      assert {:ok, _body} = Environments.create_environment(name, parent_id: parent_id)
    end
  end

  describe "get_environments/0" do
    test "creates a GET to /v1/environments", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/v1/environments", fn conn ->
        novu_response(conn, 200, %{data: %{data: %{name: "example-name"}}})
      end)

      assert {:ok, _body} = Environments.get_environments()
    end
  end

  describe "update_environment/2" do
    test "creates a PUT to /v1/environments/{environmentId}", %{bypass: bypass} do
      environment_id = "example-id"

      Bypass.expect(bypass, "PUT", "/v1/environments/#{URI.encode(environment_id)}", fn conn ->
        assert %{} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{data: %{name: "example-name"}}})
      end)

      assert {:ok, _body} = Environments.update_environment(environment_id)
    end

    test "supports optional name", %{bypass: bypass} do
      name = "example-name"
      environment_id = "example-id"

      Bypass.expect(bypass, "PUT", "/v1/environments/#{URI.encode(environment_id)}", fn conn ->
        assert %{"name" => ^name} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{data: %{name: name}}})
      end)

      assert {:ok, _body} = Environments.update_environment(environment_id, name: name)
    end

    test "supports optional identifier", %{bypass: bypass} do
      identifier = "example-identifier"
      environment_id = "example-id"

      Bypass.expect(bypass, "PUT", "/v1/environments/#{URI.encode(environment_id)}", fn conn ->
        assert %{"identifier" => ^identifier} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{data: %{identifier: identifier}}})
      end)

      assert {:ok, _body} = Environments.update_environment(environment_id, identifier: identifier)
    end

    test "supports optional parentId", %{bypass: bypass} do
      parent_id = "example-parentId"
      environment_id = "example-id"

      Bypass.expect(bypass, "PUT", "/v1/environments/#{URI.encode(environment_id)}", fn conn ->
        assert %{"parentId" => ^parent_id} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{data: %{parentId: parent_id}}})
      end)

      assert {:ok, _body} = Environments.update_environment(environment_id, parent_id: parent_id)
    end

    test "supports optional inboundParseDomain", %{bypass: bypass} do
      inbound_parse_domain = "dev.example"
      environment_id = "example-id"

      Bypass.expect(bypass, "PUT", "/v1/environments/#{URI.encode(environment_id)}", fn conn ->
        assert %{"dns" => %{"inboundParseDomain" => ^inbound_parse_domain}} = read_json_body(conn)
        novu_response(conn, 200, %{data: %{data: %{inboundParseDomain: inbound_parse_domain}}})
      end)

      assert {:ok, _body} = Environments.update_environment(environment_id, inbound_parse_domain: inbound_parse_domain)
    end
  end

  describe "get_api_keys/0" do
    test "creates a GET to /v1/environments/api-keys", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/v1/environments/api-keys", fn conn ->
        novu_response(conn, 200, %{data: %{data: %{name: "example-name"}}})
      end)

      assert {:ok, _body} = Environments.get_api_keys()
    end
  end

  describe "regenerate_api_keys/0" do
    test "creates a POST to /v1/environments/api-keys/regenerate", %{bypass: bypass} do
      Bypass.expect(bypass, "POST", "/v1/environments/api-keys/regenerate", fn conn ->
        assert %{} = read_json_body(conn)
        novu_response(conn, 201, %{data: %{data: %{name: "example-name"}}})
      end)

      assert {:ok, _body} = Environments.regenerate_api_keys()
    end
  end
end
