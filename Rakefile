desc 'Sync from production to the local cache'
task :sync_from_production => [:setup] do
  puts "Syncing files from #{CONF['production_bucket']} to #{CACHE}..."
  `#{S3SYNC} -r --make-dirs #{CONF['production_bucket']}: #{CACHE}`
end

desc 'Sync from the local cache to staging'
task :sync_to_staging => [:setup] do
  puts "Syncing files from #{CACHE} to #{CONF['staging_bucket']}..."
  `#{S3SYNC} -r --make-dirs #{CACHE}/ #{CONF['staging_bucket']}:`
end

desc 'Sync from production to staging through the local cache'
task :sync_from_production_to_staging => [:sync_from_production, :sync_to_staging]

desc 'Set up the config file and variables'
task :setup do
  puts "Setting up variables..."
  CONF = YAML.load_file(File.join(File.dirname(__FILE__), 's3_awesomeness_config.yml'))
  CONF[:keep_archives] ||= 10
  ENV['AWS_ACCESS_KEY_ID'] = CONF['aws_access_key_id']
  ENV['AWS_SECRET_ACCESS_KEY'] = CONF['aws_secret_access_key']
  S3SYNC = File.join(File.dirname(__FILE__), 'vendor', 's3sync', 's3sync.rb')
  CACHE = File.join(File.dirname(__FILE__), 'cache')
end

desc 'Archive a snapshot of the s3 bucket'
task :archive => [:setup, :sync_from_production] do
  
end