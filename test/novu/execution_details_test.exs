defmodule Novu.ExecutionDetailsTest do
  use ExUnit.Case

  import Novu.ApiTestHelpers

  alias Novu.ExecutionDetails

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

  describe "get-execution-details/1" do
    test "creates a GET to /v1/execution-details", %{bypass: bypass} do
      notification_group_name = "Test"

      Bypass.expect(bypass, "GET", "/v1/execution-details", fn conn ->
        novu_response(conn, 200, %{data: []})
      end)

      assert {:ok, _body} = ExecutionDetails.get_execution_details()
    end
  end
end
