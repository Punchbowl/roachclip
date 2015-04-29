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

  roachclip :image, styles: {
    original: { :geometry => '256x256^', :convert_options => '-gravity center -background white -extent 256x256' },
    large:    { :geometry => '133x133^', :convert_options => '-gravity center -background white -extent 133x133' },
    thumb:    { :geometry => '60x60^', :convert_options => '-gravity center -background white -extent 60x60' }
  }
end
