require 'spec_helper'

describe RubyDzi::Base do
  describe ".generate!" do
    subject { RubyDzi::Base.new(file_path) }

    before { subject.generate!(name) }

    context "local file" do
      let(:file_path) { "coffee.jpg" }
      let(:name) { "coffee" }

      specify { expect(subject.image_path).to eq file_path }
      specify { expect(Dir.exists?(File.dirname(__FILE__) + "/../#{name}_files")).to eq true }
    end

    context "from the internetz" do
      let(:file_path) { 'http://farm5.static.flickr.com/4034/4717106041_c116b92c81_b_d.jpg' }
      let(:name) { "sunset"}

      specify { expect(subject.image_path).to eq file_path }
      specify { expect(Dir.exists?(File.dirname(__FILE__) + "/../#{name}_files")).to eq true }
    end
  end
end
