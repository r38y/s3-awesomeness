require 'rubygems'

desc 'Sync from production to the local cache'
task :sync_from_production => [:setup] do
  puts "Syncing files from #{CONF['production_bucket']} to #{CACHE}..."
  `#{S3SYNC} -r --make-dirs #{CONF['production_bucket']}: #{CACHE}`
end

desc 'Sync from the local cache to staging'
task :sync_to_staging => [:setup] do
  puts "Syncing files from #{CACHE} to #{CONF['staging_bucket']}..."
  `#{S3SYNC} -r -p --make-dirs #{CACHE}/ #{CONF['staging_bucket']}:`
end

desc 'Sync from production to staging through the local cache'
task :sync_from_production_to_staging => [:sync_from_production, :sync_to_staging]

desc 'Set up the config file and variables'
task :setup do
  puts "Setting up variables..."
  CONF = YAML.load_file(File.join(File.dirname(__FILE__), 's3_awesomeness_config.yml'))
  CONF['keep_archives'] ||= 10
  CONF['app_name'] ||= 'changeappname'
  ENV['AWS_ACCESS_KEY_ID'] = CONF['aws_access_key_id']
  ENV['AWS_SECRET_ACCESS_KEY'] = CONF['aws_secret_access_key']
  S3SYNC = File.join(File.dirname(__FILE__), 'vendor', 's3sync', 's3sync.rb')
  CACHE = File.join(File.dirname(__FILE__), 'cache')
  TMP = File.join(File.dirname(__FILE__), 'tmp')
end

desc 'Archive a snapshot of the production s3 bucket'
task :archive => [:setup, :sync_from_production] do
  require 'aws/s3'
  include AWS::S3
  
  folder_name = "#{Time.now.strftime("%Y%m%d%H%M%S")}-#{CONF['app_name']}-#{CONF['production_bucket']}"
  tgz_folder_name = "#{folder_name}.tar.gz"
  folder_path = File.join(TMP, folder_name)
  tgz_folder_path = File.join(TMP, tgz_folder_name)
  
  puts "Copying production files to #{folder_path}"
  FileUtils.cp_r(CACHE, folder_path)
  
  puts "Tar/gzipping #{folder_path}"
  `tar -czvf #{tgz_folder_path} #{folder_path}/`
  
  puts "Removing #{folder_path}"
  FileUtils.rm_rf(folder_path)
  
  puts "Uploading #{tgz_folder_name} to #{CONF['archive_bucket']}"
  Base.establish_connection!(
    :access_key_id     => CONF['aws_access_key_id'],
    :secret_access_key => CONF['aws_secret_access_key']
  )
  S3Object.store(tgz_folder_name, open(tgz_folder_path), CONF['archive_bucket'])
  
  puts "Removing #{tgz_folder_path}"
  FileUtils.rm_rf(tgz_folder_path)
  
  archived_objects = Bucket.objects(CONF['archive_bucket'])
  if archived_objects.size > CONF['keep_archives']
    number_to_delete = archived_objects.size - CONF['keep_archives']
    puts "There are #{archived_objects.size} backups and we want to keep #{CONF['keep_archives']}. Deleting #{number_to_delete} backups."
    archived_objects = archived_objects.sort{|x,y| x.key <=> y.key}
    to_be_deleted = archived_objects[0, number_to_delete]
    to_be_deleted.each do |object|
      puts "Deleting #{object.key}"
      object.delete
    end
  else
    puts "There are #{archived_objects.size} backups and we want to keep #{CONF['keep_archives']}. Not deleting any."
  end
end