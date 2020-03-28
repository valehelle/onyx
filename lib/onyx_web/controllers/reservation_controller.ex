defmodule OnyxWeb.ReservationController do
  use OnyxWeb, :controller
  alias Onyx.Accounts
  def new(conn, %{"username" => username}) do
    case Accounts.get_user_by_username(username) do
      nil -> redirect(conn, to: Routes.page_path(conn, :index))
      user -> render(conn, "create.html")
    end
  end
end
