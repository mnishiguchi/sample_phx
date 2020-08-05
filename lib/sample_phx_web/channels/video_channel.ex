defmodule SamplePhxWeb.VideoChannel do
  use SamplePhxWeb, :channel

  @doc """
  Socket will hold all of the state for a given conversation. Each socket can
  hold all of the state in the `socket.assigns` field.
  "videos:" <> video_id will match all topics starting with "videos:" and assign
  the rest of the topic to the video_id variable.
  """
  def join("videos:" <> video_id, _params, socket) do
    :timer.send_interval(5_000, :ping)
    {:ok, socket}
  end

  @doc """
  Takes the existing count (or a default of 1) and increments that count.
  Invoked whenever an Elixir message reaches the channel. In this case, we match
  on the periodic `:ping` message and increase a counter every time it arrives.
  """
  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push(socket, "ping", %{count: count})

    {:noreply, assign(socket, :count, count + 1)}
  end
end
