require 'bundler/setup'
Bundler.setup(:default, 'test', 'development')

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'roachclip'

require 'logger'
require 'byebug'
require 'active_support/testing/assertions'
require 'mongo_mapper'
require 'joint'
require 'paperclip'

require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/mini_test'

log_dir = File.expand_path('../../log', __FILE__)
FileUtils.mkdir_p(log_dir)
logger = Logger.new(File.join(log_dir, 'test.log'))

MongoMapper.connection = Mongo::Client.new(['127.0.0.1:27017'], :database => 'joint_test', :logger => logger)
MongoMapper.database = "roachclip_test"
MongoMapper.database.collections.each { |c| c.indexes.drop_all }

Paperclip.options[:log] = false

class Minitest::Test
  include ActiveSupport::Testing::Assertions

  def setup
    MongoMapper.database.collections.each { |coll| coll.drop unless coll.name =~ /^system/ }
  end
  
  def assert_grid_difference(difference=1, collection_name='fs', &block)
    assert_difference("MongoMapper.database['#{collection_name}.files'].find().count", difference, &block)
  end

  def assert_no_grid_difference(collection_name = 'fs', &block)
    assert_grid_difference(0, collection_name, &block)
  end
end

class Asset
  include MongoMapper::Document
  plugin Roachclip

  roachclip :image, styles: {
    large:    { :geometry => '133x133^', :convert_options => '-gravity center -background white -extent 133x133' },
    thumb:    { :geometry => '60x60^', :convert_options => '-gravity center -background white -extent 60x60' }
  }
end

class InheritedAsset < Asset
end

class ExtendedAsset < Asset
  attachment :image_alt
end

class BareAsset
  include MongoMapper::Document
  plugin Roachclip

  roachclip :image
end

class OriginalAsset
  include MongoMapper::Document
  plugin Roachclip

  roachclip :image, styles: {
    original: { :geometry => '256x256^', :convert_options => '-gravity center -background white -extent 256x256' },
    thumb:    { :geometry => '60x60^', :convert_options => '-gravity center -background white -extent 60x60' }
  }, path: '/gridfs/assets/%s/foo/%s'
end

class MixedAsset
  include MongoMapper::Document
  plugin Roachclip

  roachclip :image
  roachclip :image_alt, path: '/file/path/%s/%s'
end

class ValidatedAsset
  include MongoMapper::Document
  plugin Roachclip

  roachclip :optional
  roachclip :image
  roachclip :image_alt, path: '/file/path/%s/%s', required: true

  validates_roachclip :image
end

module RoachclipTestHelpers
  def all_files
    [ @image, @image_alt ]
  end

  def rewind_files
    all_files.each { |file| file.rewind }
  end

  def open_file(name)
    f = File.open(File.join(File.dirname(__FILE__), 'fixtures', name), 'r')
    f.binmode
    f
  end

  def fs_bucket(collection_name = 'fs')
    @fs_buckets ||= {}
    @fs_buckets[collection_name] ||= MongoMapper.database.fs(bucket_name: collection_name)
  end

  def key_names
    [:id, :name, :type, :size]
  end
end
Minitest::Test.send :include, RoachclipTestHelpers
