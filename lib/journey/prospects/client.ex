defmodule Journey.Prospects.Client do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Analytics.Visit
  alias Journey.Activities.Activity
  alias Ecto.Changeset
  alias Journey.Accounts.User
  alias Journey.Prospects.Company
  alias Journey.Analytics.Browsing
  alias Journey.Comms.Call
  alias Journey.Comms.LM
  alias Journey.Comms.Email
  alias Journey.Common.Types
  alias Journey.URLs.URL

  @derive {Jason.Encoder, only: [:client_uuid]}
  schema "clients" do
    field :client_uuid, Ecto.UUID
    field :external_id, :string
    field :name, :string
    field :email, :string
    field :phone, :string
    field :city, :string
    field :state, :string
    field :country, :string
    field :job_title, :string
    field :seniority, :string
    field :linkedin, :string
    field :status, :string
    field :tags, :string
    field :comments, :string
    field :source, :string
    field :last_visited_at, :utc_datetime_usec
    has_many :visits, Visit, preload_order: [desc: :inserted_at]
    has_many :browsings, Browsing, preload_order: [desc: :last_visited_at]
    has_many :activities, Activity, preload_order: [desc: :inserted_at]
    has_many :calls, Call, preload_order: [desc: :inserted_at]
    has_many :lms, LM, preload_order: [desc: :inserted_at]
    has_many :emails, Email, preload_order: [desc: :inserted_at]
    has_one :url, URL
    belongs_to :company, Company
    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(client, attrs) do
    attrs = attrs |> remove_bad_chars

    client
    |> cast(attrs, [
      :user_id,
      :company_id,
      :client_uuid,
      :external_id,
      :name,
      :email,
      :phone,
      :linkedin,
      :job_title,
      :seniority,
      :country,
      :state,
      :city,
      :comments,
      :tags,
      :status,
      :source,
      :last_visited_at
    ])
    |> clean_up()
    |> validate_required([:linkedin])
    |> update_change(:linkedin, &String.downcase/1)
    |> update_change_if_not_nil(:email, &String.downcase/1)
    |> unique_constraint(:client_uuid)
    |> unique_constraint(:linkedin)
  end

  def remove_bad_chars(changeset) do
    Enum.into(
      Enum.map(changeset, fn {k, v} ->
        {k, if(Types.typeof(v) == "string", do: String.replace(v, "\"", ""), else: v)}
      end),
      %{}
    )
  end

  def clean_up(changeset) do
    case get_change(changeset, :linkedin) do
      nil ->
        changeset

      linkedin ->
        changeset
        |> change(linkedin: String.trim_trailing(linkedin, "/"))
    end
  end

  def update_change_if_not_nil(%Changeset{changes: changes} = changeset, key, function)
      when is_atom(key) do
    case Map.fetch(changes, key) do
      {:ok, nil} ->
        changeset

      {:ok, value} ->
        put_change(changeset, key, function.(value))

      :error ->
        changeset
    end
  end
end
