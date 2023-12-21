defmodule Journey.Comms.Email do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Activities.Activity
  alias Journey.Comms.Template
  alias Journey.Prospects.Client

  schema "emails" do
    field :email_uuid, Ecto.UUID
    field :subject, :string
    field :body, :string
    field :read_tracking, :boolean, default: false
    field :status, :string
    field :activity_id, :integer, virtual: true

    belongs_to :template, Template
    belongs_to :client, Client
    has_one :activity, Activity

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [
      :client_id,
      :template_id,
      :subject,
      :body,
      :read_tracking,
      :status
    ])
    |> validate_required([:subject, :body, :read_tracking, :client_id, :status])
    |> process_vars
  end

  def process_vars(changeset) do
    client_id = get_field(changeset, :client_id)
    activity_id = get_field(changeset, :activity_id)

    changeset =
      case get_change(changeset, :subject) do
        nil ->
          changeset

        subject ->
          changeset
          |> change(subject: Template.process_vars(client_id, subject))
      end

    case get_change(changeset, :body) do
      nil ->
        changeset

      body ->
        changeset
        |> change(body: Template.process_vars(client_id, activity_id, body))
    end
  end
end
