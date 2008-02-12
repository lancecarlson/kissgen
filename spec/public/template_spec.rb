require(File.join(File.dirname(__FILE__), "/../spec_helper"))

describe RCGen::Generator do
  describe "new" do
    before(:each) do
      @path = File.dirname(__FILE__) + "/generators/merb_app/app/views/layout/application.html.erb"
      @copy_path = File.dirname(__FILE__) + "/generators/empty"
      @template = RCGen::Template.new(@path, @copy_path)
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
      IO.read(@template.new_path).should == application_erb_output
      @template.delete
    end

  end
end