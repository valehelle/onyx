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
      render(conn, "new.html",changeset: changeset, username: username, user: user, full: false)
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
          {:error, error_changeset} ->
           render(conn, "new.html", changeset: error_changeset, username: username, user: user, full: false)
        end
      false -> 
        render(conn, "new.html", changeset: changeset, username: username, user: user, full: true)
      end
    end
  end
  def show(conn, %{"username" => username, "reserved_at" => reserved_at, "ref_id" => ref_id}) do
    [slot, ref] = String.split(ref_id, "-")
    {slot, _} = Integer.parse(slot)
    user = Accounts.get_user_by_username(username)
    case Reservertion.get_reservation(user.id, reserved_at, slot, ref_id) do
      nil -> render(conn, "error.html")
      reservation -> 
      slot = reservation.slot
      slot_time = %{
        1 => "9am - 10am",
        2 => "10am - 11am",
        3 => "11am - 12pm",
        4 => "12pm - 1pm",
        5 => "1pm - 2pm",
        6 => "2pm - 3pm",
        7 => "3pm - 4pm",
        8 => "4pm - 5pm",
        9 => "5pm - 6pm",
        }
      time = Map.get(slot_time, reservation.slot)
      render(conn, "show.html", reservation: reservation, user: user, time: time)
    end
  end
  def scan(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "scan.html", username: user.username)
  end
  def auto_scan(conn, %{"username" => username}) do
    user = Guardian.Plug.current_resource(conn)
    render(conn, "auto_scan.html", username: user.username)
  end

  def check_scan(conn, %{"username" => username, "reservation" => %{"ref" => ref_id, "reserved_at" => reserved_at, "slot" => current_slot}}) do
    user = Guardian.Plug.current_resource(conn)
    try do
      case user.username === username do
        true ->
          [slot, ref] = String.split(ref_id, "-")
          {slot, _} = Integer.parse(slot)
          {current_slot, _} = Integer.parse(current_slot)
          case current_slot === slot do
            true ->
              case Reservertion.get_reservation(user.id, reserved_at, slot, ref_id) do
                nil -> render(conn, "not_found.html")
                reservation -> 
                case reservation.has_entered do
                false -> 
                  Reservertion.update_reservation(reservation, %{"has_entered" => true})
                  render(conn, "success.html", reservation: reservation, user: user)
                true -> 
                  render(conn, "error-already-entered.html", user: user)
                end
              end
            false ->
              render(conn, "error-slot.html", user: user)
          end

        false ->

        render(conn, "error.html", user: user)
      end
    rescue
      _ -> render(conn, "error.html", user: user)
    end
  end
end
