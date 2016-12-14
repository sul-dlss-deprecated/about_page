require 'spec_helper'

describe "AboutPage::GitLog" do
  let(:root) { File.expand_path('../../fixtures',__FILE__) }

  before :each do
    File.rename(File.join(root,'dot_git'),File.join(root,'.git'))
  end

  after :each do
    File.rename(File.join(root,'.git'),File.join(root,'dot_git'))
  end

  it "should respect line limits" do
    pending "Rugged doesn't work under JRuby" if defined? JRUBY_VERSION
    expect(AboutPage::GitLog.new(root: root, limit: 5).commits.length).to eq(5)
  end

  it "should respect RegExp limits" do
    pending "Rugged doesn't work under JRuby" if defined? JRUBY_VERSION
    expect(AboutPage::GitLog.new(root: root, limit: %r{^refs/tags/}).commits.last[:refs]).to include('refs/tags/v0.5')
  end

  it "should respect Proc limits" do
    pending "Rugged doesn't work under JRuby" if defined? JRUBY_VERSION
    check = double('commit checker')
    expect(check).to receive(:check).with(instance_of(Rugged::Commit)).exactly(2).times.and_return(false, true)
    limit = ->(c) { check.check(c) }
    expect(AboutPage::GitLog.new(root: root, limit: limit).commits.length).to eq(2)
  end
  
  describe "without rugged" do
    before :each do
      RuggedPlaceholder = Rugged
      Object.send(:remove_const, :Rugged)
    end
    
    after :each do
      Rugged = RuggedPlaceholder
      Object.send(:remove_const, :RuggedPlaceholder)
    end
    
    it "should issue a warning" do
      pending "Rugged doesn't work under JRuby" if defined? JRUBY_VERSION
      expect(Rails.logger).to receive(:warn)
      expect(AboutPage::GitLog.new.commits).to be_empty
    end
  end
end
