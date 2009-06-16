require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Weary::Request do
  
  it "should contain a url" do
    test = Weary::Request.new("http://google.com")
    test.uri.is_a?(URI).should == true
  end
  
  it "should parse the http method" do
    test = Weary::Request.new("http://google.com", "POST")
    test.method.should == :post
  end
  
  it "should craft a Net/HTTP Request" do
    test = Weary::Request.new("http://google.com").send :http
    test.class.should == Net::HTTP
  end
  
  it "should perform the request and retrieve a response" do
    test = Weary::Request.new("http://foo.bar")
    method = test.method   
    response = mock_response(method, 301, {'Location' => 'http://bar.foo'})
    response.stub!(:follow_redirect).and_return mock_response(method, 200, {})
    test.stub!(:perform).and_return(response)
    test.perform.code.should == 301
    test.perform.redirected?.should == true
    test.perform.follow_redirect.code.should == 200
    # not exactly kosher.
  end
end