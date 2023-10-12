defmodule Novu.HttpTest do
  use ExUnit.Case

  import Novu.ApiTestHelpers

  alias Novu.Http

  @test_api_key "test-api-key"
  @test_retry_log_level false

  setup do
    bypass = Bypass.open()

    current_domain = Application.get_env(:novu, :domain)

    Application.put_env(:novu, :domain, "http://localhost:#{bypass.port}")
    Application.put_env(:novu, :api_key, @test_api_key)
    Application.put_env(:novu, :retry_log_level, @test_retry_log_level)

    on_exit(fn ->
      Application.put_env(:novu, :domain, current_domain)
    end)

    {:ok, bypass: bypass}
  end

  describe "build_req/1" do
    test "creates a request with a minimum delay", %{bypass: bypass} do
      wait_min = 100
      Application.put_env(:novu, :wait_min, wait_min)
      Application.put_env(:novu, :max_retries, 1)

      Bypass.expect(bypass, "GET", "/", fn conn ->
        novu_response(conn, 500, %{data: %{error: "Internal Server Error"}})
      end)

      start_timer = Time.utc_now()
      Http.get("/")
      stop_timer = Time.utc_now()

      assert_in_delta wait_min, Time.diff(stop_timer, start_timer, :millisecond), 50
    end

    test "creates a request with a maximum delay", %{bypass: bypass} do
      wait_max = 100
      Application.put_env(:novu, :wait_min, 100)
      Application.put_env(:novu, :wait_max, wait_max)
      Application.put_env(:novu, :max_retries, 2)

      Bypass.expect(bypass, "GET", "/", fn conn ->
        novu_response(conn, 500, %{data: %{error: "Internal Server Error"}})
      end)

      start_timer = Time.utc_now()
      Http.get("/")
      stop_timer = Time.utc_now()
      assert_in_delta 200, Time.diff(stop_timer, start_timer, :millisecond), 50
    end

    test "retry based on Retry-After header", %{bypass: bypass} do
      Application.put_env(:novu, :max_retries, 1)

      Bypass.expect(bypass, "GET", "/", fn conn ->
        novu_response(conn, 429, %{data: %{error: "Internal Server Error"}}, headers: %{"Retry-After" => "2"})
      end)

      start_timer = Time.utc_now()
      Http.get("/")
      stop_timer = Time.utc_now()

      assert_in_delta 2000, Time.diff(stop_timer, start_timer, :millisecond), 50
    end
  end
end
