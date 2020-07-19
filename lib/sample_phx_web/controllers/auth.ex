defmodule SamplePhxWeb.Auth do
  import Plug.Conn

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(SamplePhx.User, user_id)

    # Make current_user available in all downstream functions including controllers and views.
    assign(conn, :current_user, user)
  end
end
