defmodule Chat.Schema.Message do
  use Ecto.Schema
  import Ecto.Changeset
  alias Chat.Schema.{User, Room}

  schema "messages" do
    field :message, :string
    belongs_to :user, User
    belongs_to :room, Room

    timestamps()
  end

#  def get_messages(limit \\ 20) do
#    Chat.Repo.all(Chat.Schema.Message, limit: limit)
#  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:message, :user, :room])
    |> validate_required([:message, :user, :room])
  end
end
