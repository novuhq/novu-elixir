defmodule Novu.Events do
  @moduledoc """
  Provide access to the Novu Event API
  """

  alias Novu.Http

  @doc """
  Trigger a broadcast event to all existing subscribers, could be used to send announcements, etc.
  In the future could be used to trigger events to a subset of subscribers based on defined filters.

  [API Documentation](https://docs.novu.co/api/#broadcast-event-to-all)
  """
  @spec broadcast_to_all(name :: String.t(), payload :: map(), opts :: Keyword.t()) :: Http.response()
  def broadcast_to_all(name, payload, opts \\ []) do
    payload = build_event_payload(name, payload, nil, opts)
    Http.post("/v1/events/trigger/broadcast", payload)
  end

  @doc """
  Using a previously generated transactionId during the event trigger, will cancel any active or pending workflows.

  [API Documentation](https://docs.novu.co/api/#cancel-triggered-event)
  """
  @spec cancel_event(transaction_id :: String.t()) :: Http.response()
  def cancel_event(transaction_id) do
    Http.delete("/v1/events/trigger/#{transaction_id}")
  end

  @doc """
  Trigger event is the main (and the only) way to send notification to subscribers.
  The trigger identifier is used to match the particular template associated with it.
  Additional information can be passed according the the body interface below.

  [API Documentation](https://docs.novu.co/api/#trigger-event)
  """
  @spec trigger_event(name :: String.t(), payload :: map(), to :: String.t(), opts :: Keyword.t()) :: Http.response()
  def trigger_event(name, payload, to, opts \\ []) do
    payload = build_event_payload(name, payload, to, opts)
    Http.post("/v1/events/trigger", payload)
  end

  defp build_event_payload(name, payload, to, opts) do
    overrides = Keyword.get(opts, :overrides)
    transaction_id = Keyword.get(opts, :transaction_id)

    %{name: name, payload: payload}
    |> add_optional_value(:overrides, overrides)
    |> add_optional_value(:to, to)
    |> add_optional_value(:transactionId, transaction_id)
  end

  defp add_optional_value(map, _key, nil), do: map
  defp add_optional_value(map, key, value), do: Map.put(map, key, value)
end
