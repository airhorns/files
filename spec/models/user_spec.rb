require 'spec_helper'
require 'set'

def new_user_with_downloaded(dls)
  u = User.new
  u.downloads.clear
  dls.each do |d|
    u.mark_as_downloaded(mp(d), true)
  end
  u
end

describe User do
  describe "downloads tracking" do
    before(:all) do
      FileCache.rebuild!
    end

    it "should report a file correctly" do
      user = new_user_with_downloaded(['/a.rb', '/b.rb'])  
      user.downloaded?(mp '/a.rb').should == true
      user.downloaded?(mp '/b.rb').should == true
      user.downloaded?(mp '/c.rb').should == false
    end

    it "should report a directory correctly" do
      user = new_user_with_downloaded(['/a/a.rb', '/a/b.rb', '/a', '/b/a.rb'])  
      user.downloaded?(mp '/a').should == true
      user.downloaded?(mp '/b').should == false
    end
    
    it "should recursively mark subordinate files when marking a directory" do
      user = new_user_with_downloaded([])
      user.downloaded?(mp '/b/4.rb').should == false
      user.downloaded?(mp '/b/e/5.rb').should == false
      user.mark_as_downloaded(mp '/b')
      user.downloaded?(mp '/b/4.rb').should == true
      user.downloaded?(mp '/b/e/5.rb').should == true
    end

    it "should mark a directory as downloaded if all the files in it are downloaded" do
      user = new_user_with_downloaded(['/a/1.rb'])
      user.downloaded?(mp '/a').should == false
      user.mark_as_downloaded(mp '/a/2.rb')
      user.downloaded?(mp '/a').should == true
    end

    it "should bubble up changes from sub dirs when setting" do
      user = new_user_with_downloaded(['/b/e/5.rb', '/b/4.rb', '/b/3.rb'])
      user.downloaded?(mp '/b').should == false
      user.downloaded?(mp '/b/e').should == false
      user.mark_as_downloaded(mp '/b/e/6.rb')
      user.downloaded?(mp '/b').should == true
      user.downloaded?(mp '/b/e').should == true
    end

    it "shouldn't care about trailing slashes on directories" do
      user = new_user_with_downloaded(['/b/e/5.rb','/b/3.rb','/b/4.rb','/b/e/6.rb'])
      user.downloaded?(mp '/b/e').should == true
      user.downloaded?(mp '/b/e/').should == true
      user.downloaded?(mp '/b').should == true
      user.downloaded?(mp '/b/').should == true
    end
  end
end
