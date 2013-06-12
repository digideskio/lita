require "spec_helper"

describe Lita do
  it "memoizes a hash of Adapters" do
    adapter_class = double("Adapter")
    described_class.register_adapter(:foo, adapter_class)
    expect(described_class.adapters[:foo]).to eql(adapter_class)
    expect(described_class.adapters).to eql(described_class.adapters)
  end

  it "memoizes a set of Handlers" do
    handler_class = double("Handler")
    described_class.register_handler(handler_class)
    described_class.register_handler(handler_class)
    expect(described_class.handlers.to_a).to eq([handler_class])
    expect(described_class.handlers).to eql(described_class.handlers)
  end

  it "memoizes a Config" do
    expect(described_class.config).to be_a(Lita::Config)
    expect(described_class.config).to eql(described_class.config)
  end

  describe ".configure" do
    it "yields the Config object" do
      described_class.configure { |c| c.robot.name = "Not Lita" }
      expect(described_class.config.robot.name).to eq("Not Lita")
    end
  end

  describe ".redis" do
    it "memoizes a Redis::Namespace" do
      expect(described_class.redis.namespace).to eq(
        described_class::REDIS_NAMESPACE
      )
      expect(described_class.redis).to eql(described_class.redis)
    end
  end

  describe ".run" do
    it "laods the user config" do
      expect(Lita::Config).to receive(:load_user_config)
      allow_any_instance_of(Lita::Robot).to receive(:run)
      described_class.run
    end

    it "runs a new Robot" do
      expect_any_instance_of(Lita::Robot).to receive(:run)
      described_class.run
    end
  end
end
