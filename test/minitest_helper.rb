require 'bundler/setup'
Bundler.setup(:default, 'test', 'development')

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'roachclip'

require 'mongo_mapper'
require 'joint'

require 'minitest/autorun'
require 'minitest/pride'

MongoMapper.database = "roachclip_test"

class Minitest::Test
  def setup
    MongoMapper.database.collections.each { |coll| coll.remove unless coll.name =~ /^system/ }
  end
end

class Asset
  include MongoMapper::Document
  plugin Roachclip

  key :title, String
  roachclip :image
  roachclip :preview
end
