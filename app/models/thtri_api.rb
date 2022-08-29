# frozen_string_literal: true

class ThtriApi
  def self.generate_url(path)
    File.join(Rails.application.credentials.thtri_api_prefix!, 'admin_api', path)
  end

  def self.demand_cates
    response = HTTP.get(generate_url('demand_types'))
    JSON.parse(response.body.to_s)['data'].map do |cate|
      {
        id: cate['id'],
        name: cate['name'],
        materials: cate['Lists'].map do |item|
          {
            id: item['Id'],
            name: item['Name'],
          }
        end
      }
    end
  end

  def self.demand_submit(data, ip)
    response = HTTP.headers({
      'X-Forwarded-For': ip,
      'X-Real-IP': ip,
    }).post(generate_url('demands'), json: data)
    body = JSON.parse(response.body.to_s)
    {
      code: body['code'],
      msg: body['msg']
    }
  end

  def self.demand_upload_file(file)
    filename = file.original_filename
    response = HTTP.post(generate_url('demand_files'), form: {
      file: HTTP::FormData::File.new(file)
    })
    body = JSON.parse(response.body.to_s)
    file = body['data']['file']
    {
      name: filename,
      url: file['url'],
      tag: file['tag'],
    }
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

  # 给供应商投票
  def self.vote_for_manufacturer(args, headers = {})
    response = HTTP.headers(headers).post(generate_url("thtri/manufactors/#{args[:manufacturer_id]}/vote"), json: {
      vote: args[:vote]
    })
    body = JSON.parse(response.body.to_s)
    raise Exception.new(body['msg']) unless body['code'] == 0
    body['data']
  end

  # 提交供应商反馈
  def self.create_manufacturer_feedback(args, headers = {})
    response = HTTP.headers(headers).post(generate_url("thtri/manufactors/#{args[:manufacturer_id]}/feedback"), json: {
      opinion: args[:description],
      questionTypeIds: args[:question_type_ids],
      screenshotPath: args[:screenshot_path],
      references: args[:references],
    })
    body = JSON.parse(response.body.to_s)
    raise Exception.new(body['msg']) unless body['code'] == 0
    body['data']
  end
end
