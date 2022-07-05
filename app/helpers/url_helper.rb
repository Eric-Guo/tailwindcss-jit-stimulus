module UrlHelper
  def addUrlQuery(url, params)
    uri = URI(url)
    query = {}
    if uri.query.present?
      uri.query.split('&').each do |str|
        arr = str.split('=')
        query[arr[0]] = URI.decode_www_form_component(arr[1]) if arr[1].present?
      end
    end
    uri.query = URI.encode_www_form(query.merge(params))
    uri.to_s
  end
end
