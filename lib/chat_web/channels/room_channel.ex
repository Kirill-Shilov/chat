defmodule ChatWeb.RoomChannel do
  use ChatWeb, :channel
#  require IEx; IEx.pry

  alias Chat.Lobby
  alias Chat.Repo

  def join("room:lobby", _payload, socket) do
    rooms = Lobby.list_rooms() 
    push(socket, "room_list", rooms) 

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

  def handle_in("get_room_list", payload, socket) do
    push(socket, "room_list", Lobby.list_rooms()) 
    #Integer.parse(socket.assigns[:user_id])
    {:noreply, socket}
  end

#  def handle_info("after_join", socket) do
#    push(socket, "room_list", Presence.list(socket))
#    {:noreply, socket))
#  end

  # Add authorization logic here as required.
  defp authorized?(_room_id, _payload) do
    true
  end
end
