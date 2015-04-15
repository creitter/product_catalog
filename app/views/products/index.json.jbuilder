json.array!(@products) do |product|
  json.extract! product, :id, :name, :description, :width, :length, :height, :weight, :value
  json.url product_url(product, format: :json)
end
