defmodule Journey.Comms.TestEmail do
  import Swoosh.Email
  require Logger

  def test_email() do
    request_id = Logger.metadata()[:request_id]

    new()
    |> to({"MGMT ElasticDevs", "mgmt@elasticdevs.io"})
    |> from({"Shailesh Narayan", "shailesh@elasticdevs.io"})
    |> subject("test email")
    |> html_body(
      "<div>Hi there, just testing. Relax and Enjoy!!</div><div>REQUEST_ID, request_id=#{request_id}</div>"
    )
    |> text_body(
      "Hi there, just testing. Relax and Enjoy!!, REQUEST_ID, request_id=#{request_id}"
    )
  end
end
