require 'spec_helper'
require 'fileutils'

describe RubyDzi::Base do
  describe ".generate!" do
    let(:dir_path) { File.dirname(__FILE__) + "/../#{name}_files" }

    subject { RubyDzi::Base.new(file_path) }

    before do
      FileUtils.rm_rf(dir_path)
      subject.generate!(name)
    end

    context "local file" do
      let(:file_path) { "coffee.jpg" }
      let(:name) { "coffee" }

      specify { expect(subject.image_path).to eq file_path }
      specify { expect(Dir.exists?(dir_path)).to eq true }
    end

    context "from the internetz" do
      let(:file_path) { 'http://farm5.static.flickr.com/4034/4717106041_c116b92c81_b_d.jpg' }
      let(:name) { "sunset"}

      specify { expect(subject.image_path).to eq file_path }
      specify { expect(Dir.exists?(dir_path)).to eq true }
    end
  end
end
