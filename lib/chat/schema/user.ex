defmodule Chat.Schema.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
    #user_id_field: :id
  import Ecto.Changeset
  alias Chat.Schema.{Message, Room}

  schema "users" do
    field :role, :string, default: "user"
    has_many :messages, Message
    has_many :rooms, Room 

    pow_user_fields()

    timestamps()
  end

  def changeset(user_or_changeset, attrs) do
    user_or_changeset
    |> pow_changeset(attrs)
    |> changeset_role(attrs)
  end

  def changeset_role(user_or_changeset, attrs) do
    user_or_changeset
    |> Ecto.Changeset.cast(attrs, [:role])
    |> Ecto.Changeset.validate_inclusion(:role, ~w(user admin))
  end

end


