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
  def get_reservation!(id), do: Repo.get!(Reservation, id)

  @doc """
  Creates a reservation.

  ## Examples

      iex> create_reservation(%{field: value})
      {:ok, %Reservation{}}

      iex> create_reservation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_reservation(user, reservation) do
    attrs = %{
      "user_id" => user.id,
      "ref" => "random ref",

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

    IO.inspect Repo.all(query)
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
end
