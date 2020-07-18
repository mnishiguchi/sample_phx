defmodule SamplePhx.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias SamplePhx.User

  schema "users" do
    field :name, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string

    timestamps()
  end

  def changeset(%User{} = model, attrs \\ %{}) do
    model
    |> cast(attrs, [:name, :username, :password])
    |> validate_required([:name, :username, :password])
    |> validate_length(:username, min: 1, max: 20)
    |> validate_length(:password, min: 6)
  end
end
