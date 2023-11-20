defmodule Journey.CommsTest do
  use Journey.DataCase

  alias Journey.Comms

  describe "templates" do
    alias Journey.Comms.Template

    import Journey.CommsFixtures

    @invalid_attrs %{name: nil, read_tracking: nil, text: nil}

    test "list_templates/0 returns all templates" do
      template = template_fixture()
      assert Comms.list_templates() == [template]
    end

    test "get_template!/1 returns the template with given id" do
      template = template_fixture()
      assert Comms.get_template!(template.id) == template
    end

    test "create_template/1 with valid data creates a template" do
      valid_attrs = %{name: "some name", read_tracking: true, text: "some text"}

      assert {:ok, %Template{} = template} = Comms.create_template(valid_attrs)
      assert template.name == "some name"
      assert template.read_tracking == true
      assert template.text == "some text"
    end

    test "create_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comms.create_template(@invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = template_fixture()
      update_attrs = %{name: "some updated name", read_tracking: false, text: "some updated text"}

      assert {:ok, %Template{} = template} = Comms.update_template(template, update_attrs)
      assert template.name == "some updated name"
      assert template.read_tracking == false
      assert template.text == "some updated text"
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = template_fixture()
      assert {:error, %Ecto.Changeset{}} = Comms.update_template(template, @invalid_attrs)
      assert template == Comms.get_template!(template.id)
    end

    test "delete_template/1 deletes the template" do
      template = template_fixture()
      assert {:ok, %Template{}} = Comms.delete_template(template)
      assert_raise Ecto.NoResultsError, fn -> Comms.get_template!(template.id) end
    end

    test "change_template/1 returns a template changeset" do
      template = template_fixture()
      assert %Ecto.Changeset{} = Comms.change_template(template)
    end
  end

  describe "emails" do
    alias Journey.Comms.Email

    import Journey.CommsFixtures

    @invalid_attrs %{email_uuid: nil, read_tracking: nil, status: nil}

    test "list_emails/0 returns all emails" do
      email = email_fixture()
      assert Comms.list_emails() == [email]
    end

    test "get_email!/1 returns the email with given id" do
      email = email_fixture()
      assert Comms.get_email!(email.id) == email
    end

    test "create_email/1 with valid data creates a email" do
      valid_attrs = %{email_uuid: "7488a646-e31f-11e4-aace-600308960662", read_tracking: true, status: "some status"}

      assert {:ok, %Email{} = email} = Comms.create_email(valid_attrs)
      assert email.email_uuid == "7488a646-e31f-11e4-aace-600308960662"
      assert email.read_tracking == true
      assert email.status == "some status"
    end

    test "create_email/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Comms.create_email(@invalid_attrs)
    end

    test "update_email/2 with valid data updates the email" do
      email = email_fixture()
      update_attrs = %{email_uuid: "7488a646-e31f-11e4-aace-600308960668", read_tracking: false, status: "some updated status"}

      assert {:ok, %Email{} = email} = Comms.update_email(email, update_attrs)
      assert email.email_uuid == "7488a646-e31f-11e4-aace-600308960668"
      assert email.read_tracking == false
      assert email.status == "some updated status"
    end

    test "update_email/2 with invalid data returns error changeset" do
      email = email_fixture()
      assert {:error, %Ecto.Changeset{}} = Comms.update_email(email, @invalid_attrs)
      assert email == Comms.get_email!(email.id)
    end

    test "delete_email/1 deletes the email" do
      email = email_fixture()
      assert {:ok, %Email{}} = Comms.delete_email(email)
      assert_raise Ecto.NoResultsError, fn -> Comms.get_email!(email.id) end
    end

    test "change_email/1 returns a email changeset" do
      email = email_fixture()
      assert %Ecto.Changeset{} = Comms.change_email(email)
    end
  end
end
