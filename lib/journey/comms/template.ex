defmodule Journey.Comms.Template do
  use Ecto.Schema
  import Ecto.Changeset
  alias Journey.Activities
  alias Journey.Comms.Call
  alias Journey.Comms.LM
  alias Journey.Comms.Email
  alias Journey.Prospects

  schema "templates" do
    field :comm_type, :string
    field :name, :string
    field :read_tracking, :boolean, default: false
    field :subject, :string
    field :body, :string
    has_many :calls, Call, preload_order: [desc: :last_updated_at]
    has_many :lms, LM, preload_order: [desc: :last_updated_at]
    has_many :emails, Email, preload_order: [desc: :last_updated_at]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:comm_type, :name, :subject, :body, :read_tracking])
    |> validate_required([:comm_type, :name, :subject, :body, :read_tracking])
  end

  def process_vars(client_id, activity_id, message) do
    client = Prospects.get_client!(client_id)
    activity = Activities.get_activity!(activity_id)

    message
    |> String.replace("$client-name", client.name)
    |> String.replace("$client-company-name", client.company.name)
    |> String.replace(
      "$client-sponsored-url",
      Activities.sponsored_link_shortened_from_activity(activity)
    )
  end
end
