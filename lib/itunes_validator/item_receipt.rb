module ItunesValidator
  class ItemReceipt
    def self.from_h(h)
      r = self.new
      r.from_h(h)
      r
    end

    attr_reader :transaction_id, :original_transaction_id
    attr_reader :product_id, :quantity
    attr_reader :purchase_date, :original_purchase_date
    attr_reader :expires_date, :cancellation_date
    attr_reader :app_item_id, :web_order_line_item_id, :version_external_identifier

    def from_h(h)
      @transaction_id, @original_transaction_id = h['transaction_id'], h['original_transaction_id']
      @product_id = h['product_id']
      @quantity = (Integer(h['quantity']) if h['quantity']) || 0
      @purchase_date = h['purchase_date']
      @original_purchase_date = h['original_purchase_date']
      @expires_date = h['expires_date'] if h['expires_date']
      @cancellation_date = h['cancellation_date'] if h['cancellation_date']
      @web_order_line_item_id = h['web_order_line_item_id']
      @version_external_identifier = h['version_external_identifier']
      @app_item_id = h['app_item_id'],
      self
    end
  end
end
