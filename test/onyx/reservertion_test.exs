defmodule Onyx.ReservertionTest do
  use Onyx.DataCase

  alias Onyx.Reservertion

  describe "reservations" do
    alias Onyx.Reservertion.Reservation

    @valid_attrs %{email: "some email", has_entered: true, name: "some name", ref: "some ref", reserved_at: "some reserved_at", slot: 42}
    @update_attrs %{email: "some updated email", has_entered: false, name: "some updated name", ref: "some updated ref", reserved_at: "some updated reserved_at", slot: 43}
    @invalid_attrs %{email: nil, has_entered: nil, name: nil, ref: nil, reserved_at: nil, slot: nil}

    def reservation_fixture(attrs \\ %{}) do
      {:ok, reservation} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Reservertion.create_reservation()

      reservation
    end

    test "list_reservations/0 returns all reservations" do
      reservation = reservation_fixture()
      assert Reservertion.list_reservations() == [reservation]
    end

    test "get_reservation!/1 returns the reservation with given id" do
      reservation = reservation_fixture()
      assert Reservertion.get_reservation!(reservation.id) == reservation
    end

    test "create_reservation/1 with valid data creates a reservation" do
      assert {:ok, %Reservation{} = reservation} = Reservertion.create_reservation(@valid_attrs)
      assert reservation.email == "some email"
      assert reservation.has_entered == true
      assert reservation.name == "some name"
      assert reservation.ref == "some ref"
      assert reservation.reserved_at == "some reserved_at"
      assert reservation.slot == 42
    end

    test "create_reservation/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Reservertion.create_reservation(@invalid_attrs)
    end

    test "update_reservation/2 with valid data updates the reservation" do
      reservation = reservation_fixture()
      assert {:ok, %Reservation{} = reservation} = Reservertion.update_reservation(reservation, @update_attrs)
      assert reservation.email == "some updated email"
      assert reservation.has_entered == false
      assert reservation.name == "some updated name"
      assert reservation.ref == "some updated ref"
      assert reservation.reserved_at == "some updated reserved_at"
      assert reservation.slot == 43
    end

    test "update_reservation/2 with invalid data returns error changeset" do
      reservation = reservation_fixture()
      assert {:error, %Ecto.Changeset{}} = Reservertion.update_reservation(reservation, @invalid_attrs)
      assert reservation == Reservertion.get_reservation!(reservation.id)
    end

    test "delete_reservation/1 deletes the reservation" do
      reservation = reservation_fixture()
      assert {:ok, %Reservation{}} = Reservertion.delete_reservation(reservation)
      assert_raise Ecto.NoResultsError, fn -> Reservertion.get_reservation!(reservation.id) end
    end

    test "change_reservation/1 returns a reservation changeset" do
      reservation = reservation_fixture()
      assert %Ecto.Changeset{} = Reservertion.change_reservation(reservation)
    end
  end
end
