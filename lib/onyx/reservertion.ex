defmodule Onyx.Reservertion do
  @moduledoc """
  The Reservertion context.
  """

  import Ecto.Query, warn: false
  alias Onyx.Repo

  alias Onyx.Reservertion.Reservation

  @doc """
  Returns the list of reservations.

  ## Examples

      iex> list_reservations()
      [%Reservation{}, ...]

  """
  def list_reservations do
    Repo.all(Reservation)
  end

  @doc """
  Gets a single reservation.

  Raises `Ecto.NoResultsError` if the Reservation does not exist.

  ## Examples

      iex> get_reservation!(123)
      %Reservation{}

      iex> get_reservation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_reservation(user_id, reserved_at, slot, ref) do
    Repo.get_by(Reservation, user_id: user_id, reserved_at: reserved_at, slot: slot, ref: ref)
  end
  
  @doc """
  Creates a reservation.

  ## Examples

      iex> create_reservation(%{field: value})
      {:ok, %Reservation{}}

      iex> create_reservation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reservation(user, %{"slot" => slot} = reservation) do
    attrs = %{
      "user_id" => user.id,
      "ref" => "#{slot}-#{randomizer(5)}",
    } |> Map.merge(reservation)
    %Reservation{}
    |> Reservation.changeset(attrs)
    |> Repo.insert()
  end

  def get_total_slot_taken(user_id, %{"reserved_at" => reserved_at, "slot" => slot}) do
    query = from r in Reservation,
            where: r.user_id == ^user_id,
            where: r.reserved_at == ^reserved_at,
            where: r.slot == ^slot

    Repo.all(query)
  end

  

  @doc """
  Updates a reservation.

  ## Examples

      iex> update_reservation(reservation, %{field: new_value})
      {:ok, %Reservation{}}

      iex> update_reservation(reservation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_reservation(%Reservation{} = reservation, attrs) do
    reservation
    |> Reservation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a reservation.

  ## Examples

      iex> delete_reservation(reservation)
      {:ok, %Reservation{}}

      iex> delete_reservation(reservation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_reservation(%Reservation{} = reservation) do
    Repo.delete(reservation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking reservation changes.

  ## Examples

      iex> change_reservation(reservation)
      %Ecto.Changeset{source: %Reservation{}}

  """
  def change_reservation(%Reservation{} = reservation) do
    Reservation.changeset(reservation, %{})
  end


  def randomizer(length, type \\ :all) do
    alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    lists = alphabets <> String.downcase(alphabets) |> String.split("", trim: true)

    do_randomizer(length, lists)
  end

  @doc false
  defp get_range(length) when length > 1, do: (1..length)
  defp get_range(length), do: [1]

  @doc false
  defp do_randomizer(length, lists) do
    get_range(length)
    |> Enum.reduce([], fn(_, acc) -> [Enum.random(lists) | acc] end)
    |> Enum.join("")
  end


end
