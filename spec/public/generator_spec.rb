require(File.join(File.dirname(__FILE__), "/../spec_helper"))

describe RCGen::Generator do
  describe "new" do
    before(:each) do
      @path = File.dirname(__FILE__) + "/generators/merb_app"
      @bad_path = File.dirname(__FILE__) + "/doesnotexist"
    end
    
    it "should fail if the path doesn't exist" do
      lambda { 
        RCGen::Generator.new(@bad_path) 
      }.should raise_error("No such file or directory - #{@bad_path}")
    end
    
    it "should import template files for a new generator" do
      @generator = RCGen::Generator.new(@path)
      @generator.files.length.should == 18
    end
  end
end