config_env :development do
  set 'PYTHON_URL', 'http://localhost:9292'
end

config_env :production do
  set 'MSG_KEY', 'x63_ONYy95W4IzC7ll9DwZmSH8lSuGfNad4cOZe5V-4='
  set 'PYTHON_URL', 'https://python-worker.herokuapp.com'
end
