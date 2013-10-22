require 'uri'

class Params
  def initialize(req, route_params)
    params_hash = route_params || {}

    [req.query_string, req.body].each do |params|
      params_hash.merge!(parse_www_encoded_form(params)) unless params.nil?
    end

    @params = params_hash
  end

  def [](key)
    @params[key]
  end

  def to_s
    @params.to_json.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    nested_hash = {}
    flat_hash = Hash[*URI.decode_www_form(www_encoded_form).flatten]

    #only goes one deep right now
    flat_hash.each do |key, value|
      top, sub = parse_key(key)

      if sub.nil?
        nested_hash[key] = value
      else
        nested_hash[top] ||= {}
        nested_hash[top][sub] = value
      end
    end

    nested_hash
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
