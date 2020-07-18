defmodule SamplePhx.Repo do
  # use Ecto.Repo,
  #   otp_app: :sample_phx,
  #   adapter: Ecto.Adapters.Postgres

  @moduledoc """
  In-memory repo.
  """
  def all(SamplePhx.User) do
    [
      %SamplePhx.User{id: "1", name: "Masa", username: "masatoshi", password: "password"},
      %SamplePhx.User{id: "2", name: "Mats", username: "matsumoto", password: "password"},
      %SamplePhx.User{id: "3", name: "Jose", username: "josevalim", password: "password"}
    ]
  end

  def all(_module), do: []

  # Find one entry that matches id.
  def get(module, id) do
    Enum.find(
      all(module),
      &(&1.id == id)
    )
  end

  # Find one entry that matches params.
  def get_by(module, params) do
    Enum.find(
      all(module),
      fn user ->
        Enum.all?(
          params,
          fn {key, val} -> Map.get(user, key) == val end
        )
      end
    )
  end
end
