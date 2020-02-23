defmodule Chat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do 
      add :message, :string
      add :user, references(:users)
      add :room, references(:rooms)

      timestamps()
    end

  end
end
