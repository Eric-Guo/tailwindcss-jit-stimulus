module UrlHelper
  def addUrlQuery(url, params)
    uri = URI(url)
    query = {}
    if uri.query.present?
      uri.query.split('&').each do |str|
        arr = str.split('=')
        if arr[1]
          key = URI.decode_www_form_component(arr[0])
          value = URI.decode_www_form_component(arr[1])
          if key.end_with?('[]')
            query[key.to_sym] = [*query[key.to_sym], value]
          else
            query[key.to_sym] = value
          end
        end
      end
    end
    uri.query = URI.encode_www_form(query.merge(params))
    uri.to_s
  end

  def url_parse_query(url)
    uri = URI.parse(url)
    query = []
    if uri.query.present?
      uri.query.split('&').each do |str|
        arr = str.split('=')
        if arr[1].present?
          key = URI.decode_www_form_component(arr[0])
          value = URI.decode_www_form_component(arr[1])
          query.push([key, value])
        end
      end
    end
    query
  end
end
