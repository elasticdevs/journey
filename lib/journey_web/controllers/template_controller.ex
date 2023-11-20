defmodule JourneyWeb.TemplateController do
  use JourneyWeb, :controller

  alias Journey.Comms
  alias Journey.Comms.Template

  def index(conn, _params) do
    templates = Comms.list_templates()
    render(conn, :index, templates: templates)
  end

  def new(conn, _params) do
    changeset = Comms.change_template(%Template{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"template" => template_params}) do
    case Comms.create_template(template_params) do
      {:ok, template} ->
        conn
        |> put_flash(:info, "Template created successfully.")
        |> redirect(to: ~p"/templates/#{template}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    template = Comms.get_template!(id)
    render(conn, :show, template: template)
  end

  def edit(conn, %{"id" => id}) do
    template = Comms.get_template!(id)
    changeset = Comms.change_template(template)
    render(conn, :edit, template: template, changeset: changeset)
  end

  def update(conn, %{"id" => id, "template" => template_params}) do
    template = Comms.get_template!(id)

    case Comms.update_template(template, template_params) do
      {:ok, template} ->
        conn
        |> put_flash(:info, "Template updated successfully.")
        |> redirect(to: ~p"/templates/#{template}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, template: template, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    template = Comms.get_template!(id)
    {:ok, _template} = Comms.delete_template(template)

    conn
    |> put_flash(:info, "Template deleted successfully.")
    |> redirect(to: ~p"/templates")
  end
end
