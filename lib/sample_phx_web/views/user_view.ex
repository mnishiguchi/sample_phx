defmodule SamplePhxWeb.UserView do
  use SamplePhxWeb, :view

  alias SamplePhx.User

  def first_name(%User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
