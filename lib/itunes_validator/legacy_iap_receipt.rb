module ItunesValidator
  class LegacyIapReceipt
    def self.from_h(h)
      r = self.new
      r.from_h(h)
      r
    end

    attr_reader :transaction_id, :original_transaction_id
    attr_reader :item_id, :product_id, :quantity
    attr_reader :purchase_date, :original_purchase_date
    attr_reader :expires_date
    attr_reader :app_item_id, :bid, :bvrs

    def from_h(h)
      @transaction_id, @original_transaction_id = h['transaction_id'], h['original_transaction_id']
      @item_id = h['item_id']
      @product_id = h['product_id']
      @quantity = (Integer(h['quantity']) if h['quantity']) || 0
      @transaction_id = h['transaction_id']
      @purchase_date = (Time.at(h['purchase_date_ms'].to_i / 1000.0) if h['purchase_date_ms'])
      @original_purchase_date = (Time.at(h['original_purchase_date_ms'].to_i / 1000.0) if h['original_purchase_date_ms'])
      @expires_date = (Time.at(h['expires_date'].to_i / 1000.0) if h['expires_date'])
      @app_item_id, @bid, @bvrs = h['app_item_id'], h['bid'], h['bvrs']
      self
    end
  end
end
