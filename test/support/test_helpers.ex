defmodule SamplePhx.TestHelpers do
  alias SamplePhx.{Accounts, Multimedia}
  alias Accounts.User

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "Some User",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "password"
      })
      |> Accounts.register_user()

    user
  end

  def video_fixture(%User{} = user, attrs \\ %{}) do
    attrs =
      Enum.into(attrs, %{
        title: "A Title",
        url: "https://example.com",
        description: "A description"
      })

    {:ok, video} = Multimedia.create_video(user, attrs)
    video
  end
end
