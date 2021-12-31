# frozen_string_literal: true

class Demand
  def self.cates
    response = HTTP.get("https://matlib.thape.com.cn/api/demand_types")
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

  def self.upload_file(file)
    filename = file.original_filename
    response = HTTP.post("https://matlib.thape.com.cn/api/demand_files", form: {
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

  def self.submit(data, ip)
    response = HTTP.headers({
      'X-Forwarded-For': ip,
      'X-Real-IP': ip,
    }).post("https://matlib.thape.com.cn/api/demands", json: data)
    body = JSON.parse(response.body.to_s)
    {
      code: body['code'],
      msg: body['msg']
    }
  end
end
