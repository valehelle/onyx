defmodule OnyxWeb.PageController do
  use OnyxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
  def dashboard(conn, _params) do
    render(conn, "dashboard.html")
  end
end
