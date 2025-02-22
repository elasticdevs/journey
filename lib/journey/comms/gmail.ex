defmodule Journey.Comms.Gmail do
  import Swoosh.Email
  require Logger

  def test_email do
    request_id = Logger.metadata()[:request_id]

    new()
    |> to({"ED Management", "mgmt@elasticdevs.io"})
    |> from({"Shailesh Narayan", "shailesh@elasticdevs.io"})
    |> subject("test email, utc_now=#{DateTime.utc_now()}")
    |> html_body(
      "<div>Hi there, just testing. Relax and Enjoy!!</div><div>REQUEST_ID, request_id=#{request_id}</div>"
    )
    |> text_body(
      "Hi there, just testing. Relax and Enjoy!!, REQUEST_ID, request_id=#{request_id}"
    )
  end

  def send(email) do
    Logger.debug(
      "SENDING_EMAIL, client_name=#{email.client.name}, client_email_id=#{email.client.email}, subject=#{email.subject}"
    )

    new()
    |> to({email.client.name, email.client.email})
    # |> bcc("mgmt@elasticdevs.io")
    |> from({"Shailesh Narayan", "shailesh@elasticdevs.io"})
    |> subject(email.subject)
    |> html_body(email.body)
  end
end
