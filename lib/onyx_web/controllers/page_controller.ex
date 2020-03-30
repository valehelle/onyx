defmodule OnyxWeb.PageController do
  use OnyxWeb, :controller

  def index(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    case user do
      nil -> render(conn, "index.html")
      user -> redirect(conn, to: Routes.page_path(conn, :dashboard))
    end
  end
  def dashboard(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    path = "https://#{Application.get_env(:onyx, OnyxWeb.Endpoint)[:url][:host]}/reservation/#{user.username}"
    render(conn, "dashboard.html", path: path, user: user)
  end
end
