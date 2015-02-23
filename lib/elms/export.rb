# {
#     "products": [
#     {
#         "product": "filtr",
#     "price": 122.50,
#     "pcs": 1,
#     "tax": 21
# },
#     {
#         "product": "produkt2",
#     "price": 1000.50,
#     "pcs": 2,
#     "tax": 21
# },
#     {
#         "product": "cpost",
#     "price": 99,
#     "pcs": 1,
#     "tax": 21
# }
# ],
#  "cod": true,
# "order_number": "123456",
#     "total": 1222.00,
#     "customer": {
#     "company": “Firma s.r.o.”,
#     "name": "Jan",
#     "surname": "Novák",
#     "email": "jan.novak@seznam.cz",
#     "street": "Karlova 28",
#     "city": "Kolín",
#     "country": "CZ",
#     "postal_code": "28000",
#     "phone": "602286104",
#     "ic": "65242555",
#     "dic": "CZ7410111234",
#     “del_company": “Firma s.r.o.”,
#     "del_name": "Jana",
#     "del_surname": "Nováková",
#     "del_street": "Hlavní 546",
#     "del_city": "Poděbrady",
#     "del_postal_code": "29000",
#     "del_country": "CZ",
#     "del_phone": "723990099",
#     "del_email": "jana.novakova@seznam.cz"
#   },
#  "source": "d41d8cd98f00b204e9800998ecf8427e",
#  "order_date": "2013-10-01 12:34:45",
#  "currency_id": 1,
#  "invoice_number": "13100078"
# }

module Elms
  class Export

    CURRENCY_CZK = '1'
    CURRENCY_EUR = '2'

    def initialize(source)

      @data = {
          :products => [],
          :cod => true,
          :order_number => nil,
          :total => 0,
          :customer => {
              :company => '',
              :name => '',
              :surname => '',
              :email => '',
              :street => '',
              :city => '',
              :country => '',
              :postal_code => '',
              :phone => '',
              :ic => '',
              :dic => '',
              :del_company => '',
              :del_name => '',
              :del_surname => '',
              :del_street => '',
              :del_city => '',
              :del_postal_code => '',
              :del_country => '',
              :del_phone => '',
              :del_email => ''
          },
          :source => source,
          :order_date => '',
          :currency_id => 1,
          :invoice_number => ''
      }


      @cod = false
      @order_number = nil
      @total = 0.0
      @customer = {}
      @invoice_number = nil
    end

    def order_number=(order_number)
      @data[:order_number] = order_number
      self
    end

    def order_number
      @data[:order_number]
    end


    # @param [Boolean] cod - cash on delivery
    def cod=(cod)
      @data[:cod] = cod
      self
    end

    def total=(total)
      @data[:total] = total
      self
    end

    def order_date=(date)
      @data[:order_date] = date
      self
    end

    def invoice_number=(number)
      @data[:invoice_number] = number
      self
    end


# @param [String] product_name PLU in ELMS
# @param [Float] product_price price with VAT
# @param [Integer] peaces How many
# @param [Integer] tax DPH in %
    def add_product(product_name, product_price, peaces, tax)
      @data[:products]<< {:product => product_name, :price => product_price, :pcs => peaces, :tax => tax}
      @data[:total] += product_price*peaces
      self
    end

# @param [String] company
# @param [String] name
# @param [String] surname
# @param [String] email
# @param [String] street
# @param [String] city
# @param [String] country
# @param [String] postal_code
# @param [String] phone
# @param [String] ic
# @param [String] dic
    def customer(company, name, surname, email, street, city, country, postal_code, phone, ic = nil, dic = nil)
      @data[:customer][:company] = company
      @data[:customer][:name] = name
      @data[:customer][:surname] = surname
      @data[:customer][:email] = email
      @data[:customer][:street] = street
      @data[:customer][:city] = city
      @data[:customer][:country] = country
      @data[:customer][:postal_code] = postal_code
      @data[:customer][:phone] = phone
      @data[:customer][:ic] = ic
      @data[:customer][:dic] = dic
      self
    end

# @param [String] company
# @param [String] name
# @param [String] surname
# @param [String] email
# @param [String] street
# @param [String] city
# @param [String] country
# @param [String] postal_code
# @param [String] phone
    def delivery(company, name, surname, email, street, city, country, postal_code, phone)
      @data[:customer][:del_company] = company
      @data[:customer][:del_name] = name
      @data[:customer][:del_surname] = surname
      @data[:customer][:del_email] = email
      @data[:customer][:del_street] = street
      @data[:customer][:del_city] = city
      @data[:customer][:del_country] = country
      @data[:customer][:del_postal_code] = postal_code
      @data[:customer][:del_phone] = phone
      self
    end


# @param [Integer] currency One of CURRENCY_CZK - 1 or CURRENCY_EUR - 2
    def currency(currency)
      if (currency != CURRENCY_CZK and currency != CURRENCY_EUR)
        throw 'Invalid currency :'+currency
      end
      @data[:currency_id] = currency
      self
    end


    def sendToElms
      require 'base64'
      require 'json'
      require 'net/http'
      require 'curl'

      encoded = Base64.strict_encode64(@data.to_json.to_s)

      # http://fulfillment.elmsservice.cz/orders/import?data=
      send_to_url = "http://fulfillment.elmsservice.cz/orders/import?data=#{encoded}"
      res = ::Curl.get(send_to_url)
      res.body_str

    end
  end
end