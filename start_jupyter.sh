# Enable colab remote connexion
pip3 install --upgrade jupyter_http_over_ws>=0.0.1a3 && \
         jupyter serverextension enable --py jupyter_http_over_ws

# Start notebook
jupyter notebook \
  --NotebookApp.allow_origin='https://colab.research.google.com' \
  --no-browser \
  --NotebookApp.token='' --NotebookApp.disable_check_xsrf=True \
  --JupyterWebsocketPersonality.list_kernels=True \
  --port=8888 --ip=0.0.0.0 \
  --NotebookApp.port_retries=0
