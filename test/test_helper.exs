File.rm_rf!(File.cwd!() <> "/priv/static/assets")
File.mkdir_p!(File.cwd!() <> "/priv/static/assets")
ExUnit.start()
