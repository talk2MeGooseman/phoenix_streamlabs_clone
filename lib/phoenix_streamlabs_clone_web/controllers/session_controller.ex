defmodule PhoenixStreamlabsCloneWeb.SessionController do
  use PhoenixStreamlabsCloneWeb, :controller

  alias PhoenixStreamlabsClone.{UserManager, UserManager.User, UserManager.Guardian}

  def new(conn, _) do
    changeset = UserManager.change_user(%User{})
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/protected")
    else
      render(conn, "new.html", changeset: changeset, action: Routes.session_path(conn, :login))
    end
  end

  @spec login(Plug.Conn.t(), map) :: Plug.Conn.t()
  def login(conn, %{"user" => %{"username" => username, "password" => password}}) do
    UserManager.authenticate_user(username, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    # This module's full name is Auth.UserManager.Guardian.Plug,
    |> Guardian.Plug.sign_out()
    # and the arguments specfied in the Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  # docs are not applicable here

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    # This module's full name is Auth.UserManager.Guardian.Plug,
    |> Guardian.Plug.sign_in(user)
    # and the arguments specified in the Guardian.Plug.sign_in()
    |> redirect(to: "/protected")
  end

  # docs are not applicable here.

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
