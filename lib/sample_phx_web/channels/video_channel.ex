defmodule SamplePhxWeb.VideoChannel do
  use SamplePhxWeb, :channel

  @doc """
  Socket will hold all of the state for a given conversation. Each socket can
  hold all of the state in the `socket.assigns` field.
  "videos:" <> video_id will match all topics starting with "videos:" and assign
  the rest of the topic to the video_id variable.
  """
  def join("videos:" <> video_id, params, socket) do
    {:ok, socket}
  end

  @doc """
  The `broadcast!` function sends an event to all users on the current topic.
  Behind the scenes, `broadcast!` uses Phoenix's Publish and Subscribe (PubSub)
  system to send the message to all processes listening on the given topic.
  """
  def handle_in("new_annotation", params, socket) do
    # The payload is delivered to all clients on this topic. Be sure to control
    # the payload as closely as possible.
    broadcast!(socket, "new_annotation", %{
      user: %{username: "anon"},
      body: params["body"],
      at: params["at"]
    })

    {:reply, :ok, socket}
  end
end
