defmodule ChatWeb.RoomChannel do
  use ChatWeb, :channel
#  require IEx; IEx.pry

  def join("room:lobby", _payload, socket) do
    {:ok, socket}
  end

  def join("room:" <> room_id , payload, socket) do
    if authorized?(room_id, payload) do
      socket = assign(socket, :room_id, room_id)
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (room:lobby).
  def handle_in("message", payload, socket) do
    broadcast socket, "change", payload
    #Integer.parse(socket.assigns[:user_id])
    {:noreply, socket}
  end

  intercept ["change"]
  def handle_out("change", payload, socket) do
    push socket, "change", payload
  end 

  # Add authorization logic here as required.
  defp authorized?(_room_id, _payload) do
    true
  end
end
