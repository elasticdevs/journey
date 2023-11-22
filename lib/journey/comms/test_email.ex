defmodule Journey.Comms.TestEmail do
  import Swoosh.Email

  def test_email() do
    new()
    |> to({"MGMT ElasticDevs", "mgmt@elasticdevs.io"})
    |> from({"Shailesh Narayan", "shailesh@elasticdevs.io"})
    |> subject("test email")
    |> html_body("Hi there, just testing. Relax and Enjoy!!")
    |> text_body("Hi there, just testing. Relax and Enjoy!!")
  end
end
