require(File.join(File.dirname(__FILE__), "/../spec_helper"))

describe KISSGen::Generator do
  describe "new" do
    before(:each) do
      @path = File.dirname(__FILE__) + "/generators/merb_app"
      @copy_path = File.expand_path(File.dirname(__FILE__) + "/generators/empty")
      @bad_path = File.dirname(__FILE__) + "/doesnotexist"
      @empty = File.dirname(__FILE__) + "/generators/empty"
      @generator = KISSGen::Generator.new(@path, @copy_path)
    end
    
    it "should fail if the setup file cannot be found" do
      lambda {
        KISSGen::Generator.new(@empty, @copy_path)
      }.should raise_error("Setup file does not exist in #{File.expand_path(@empty) + "/setup.rb"}")
    end
    
    it "should import template files for a new generator" do
      @generator.files.length.should == 12
      @generator.files[0].copy_path.should == "README"
      @generator.files[1].copy_path.should == "Rakefile"
      @generator.files[2].copy_path.should == "app/controllers/application.rb"
      @generator.files[3].copy_path.should == "app/controllers/exceptions.rb"
      @generator.files[4].copy_path.should == "app/controllers/posts.rb"
      @generator.files[5].copy_path.should == "app/helpers/global_helpers.rb"
      @generator.files[6].copy_path.should == "app/models/article.rb"
    end
    
    it "should allow you to pretend to generate the files and output the results" do
      @generator.generate(:pretend => true)
    end
    
    it "should generate new template files when no options are not set" do
      @generator.generate
      File.exists?(@copy_path + "/README").should be_true
    end
  end
end