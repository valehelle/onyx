defmodule OnyxWeb.UserController do
  use OnyxWeb, :controller

  alias Onyx.Accounts
  alias Onyx.Accounts.User
  alias Onyx.Accounts.Guardian


  def index(conn, params) do
    changeset = Accounts.change_user(%User{})
    redirect = params |> Map.get("redirect", "/")
    conn
      |> render("index.html", changeset: changeset, action: Routes.user_path(conn, :login), error: "none", redirect: redirect)
  end
  
  def register(conn, _params) do
    changeset = Accounts.change_user(%User{})
    conn
      |> render("register.html", changeset: changeset, action: Routes.user_path(conn, :register_user))
  end

  def register_user(conn, %{"user" => params}) do
    Accounts.create_user(params)
    |> register_reply(conn)
  end

  defp register_reply({:error, changeset}, conn) do
    conn
    |> render("register.html", changeset: changeset, action: Routes.user_path(conn, :register_user))
  end

  defp register_reply({:ok, user}, conn) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/dashboard")
  end


  def login(conn, %{"redirect" => redirect,"user" => %{"email" => email, "password" => password} = params}) do  
    Accounts.authenticate_user(email, password)
    |> login_reply(conn, redirect)
  end

  defp login_reply({:error, error}, conn, redirect) do
    changeset = Accounts.change_user(%User{})
    conn
      |> render("index.html", changeset: changeset, action: Routes.user_path(conn, :login), error: error, redirect: redirect)
  end

  defp login_reply({:ok, user}, conn, redirect) do
    conn
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/dashboard")
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: Routes.user_path(conn, :login))
  end

  def auth_error(conn, {type, _reason}, _opts) do
    case type do
      :unauthenticated -> 
        conn
        |> redirect(to: Routes.user_path(conn, :login, redirect:  conn.request_path))
    end
  end

end
