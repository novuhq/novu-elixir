defmodule Novu.ExecutionDetails do
  @moduledoc """
  Provide access to the Novu Execution Details API
  """

  alias Novu.Http

  @doc """
  Retrieves execution details

  [API Documentation](https://docs.novu.co/api-reference/execution-details/get-execution-details/)
  """
  @spec get_execution_details :: Http.response()
  def get_execution_details do
    Http.get("/v1/execution-details")
  end
end
