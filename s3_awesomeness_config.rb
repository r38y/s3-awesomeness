# sets up environment for the actual script files
require 'yaml'

CONF = YAML.load_file(File.join(File.dirname(__FILE__), 's3_awesomeness_config.yml'))
ENV['AWS_ACCESS_KEY_ID'] = CONF['aws_access_key_id']
ENV['AWS_SECRET_ACCESS_KEY'] = CONF['aws_secret_access_key']

S3SYNC = File.join(File.dirname(__FILE__), 'vendor', 's3sync', 's3sync.rb')
CACHE = File.join(File.dirname(__FILE__), 'cache')
