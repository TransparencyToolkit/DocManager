require "rails_helper"

RSpec.describe IndexManager do
  describe "index creation" do
    let(:client) {Doc.gateway.client}
    
    it "should create a new index" do
      IndexManager.create_index("test_index4")
      expect(client.indices.exists? index: 'test_index4').to be_truthy
    end
  end
end
