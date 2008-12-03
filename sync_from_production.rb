#!/usr/bin/ruby
require 's3_awesomeness_config'

`#{S3SYNC} -r --progress --debug --verbose --make-dirs s3sync-production: #{CACHE}`