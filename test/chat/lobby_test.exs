defmodule Chat.LobbyTest do
  use Chat.DataCase

  alias Chat.Lobby

  describe "rooms" do
    alias Chat.Lobby.Room

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lobby.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Lobby.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Lobby.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Lobby.create_room(@valid_attrs)
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lobby.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, %Room{} = room} = Lobby.update_room(room, @update_attrs)
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Lobby.update_room(room, @invalid_attrs)
      assert room == Lobby.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Lobby.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Lobby.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Lobby.change_room(room)
    end
  end
end
