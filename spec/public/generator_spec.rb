require(File.join(File.dirname(__FILE__), "/../spec_helper"))

describe KISSGen::Generator do
  describe "new" do
    before(:each) do
      @path      = File.dirname(__FILE__) + "/generators/merb_app"
      @target = File.dirname(__FILE__) + "/generators/empty"
      @bad_path  = File.dirname(__FILE__) + "/doesnotexist"
      @empty     = File.dirname(__FILE__) + "/generators/empty"
      @generator = KISSGen::Generator.new(@path, @target)
    end
    
    it "should import template files for a new generator" do
      @generator.files.length.should == 12
      @generator.files[0].target.should == "README"
      @generator.files[1].target.should == "Rakefile"
      @generator.files[2].target.should == "app/controllers/application.rb"
      @generator.files[3].target.should == "app/controllers/exceptions.rb"
      @generator.files[4].target.should == "app/controllers/posts.rb"
      @generator.files[5].target.should == "app/helpers/global_helpers.rb"
      @generator.files[6].target.should == "app/models/article.rb"
    end
    
    it "should allow you to pretend to generate the files and output the results" do
      @generator.generate(:pretend => true)
    end
    
    it "should generate new template files when no options are not set" do
      @generator.generate
      File.exists?(@target + "/README").should be_true
      File.delete(@target + "/README")
      File.delete(@target + "/Rakefile")
    end
  end
  
  describe "assigns" do
    before(:each) do
      @path = File.dirname(__FILE__) + "/generators/merb_very_flat"
      @target = File.dirname(__FILE__) + "/generators/empty"
      @generator = KISSGen::Generator.new(@path, @target)
      @generator.directory "/"
    end
    
    it "should allow you to pass through assigned methods" do
      class String; def camel_case; split('_').map{|e| e.capitalize}.join; end; end
      @generator.assign :app_file_name, "lancelot"
      
      @generator.assigns.should == {:app_file_name => "lancelot"}
      @generator.files.first.target.should == "/lancelot.rb"
      
      @generator.generate
      @generator.delete
    end
  end
end
