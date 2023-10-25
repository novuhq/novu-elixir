defmodule Novu.BlueprintsTest do
  use ExUnit.Case

  import Novu.ApiTestHelpers

  alias Novu.Blueprints

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

  describe "get_blueprints/1" do
    test "creates a GET to /v1/blueprints", %{bypass: bypass} do
      template_id = "template_id"

      Bypass.expect(bypass, "GET", "/v1/blueprints//#{URI.encode(template_id)}", fn conn ->
        novu_response(conn, 200, %{data: %{templateId: template_id}})
      end)

      assert {:ok, _body} = Blueprints.get_blueprints(template_id)
    end
  end

  describe "get_group_by_category" do
    test "creates a GET to /v1/blueprints/group-by-category", %{bypass: bypass} do
      Bypass.expect(bypass, "GET", "/v1/blueprints/group-by-category", fn conn ->
        novu_response(conn, 201, %{data: []})
      end)

      assert {:ok, _body} = Blueprints.get_group_by_category()
    end
  end
end
