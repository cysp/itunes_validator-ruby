module ItunesValidator
  class AppReceipt
    def self.from_h(h)
      r = self.new
      r.from_h(h)
      r
    end

    attr_reader :application_version, :original_application_version
    attr_reader :in_app, :bundle_id

    def from_h(h)
      @application_version = h['application_version']
      @original_application_version = h['original_application_version']
      @bundle_id = h['bundle_id']
      @in_app = h['in_app'].map { |ia| ItemReceipt.from_h(ia) if ia}
      self
    end
  end
end
