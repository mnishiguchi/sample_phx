defmodule SamplePhxWeb.UserController do
  use SamplePhxWeb, :controller

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, _params) do
    render(conn, "show.html")
  end
end
