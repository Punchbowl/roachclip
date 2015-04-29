require 'minitest_helper'

describe "Roachclip" do

  it "has a version number" do
    refute_nil ::Roachclip::VERSION
  end

end

describe "Roachclip documents" do
  it "has Joint" do
    Asset.joint_collection_name.must_equal 'fs'
  end

  it "has roaches" do
    Asset.roaches.size.must_equal 2
  end
end
