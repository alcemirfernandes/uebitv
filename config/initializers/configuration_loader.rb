raw_config = File.read(RAILS_ROOT + "/config/configuration.yml")
APP_CONFIG = YAML.load(raw_config)[RAILS_ENV]