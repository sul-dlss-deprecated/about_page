require 'spec_helper'

describe AboutPage::Solr do
  before :each do
    @mock_solr_connection = double('RSolr::Connection')
    @mock_solr_connection.stub(:uri, URI.parse("http://example.edu/solr"))
  end

  subject { AboutPage::Solr.new(@mock_solr_connection) }

  describe "#schema" do
    it "should be empty if the connection to solr fails" do
      @mock_solr_connection.should_receive(:get).with('admin/luke', an_instance_of(Hash)).and_throw(:msg)
      subject.schema.should be_empty
    end
    it "should retrieve index information from luke" do
      @mock_solr_connection.should_receive(:get).with('admin/luke', an_instance_of(Hash)).and_return { Hash.new }
      subject.schema.should be_a_kind_of(Hash)
    end
  end

  describe "#index" do
    it "should get the index information from the schema" do
      m = mock()
      subject.stub(:schema).and_return { { 'index' => m }}

      subject.index.should == m
    end
  end

  describe "#valid?" do
    it "should be ok if the number of documents in the index is greater than or equal to the :minimum_numdocs" do
      subject.stub(:ping).and_return { 'OK' } 
      subject.stub(:schema).and_return { { 'index' => { :numDocs => 1 } } } 
      subject.stub(:expects).and_return 1
      subject.should be_valid
    end

    it "should be not be ok if the number of documents in the index is less than the :minimum_numdocs" do
      subject.stub(:ping).and_return { 'OK' } 
      subject.stub(:schema).and_return { { 'index' => { :numDocs => 1 } } }
      subject.stub(:expects).and_return 5
      subject.should_not be_valid
    end

    it "should not be ok if the index :numDocs param is not set" do
      subject.stub(:ping).and_return { 'OK' } 
      subject.stub(:schema).and_return { { 'index' => { } } } 
      subject.stub(:expects).and_return 1
      subject.should_not be_valid
    end

    it "should not be ok if the server doesn't respond to ping" do
      subject.stub(:ping).and_return nil
      subject.stub(:schema).and_return { { 'index' => { } } } 
      subject.stub(:expects).and_return 1
      subject.should_not be_valid
    end
  end

  describe "#set_headers!" do
    it "should add helpful headers when something is wrong" do
      subject.stub(:ping).and_return { 'OK' } 
      subject.stub(:schema).and_return { { 'index' => { :numDocs => 1 } } } 
      subject.stub(:expects).and_return 5

      subject.should_receive(:add_header)
      subject.set_headers! mock()
    end
  end

  describe "#minimum_numdocs" do
    it "should default to 1" do
      subject.expects(:numDocs).should == 1
    end

    it "should use parameters given in the configuration" do
      node = AboutPage::Solr.new(@mock_solr_connection, :expects => { :numDocs => 5 })
      node.expects(:numDocs).should == 5
    end

    it "should use the request parameters to set the minimum_numdocs" do
      node = AboutPage::Solr.new(@mock_solr_connection, :expects => { :numDocs => 5 })
      node.preflight(mock(:params => { 'solr.numDocs' => 1000 }))

      node.expects(:numDocs).should == 1000 
    end
  end


end
