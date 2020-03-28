defmodule OnyxWeb.ReservationController do
  use OnyxWeb, :controller
  alias Onyx.Accounts
  alias Onyx.Reservertion
  alias Onyx.Reservertion.Reservation

  def new(conn, %{"username" => username}) do
    case Accounts.get_user_by_username(username) do
      nil -> redirect(conn, to: Routes.page_path(conn, :index))
      user -> 
      changeset = Reservation.changeset(%Reservation{}, %{})
      render(conn, "new.html",changeset: changeset, username: username, full: false)
    end
  end
  def create(conn, %{"username" => username, "reservation" => reservation}) do
    case Accounts.get_user_by_username(username) do
      nil -> redirect(conn, to: Routes.page_path(conn, :index))
      user -> 
      changeset = Reservation.changeset(%Reservation{}, reservation)
      total_slot_taken = Reservertion.get_total_slot_taken(user.id, reservation) |> length
      available_slot = user.slot_limit - total_slot_taken
      case available_slot > 0 do
      true -> 
        case Reservertion.create_reservation(user, reservation) do
          {:ok, _} -> render(conn, "new.html", changeset: changeset, username: username, full: false)
          {:error, error_changeset} -> render(conn, "new.html", changeset: error_changeset, username: username, full: false)
        end
      false -> 
        render(conn, "new.html", changeset: changeset, username: username, full: true)
      end
    end
  end
end
