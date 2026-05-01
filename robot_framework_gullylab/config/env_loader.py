import yaml
import os

_data = {}

def load_env(env):
    file_path = os.path.join(os.path.dirname(__file__), "env.yaml")
    # file_path = r'env.yaml'

    with open(file_path, "r") as file:
        config = yaml.safe_load(file)

    global _data
    _data = config[env]

def get_env(key):
    return _data.get(key.lower())