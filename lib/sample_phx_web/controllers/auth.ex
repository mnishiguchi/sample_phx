defmodule SamplePhxWeb.Auth do
  import Plug.Conn
  import Phoenix.Controller
  alias SamplePhxWeb.Router.Helpers, as: Routes
  alias SamplePhx.User

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(User, user_id)

    # Make current_user available in all downstream functions including controllers and views.
    assign(conn, :current_user, user)
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

  def login_by_username_and_password(conn, username, given_password, opts) do
    repo = Keyword.fetch!(opts, :repo)
    user = repo.get_by(User, username: username)

    cond do
      user && Bcrypt.verify_pass(given_password, user.password_hash) ->
        {:ok, login(conn, user)}

      user ->
        {:error, :unauthorized, conn}

      true ->
        # Simulate password check with variable timing for possible timing attacks.
        Bcrypt.no_user_verify()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    configure_session(conn, drop: true)
  end
end
