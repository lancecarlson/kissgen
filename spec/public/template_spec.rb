require(File.join(File.dirname(__FILE__), "/../spec_helper"))

describe KISSGen::Generator do
  describe "new" do
    before(:each) do
      @copy_from = File.dirname(__FILE__) + "/generators/merb_app/app"
      @copy_to = File.dirname(__FILE__) + "/generators/empty/app"
      @path = "views/layout/application.html.erb"
      @generator = mock(KISSGen::Generator)
      @generator.stub!(:path).and_return(@copy_from)
      @generator.stub!(:copy_path).and_return(@copy_to)
      @template = KISSGen::Template.new(@generator, @path, @path)
    end
    
    def application_erb_output
      %Q(<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
  <head>
    <title>Fresh Merb App</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <link rel="stylesheet" href="/stylesheets/master.css" type="text/css" media="screen" charset="utf-8">
  </head>
  <body>
    <%= catch_content :for_layout %>
  </body>
</html>)
    end
    
    it "should have an erb parsed output" do
      @template.output.should == application_erb_output
    end
    
    it "should create the file in the copy directory and feed it the erb output" do
      @template.create
      IO.read(@template.full_copy_path).should == application_erb_output
      @template.delete
      FileUtils.remove_dir(@copy_to)
    end

  end
end