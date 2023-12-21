defmodule Mix.Tasks.Obfuscate do
  @moduledoc "Obfuscate journey.js"
  @shortdoc "no args"

  use Mix.Task

  @impl Mix.Task
  def run(_) do
    Mix.shell().cmd(
      "/usr/bin/javascript-obfuscator journey-js/journey.js -o priv/static/assets/journey/journey.js"
    )

    Mix.shell().cmd(
      "/usr/bin/javascript-obfuscator journey-js/staging-journey.js -o priv/static/assets/journey/staging-journey.js"
    )
  end
end
