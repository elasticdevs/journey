defmodule Journey.Comms.LM do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.Prospects.Client
  alias Journey.Comms.Template
  alias Journey.Activities.Activity

  schema "lms" do
    field :lm_uuid, :string
    field :message, :string
    field :status, :string
    field :activity_id, :integer, virtual: true

    belongs_to :template, Template
    belongs_to :client, Client
    has_one :activity, Activity

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(lm, attrs) do
    lm
    |> cast(attrs, [:template_id, :message, :client_id, :activity_id, :status])
    |> validate_required([:activity_id, :status])
    |> process_vars
  end

  def process_vars(changeset) do
    client_id = get_field(changeset, :client_id)
    activity_id = get_field(changeset, :activity_id)

    case get_change(changeset, :message) do
      nil ->
        changeset

      message ->
        changeset
        |> change(message: Template.process_vars(client_id, activity_id, message))
    end
  end
end
