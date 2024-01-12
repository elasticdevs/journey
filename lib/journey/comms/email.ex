defmodule Journey.Comms.Email do
  use Ecto.Schema
  import Ecto.Changeset

  alias Journey.URLs
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
      :activity_id,
      :subject,
      :body,
      :read_tracking,
      :status
    ])
    |> validate_required([:subject, :body, :read_tracking, :client_id, :status])
  end

  def process_vars(email, tracking \\ false) do
    subject = Template.process_vars(email.client_id, email.activity.id, email.subject)

    body =
      case tracking do
        false ->
          Template.process_vars(email.client_id, email.activity.id, email.body)

        true ->
          """
          <pre style="font-family: inherit;">
          #{Template.process_vars(email.client_id, email.activity.id, email.body)}
          <pre>
          <img src='#{URLs.sponsored_img_url_shortened_from_url(email.activity.url)}' style='display:none' />
          """
      end

    {subject, body}
  end
end
