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
      :email_uuid,
      :subject,
      :body,
      :read_tracking,
      :status
    ])
    |> validate_required([:subject, :body, :read_tracking, :client_id, :status])
  end
end
