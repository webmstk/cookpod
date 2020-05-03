defmodule Cookpod.User do
  @moduledoc """
  Модель мользователя
  """

  use Ecto.Schema
  import Ecto.Changeset
  import CookpodWeb.Gettext

  schema "users" do
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email], message: gettext("Не может быть пустым"))
    |> encrypt_password
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :password_confirmation])
    |> validate_required([:email, :password, :password_confirmation],
      message: gettext("Не может быть пустым")
    )
    |> validate_length(:password, min: 4, message: gettext("Минимум 4 символа"))
    |> validate_confirmation(:password, message: gettext("Не совпадает с паролем"))
    |> validate_format(:email, ~r/@/, message: gettext("Невалидная почта"))
    |> encrypt_password
    |> unique_constraint(:email)
  end

  def new_changeset() do
    changeset(%Cookpod.User{}, %{})
  end

  def auth_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password], message: gettext("Не может быть пустым"))
    |> validate_length(:password, min: 4, message: gettext("Минимум 4 символа"))
    |> validate_format(:email, ~r/@/, message: gettext("Невалидная почта"))
  end

  def encrypt_password(changeset) do
    case Map.fetch(changeset.changes, :password) do
      {:ok, password} ->
        put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))

      :error ->
        changeset
    end
  end
end
