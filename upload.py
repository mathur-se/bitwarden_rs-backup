from exoscale import Exoscale

exo = Exoscale("config.toml")
bucket = exo.storage.get_bucket("bitwarden-bucket")
file_index = bucket.put_file("/data/db_backup/backup.sqlite3")

files = bucket.list_files()
print(next(files))
