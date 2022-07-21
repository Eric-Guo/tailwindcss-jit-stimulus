# frozen_string_literal: true

class ThtriApi
  def self.generate_url(path)
    File.join(Rails.application.credentials.thtri_api_prefix!, 'admin_api', path)
  end

  def self.upload_img(file, headers = {})
    filename = file.original_filename
    response = HTTP.headers(headers).post(generate_url('thtri/updateImages'), form: {
      file: HTTP::FormData::File.new(file)
    })
    body = JSON.parse(response.body.to_s)
    raise Exception.new(body['msg']) unless body['code'] == 0
    file = body['data']['file']
    {
      name: filename,
      url: file['url'],
      tag: file['tag'],
    }
  end

  def self.pm_projects(params = {}, headers = {})
    response = HTTP.headers(headers).get(generate_url('thtri/pmProjects'), params: params)
    body = JSON.parse(response.body.to_s)
    raise Exception.new(body['msg']) unless body['code'] == 0
    body['data']
  end

  def self.matlib_projects(params = {}, headers = {})
    response = HTTP.headers(headers).get(generate_url('thtri/cases'), params: params)
    body = JSON.parse(response.body.to_s)
    raise Exception.new(body['msg']) unless body['code'] == 0
    body['data']
  end

  def self.create_manufacturer_recommend(json, headers = {})
    response = HTTP.headers(headers).post(generate_url('thtri/createManufacturerRecommend'), json: json)
    body = JSON.parse(response.body.to_s)
    raise Exception.new(body['msg']) unless body['code'] == 0
    body['data']
  end
  
  def self.generate_download_url(args)
    response = HTTP.get(generate_url('nologin/getDownloadCode'), params: args)
    body = JSON.parse(response.body.to_s)
    raise Exception.new(body['msg']) unless body['code'] == 0
    code = body['data']['code']
    "#{generate_url('nologin/onceDownload')}?code=#{code}"
  end
end
