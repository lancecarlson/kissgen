require(File.join(File.dirname(__FILE__), "/../spec_helper"))

describe RCGen::Generator do
  describe "new" do
    before(:each) do
      @path = File.dirname(__FILE__) + "/generators/merb_app"
      @copy_path = File.expand_path(File.dirname(__FILE__) + "/generators/empty")
      @bad_path = File.dirname(__FILE__) + "/doesnotexist"
      @empty = File.dirname(__FILE__) + "/generators/empty"
      @generator = RCGen::Generator.new(@path, @copy_path)
    end
    
    it "should fail if the path doesn't exist" do
      lambda { 
        RCGen::Generator.new(@bad_path, @copy_path) 
      }.should raise_error("Generator path does not exist in #{File.expand_path(@bad_path)}")
    end
    
    it "should fail if the setup file cannot be found" do
      lambda {
        RCGen::Generator.new(@empty, @copy_path)
      }.should raise_error("Setup file does not exist in #{File.expand_path(@empty)}")
    end
    
    it "should import template files for a new generator" do
      @generator.files.length.should == 18
      @generator.files[0].copy_path.should == "#{@copy_path}/README"
      @generator.files[1].copy_path.should == "#{@copy_path}/app/controllers"
      @generator.files[2].copy_path.should == "#{@copy_path}/app/controllers/application.rb"
      @generator.files[3].copy_path.should == "#{@copy_path}/app/controllers/exceptions.rb"
      @generator.files[4].copy_path.should == "#{@copy_path}/app/controllers/posts.rb"
      @generator.files[5].copy_path.should == "#{@copy_path}/app/helpers"
      @generator.files[6].copy_path.should == "#{@copy_path}/app/helpers/global_helpers.rb"
      @generator.files[7].copy_path.should == "#{@copy_path}/app/models"
      @generator.files[8].copy_path.should == "#{@copy_path}/app/models/article.rb"
    end
    
    it "should allow you to pretend to generate the files and output the results" do
      @generator.generate(:pretend => true)
    end
    
    it "should generate new template files when no options are not set" do
      #@generator.generate
      #puts @copy_path
      #File.exists?(@copy_path + "/README").should be_true
    end
  end
end