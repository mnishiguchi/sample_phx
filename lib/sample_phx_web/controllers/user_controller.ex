defmodule SamplePhxWeb.UserController do
  use SamplePhxWeb, :controller

  alias SamplePhx.Repo
  alias SamplePhx.User

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end
end
