defmodule Novu.Subscribers do
  @moduledoc """
  Provide access to the Novu Subscribers API
  """

  alias Novu.Http

  @doc """
  Returns a list of subscribers paginated using the `page` query parameter

  [API Documentation](https://docs.novu.co/api/get-subscribers/)
  """
  @spec get_subscribers(opts :: Keyword.t()) :: Http.response()
  def get_subscribers(opts \\ []) do
    page = Keyword.get(opts, :page)
    params = add_optional_value(%{}, :page, page)
    Http.get("/v1/subscribers", params)
  end

  @doc """
  Creates a subscriber entity, in the Novu platform. The subscriber will be later used to receive notifications,
  and access notification feeds. Communication credentials such as email, phone number, and 3 rd party credentials
  i.e slack tokens could be later associated to this entity.

  [API Documentation](https://docs.novu.co/api/create-subscriber/)
  """
  @spec create_subscriber(subscriber_id :: String.t(), opts :: Keyword.t()) :: Http.response()
  def create_subscriber(subscriber_id, opts \\ []) do
    payload =
      opts
      |> Keyword.put(:subscriber_id, subscriber_id)
      |> build_subscriber_payload()

    Http.post("/v1/subscribers", payload)
  end

  @doc """
  Get subscriber by your internal id used to identify the subscriber

  [API Documentation](https://docs.novu.co/api/get-subscriber/)
  """
  @spec get_subscriber(subscriber_id :: String.t()) :: Http.response()
  def get_subscriber(subscriber_id) do
    Http.get("/v1/subscribers/#{URI.encode(subscriber_id)}")
  end

  @doc """
  Used to update the subscriber entity with new information

  [API Documentation](https://docs.novu.co/api/update-subscriber/)
  """
  @spec update_subscriber(subscriber_id :: String.t(), opts :: Keyword.t()) :: Http.response()
  def update_subscriber(subscriber_id, opts \\ []) do
    payload = build_subscriber_payload(opts)
    Http.put("/v1/subscribers/#{URI.encode(subscriber_id)}", payload)
  end

  @doc """
  Deletes a subscriber entity from the Novu platform

  [API Documentation](https://docs.novu.co/api/delete-subscriber/)
  """
  @spec delete_subscriber(subscriber_id :: String.t()) :: Http.response()
  def delete_subscriber(subscriber_id) do
    Http.delete("/v1/subscribers/#{URI.encode(subscriber_id)}")
  end

  @doc """
  Subscriber credentials associated to the delivery methods such as slack and push tokens.

  [API Documentation](https://docs.novu.co/api/update-subscriber-credentials/)
  """
  @spec update_subscriber_credentials(subscriber_id :: String.t(), opts :: map()) :: Http.response()
  def update_subscriber_credentials(subscriber_id, provider_id, opts \\ []) do
    webhook_url = Keyword.get(opts, :webhook_url)
    device_tokens = Keyword.get(opts, :device_tokens)

    credentials =
      %{}
      |> add_optional_value(:webhookUrl, webhook_url)
      |> add_optional_value(:deviceTokens, device_tokens)

    payload = %{providerId: provider_id, credentials: credentials}

    Http.put("/v1/subscribers/#{URI.encode(subscriber_id)}/credentials", payload)
  end

  @doc """
  [API Documentation](https://docs.novu.co/api/get-subscriber-preference/)
  """
  @spec get_subscriber_preferences(subscriber_id :: String.t()) :: Http.response()
  def get_subscriber_preferences(subscriber_id) do
    Http.get("/v1/subscribers/#{URI.encode(subscriber_id)}/preferences")
  end

  @doc """
  [API Documentation](https://docs.novu.co/api/update-subscriber-preferences/)
  """
  @spec update_subscriber_preferences(
          subscriber_id :: String.t(),
          template_id :: String.t(),
          type :: String.t(),
          enabled :: boolean()
        ) :: Http.response()
  def update_subscriber_preferences(subscriber_id, template_id, type, enabled) do
    payload = %{
      channel: %{
        type: type,
        enabled: enabled
      }
    }

    Http.patch("/v1/subscribers/#{URI.encode(subscriber_id)}/preferences/#{template_id}", payload)
  end

  @doc """
  [API Documentation](https://docs.novu.co/api/get-a-notification-feed-for-a-particular-subscriber/)
  """
  @spec get_notification_feed(subscriber_id :: String.t(), opts :: Keyword.t()) :: Http.response()
  def get_notification_feed(subscriber_id, opts \\ []) do
    page = Keyword.get(opts, :page, 0)
    feed_identifier = Keyword.get(opts, :feed_identifier)
    seen = Keyword.get(opts, :seen)

    params =
      %{page: page}
      |> add_optional_value(:feedIdentifier, feed_identifier)
      |> add_optional_value(:seen, seen)

    Http.get("/v1/subscribers/#{URI.encode(subscriber_id)}/notifications/feed", params)
  end

  @doc """
  [API Documentation](https://docs.novu.co/api/get-the-unseen-notification-count-for-subscribers-feed/)
  """
  @spec get_unseen_count(subscriber_id :: String.t(), opts :: Keyword.t()) :: Http.response()
  def get_unseen_count(subscriber_id, opts \\ []) do
    seen = Keyword.get(opts, :seen)
    params = add_optional_value(%{}, :seen, seen)

    Http.get("/v1/subscribers/#{URI.encode(subscriber_id)}/notifications/unseen", params)
  end

  @doc """
  [API Documentation](https://docs.novu.co/api/mark-a-subscriber-feed-message-as-seen/)
  """
  @spec mark_message_as_seen(subscriber_id :: String.t(), message_id :: String.t()) :: Http.response()
  def mark_message_as_seen(subscriber_id, message_id) do
    payload = %{
      messageId: message_id,
      subscriberId: subscriber_id
    }

    Http.post("/v1/subscribers/#{URI.encode(subscriber_id)}/messages/#{message_id}/seen", payload)
  end

  @doc """
  [API Documentation](https://docs.novu.co/api/mark-a-subscriber-feed-message-as-seen/)
  """
  @spec mark_action_as_seen(subscriber_id :: String.t(), message_id :: String.t(), type :: String.t()) ::
          Http.response()
  def mark_action_as_seen(subscriber_id, message_id, type) do
    payload = %{
      messageId: message_id,
      type: type,
      subscriberId: subscriber_id
    }

    Http.post("/v1/subscribers/#{URI.encode(subscriber_id)}/messages/#{message_id}/actions/#{type}", payload)
  end

  defp build_subscriber_payload(opts) do
    subscriber_id = Keyword.get(opts, :subscriber_id)
    email = Keyword.get(opts, :email)
    first_name = Keyword.get(opts, :first_name)
    last_name = Keyword.get(opts, :last_name)
    phone = Keyword.get(opts, :phone)
    avatar = Keyword.get(opts, :avatar)

    %{}
    |> add_optional_value(:subscriberId, subscriber_id)
    |> add_optional_value(:email, email)
    |> add_optional_value(:firstName, first_name)
    |> add_optional_value(:lastName, last_name)
    |> add_optional_value(:phone, phone)
    |> add_optional_value(:avatar, avatar)
  end

  defp add_optional_value(map, _key, nil), do: map
  defp add_optional_value(map, key, value), do: Map.put(map, key, value)
end
