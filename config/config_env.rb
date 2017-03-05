config_env :development do
  set 'PYTHON_URL', 'http://localhost:5000'
end

config_env :production do
  set 'MSG_KEY', 'tpFSEbUqJLUFnf5mpCiG2Le4-9vy-osUKaI99jUMwWs='
  set 'PYTHON_URL', 'https://python-worker.herokuapp.com'
end
