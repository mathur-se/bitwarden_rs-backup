from exoscale import Exoscale
import os

exo = Exoscale("config.toml")
bucket = exo.storage.get_bucket("bitwarden-bucket")
file_index = bucket.put_file("bitwardenbackup.tar.gz")
files = bucket.list_files()
print(next(files))
os.remove("/app/bitwardenbackup.tar.gz")
