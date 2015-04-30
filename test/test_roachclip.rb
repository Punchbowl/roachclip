require 'minitest_helper'

describe "Roachclip" do
  it "has a version number" do
    refute_nil ::Roachclip::VERSION
  end

  it "includes Joint when included" do
    Asset.included_modules.must_include Joint
  end
end

describe "Roachclip attachment proxies" do
  let(:subject) { Asset.new }

  it "has attachments" do
    Asset.roachclip_attachments.size.must_equal 1
    Asset.roachclip_attachments.first.must_be_instance_of Roachclip::Attachment
  end

  it "has a default joint attachment proxy" do
    assert subject.respond_to? :image
    assert subject.respond_to? :image=
    subject.image.must_be_instance_of Joint::AttachmentProxy
  end

  it "has style attachment proxies for large" do
    subject.image_large.must_be_instance_of Joint::AttachmentProxy
    assert subject.respond_to? :image_large
    assert subject.respond_to? :image_large=

    key_names.each do |name|
      assert subject.respond_to? "image_large_#{name}"
    end
  end

  it "has style attachment proxies for thumb" do
    subject.image_thumb.must_be_instance_of Joint::AttachmentProxy
    assert subject.respond_to? :image_thumb
    assert subject.respond_to? :image_thumb=

    key_names.each do |name|
      assert subject.respond_to? "image_thumb_#{name}"
    end
  end

  describe "with default style" do
    let(:subject) { OriginalAsset.new }

    it "does not have attachment proxy for default style" do
      refute subject.respond_to? :image_original
      subject.image.must_be_instance_of Joint::AttachmentProxy
      subject.image_thumb.must_be_instance_of Joint::AttachmentProxy
    end
  end
end

describe "Saving Roachlip documents" do

  before do
    @image = open_file('cats.jpg')
  end

  after do
    all_files.each { |file| file.close }
  end

  it "should save attachments for original and styles" do
    assert_grid_difference(3) do
      Asset.create(image: @image)
      rewind_files
    end
  end

  it "should process styles" do
    Paperclip::Thumbnail.any_instance.expects(:make).twice
    Asset.create(image: @image)
    rewind_files
  end

  describe "with default style" do

    it "should save attachments for original and styles" do
      assert_grid_difference(2) do
        OriginalAsset.create(image: @image)
        rewind_files
      end
    end

    it "should process styles on all attachments" do
      Paperclip::Thumbnail.any_instance.expects(:make).twice
      OriginalAsset.create(image: @image)
      rewind_files
    end
  end

end

describe "Destroying attachments in Roachclip documents" do

  before do
    @image = open_file('cats.jpg')
  end

  after do
    all_files.each { |file| file.close }
  end

  it "destroys thumbs when image set to nil" do
    subject = Asset.create(image: @image)
    rewind_files

    assert_grid_difference(-3) do
      subject.image = nil
      subject.save
    end
  end

  describe "with default style" do
    it "destroys thumbs when image set to nil" do
      subject = OriginalAsset.create(image: @image)
      rewind_files

      assert_grid_difference(-2) do
        subject.image = nil
        subject.save
      end
    end
  end
end
