require 's3_awesomeness_config' unless defined?(CONF)

puts "Syncing files from #{CACHE} to #{CONF['staging_bucket']}..."
`#{S3SYNC} -r --make-dirs #{CACHE}/ #{CONF['staging_bucket']}:`