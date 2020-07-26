defmodule SamplePhxWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias SamplePhxWeb.Router.Helpers, as: Routes

  def init(opts) do
    opts
  end

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)

    cond do
      # If current_user is already present in conn.assigns, we honor it, no matter how it got there.
      # It makes our code more testable.
      conn.assigns[:current_user] ->
        conn

      user = user_id && SamplePhx.Accounts.get_user(user_id) ->
        # Make current_user available in all downstream functions including controllers and views.
        assign(conn, :current_user, user)

      true ->
        assign(conn, :current_user, nil)
    end
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "You must be logged in to access that page")
      |> redirect(to: Routes.page_path(conn, :index))
      # Stop any downstream transformations.
      |> halt()
    end
  end

  def login(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    # Tell Plug to send the session cookie back to the client with a different identifier in case
    # an attacker knew by any chance the previous one.
    |> configure_session(renew: true)
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
