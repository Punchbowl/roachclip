require 'minitest_helper'

describe "Roachclip" do
  it "has a version number" do
    refute_nil ::Roachclip::VERSION
  end

  it "includes Joint when included" do
    Asset.included_modules.must_include Joint
  end
end

describe "Roachclip documents" do
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

  it "has style attachment proxies" do
    assert subject.respond_to? :image_large
    assert subject.respond_to? :image_large=
    subject.image_large.must_be_instance_of Joint::AttachmentProxy

    assert subject.respond_to? :image_thumb
    assert subject.respond_to? :image_thumb=
    subject.image_thumb.must_be_instance_of Joint::AttachmentProxy
  end

  it "does not create a new proxy for default style" do
    refute subject.respond_to? :image_original
  end

end
