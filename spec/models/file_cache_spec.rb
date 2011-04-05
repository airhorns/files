require 'spec_helper'

def massage_glob(ary)
  ary.collect do |f|
    if File.directory?(f)
      "#{f}/"
    else
      f
    end
  end.sort
end

describe FileCache do
  before(:all) do
    FileCache.build!
  end

  it "should report the set of all files" do
    FileCache.all.to_a.sort.should == massage_glob(Dir.glob(File.join(Files::Config.files_path, '**', '*')))
  end

  it "should report the set of files immediately underneath a folder" do
    FileCache.all_immediately_underneath(mp 'a/').sort.should == ['a/1.rb', 'a/2.rb'].map {|x| mp x}.sort
  end

  it "should report the set of files recursively underneath a folder" do
    FileCache.all_underneath(mp 'b/').sort.should == massage_glob(['b/3.rb', 'b/4.rb', 'b/e', 'b/e/5.rb', 'b/e/6.rb'].map {|x| mp x})
  end

  it "should report directories" do
    
  end
end
