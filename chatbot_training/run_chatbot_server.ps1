$ErrorActionPreference = "Stop"

Set-Location (Split-Path -Parent $MyInvocation.MyCommand.Path)
python .\chatbot_server.py --host 0.0.0.0 --port 5055
