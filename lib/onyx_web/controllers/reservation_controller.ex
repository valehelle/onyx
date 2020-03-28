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
          {:ok, res} ->  redirect(conn, to: Routes.reservation_path(conn, :show, username, res.reserved_at, res.ref))
          {:error, error_changeset} -> render(conn, "new.html", changeset: error_changeset, username: username, full: false)
        end
      false -> 
        render(conn, "new.html", changeset: changeset, username: username, full: true)
      end
    end
  end
  def show(conn, %{"username" => username, "reserved_at" => reserved_at, "ref_id" => ref_id}) do
    [slot, ref] = String.split(ref_id, "-")
    {slot, _} = Integer.parse(slot)
    user = Accounts.get_user_by_username(username)
    case Reservertion.get_reservation(user.id, reserved_at, slot, ref_id) do
      nil -> render(conn, "error.html")
      reservation -> render(conn, "show.html", reservation: reservation, user: user)
    end
    
  end
end
