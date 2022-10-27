defmodule Novu.NotificationGroups do
  @moduledoc """
  Provide access to the Novu Notification Groups API
  """

  alias Novu.Http

  @doc """
  Creates a notification group

  [API Documentation](https://docs.novu.co/api/create-notification-group/)
  """
  @spec create_notification_group(name :: String.t()) :: Http.response()
  def create_notification_group(name) do
    Http.post("/v1/notification-groups", %{name: name})
  end

  @doc """
  Retrieves a list of notifications groups

  [API Documentation](https://docs.novu.co/api/get-notification-groups/)
  """
  @spec get_notification_groups :: Http.response()
  def get_notification_groups do
    Http.get("/v1/notification-groups")
  end
end
