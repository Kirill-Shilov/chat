defmodule Chat.Schema.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Schema.{User, Message}

  schema "rooms" do
    field :name, :string
    belongs_to :user, User
    has_many :messages, Message

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [])
    |> validate_required([])
  end
end
