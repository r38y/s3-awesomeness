require 's3_awesomeness_config' unless defined?(CONF)

puts "Syncing files from #{CONF['production_bucket']} to #{CACHE}..."
`#{S3SYNC} -r --make-dirs #{CONF['production_bucket']}: #{CACHE}`