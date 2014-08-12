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
    expect(AboutPage::GitLog.new(root: root, limit: 5).commits.length).to eq(5)
  end
  
  it "should respect RegExp limits" do
    expect(AboutPage::GitLog.new(root: root, limit: %r{^refs/tags/}).commits.last[:refs]).to include('refs/tags/v0.5')
  end

  it "should respect Proc limits" do
    check = double('commit checker')
    expect(check).to receive(:check).with(instance_of(Grit::Commit)).exactly(2).times.and_return(false, true)
    limit = ->(c) { check.check(c) }
    expect(AboutPage::GitLog.new(root: root, limit: limit).commits.length).to eq(2)
  end
end
