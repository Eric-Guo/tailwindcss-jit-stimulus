# frozen_string_literal: true

namespace :clzx do
  desc "导出材料在线商家及产品信息"
  task :export_all, [:dir_path, :token] => :environment do |t, args|
    throw Exception.new('文件夹不能为空') unless args[:dir_path].present?
    throw Exception.new('token不能为空') unless args[:token].present?
    throw Exception.new('文件夹不存在') unless File.exist?(args[:dir_path])

    rootDir = Pathname(args[:dir_path]).join(Time.now.strftime('%Y%m%d%H%M%S'))
    Dir.mkdir(rootDir)
    puts "导出文件夹 -- , #{rootDir}"

    access_token = args[:token]

    bss = []
    bss_total = 0
    bss_page = 1
    bss_page_size = 30
    bss_url = 'http://api.clzx.net/public/html/index/storeShow'

    begin
      form_data = {
        page: bss_page,
        page_size: bss_page_size,
        access_token: access_token,
        prov_id: '',
        mold_id: '',
        mold_ids: '',
        search: '',
        search_file: '',
      }

      response = HTTP.post(bss_url, form: form_data)

      raise Errors::UnprocessableEntity.new('访问材料在线服务器失败') unless response.status.success?

      result = JSON.parse(response.body.to_s).with_indifferent_access

      raise Errors::UnprocessableEntity.new('获取结果失败') unless result[:success]

      data = result[:data]

      bss.push(*data[:list])

      puts "第#{bss_page}页，#{data[:list].length}条数据"

      bss_total = data[:total][:num]

      bss_page = bss_page + 1

      sleep(0.1.seconds)
    end while bss.length < bss_total

    puts "总共#{bss.length}条数据"

    bs_url = 'http://api.clzx.net/public/html/store/storeDetail'
    bs_details = []

    bss.each_with_index do |bs, index|
      puts "正在获取详情 #{index} - #{bs[:name]}"

      form_data = {
        id: bs[:id],
        access_token: access_token,
      }

      response = HTTP.post(bs_url, form: form_data)

      next unless response.status.success?

      result = JSON.parse(response.body.to_s).with_indifferent_access

      next unless result[:success]

      bs_details.push(result[:data])

      sleep(0.1.seconds)
    end

    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(:name => "供应商") do |sheet|
        sheet.add_row [
          'id',
          'pid',
          'user_id',
          'prov_id',
          'mold_id',
          'mold_ids',
          'years',
          'type',
          'is_pay',
          'name',
          'logo_picture_id',
          'status',
          'level',
          'address',
          'contact',
          'phone',
          'content',
          'is_recommend',
          'shop_type',
          'url_address',
          'likenums',
          'browsenums',
          'collectnums',
          'end_time',
          'ctime',
          'frequency',
          'surplus_num',
          'banner_ids',
          'sign_time',
          'phone_look_num',
          'pass_time',
          'file_id',
          'is_trial',
          'keyword',
          'exposures_num',
          'tags',
          'uptime',
          'is_open',
          'integral',
          'updata_time',
          'xy_id',
          'login_num',
          'past_video_url',
          'qualifications_picture_id',
          'mapping_share',
          'logo_picture_url',
          'mold_name',
          'highQualityStar',
          'beContactedStar',
          'qualifications_url',
          'is_xy_store',
          'file_url',
          'provArr',
          'distributorList',
          'is_follow',
          'can_follow',
          'user_avatar',
          'nickname',
        ]
        bs_details.each do |bs_detail|
          row = [
            bs_detail[:id].to_s,
            bs_detail[:pid].to_s,
            bs_detail[:user_id].to_s,
            bs_detail[:prov_id].to_s,
            bs_detail[:mold_id].to_s,
            bs_detail[:mold_ids].to_s,
            bs_detail[:years].to_s,
            bs_detail[:type].to_s,
            bs_detail[:is_pay].to_s,
            bs_detail[:name].to_s,
            bs_detail[:logo_picture_id].to_s,
            bs_detail[:status].to_s,
            bs_detail[:level].to_s,
            bs_detail[:address].to_s,
            bs_detail[:contact].to_s,
            bs_detail[:phone].to_s,
            bs_detail[:content].to_s,
            bs_detail[:is_recommend].to_s,
            bs_detail[:shop_type].to_s,
            bs_detail[:url_address].to_s,
            bs_detail[:likenums].to_s,
            bs_detail[:browsenums].to_s,
            bs_detail[:collectnums].to_s,
            bs_detail[:end_time].to_s,
            bs_detail[:ctime].to_s,
            bs_detail[:frequency].to_s,
            bs_detail[:surplus_num].to_s,
            bs_detail[:banner_ids].to_s,
            bs_detail[:sign_time].to_s,
            bs_detail[:phone_look_num].to_s,
            bs_detail[:pass_time].to_s,
            bs_detail[:file_id].to_s,
            bs_detail[:is_trial].to_s,
            bs_detail[:keyword].to_s,
            bs_detail[:exposures_num].to_s,
            bs_detail[:tags].to_s,
            bs_detail[:uptime].to_s,
            bs_detail[:is_open].to_s,
            bs_detail[:integral].to_s,
            bs_detail[:updata_time].to_s,
            bs_detail[:xy_id].to_s,
            bs_detail[:login_num].to_s,
            bs_detail[:past_video_url].to_s,
            bs_detail[:qualifications_picture_id].to_s,
            bs_detail[:mapping_share].to_s,
            bs_detail[:logo_picture_url].to_s,
            bs_detail[:mold_name].to_s,
            bs_detail[:highQualityStar].to_s,
            bs_detail[:beContactedStar].to_s,
            bs_detail[:qualifications_url].to_s,
            bs_detail[:is_xy_store].to_s,
            bs_detail[:file_url].to_s,
            bs_detail[:provArr].to_s,
            bs_detail[:distributorList].to_s,
            bs_detail[:is_follow].to_s,
            bs_detail[:can_follow].to_s,
            bs_detail[:user_avatar].to_s,
            bs_detail[:nickname].to_s,
          ]
          sheet.add_row(row, types: row.map { :string })
        end
      end
      p.serialize(rootDir.join('供应商列表.xlsx'))
    end

    products_url = 'http://api.clzx.net/public/html/store/storeProduct'
    product_url = 'http://api.clzx.net/public/html/product/productDetail'

    # 获取产品信息
    bss.each_with_index do |bs, index|
      puts "正在获取产品列表 #{index} - #{bs[:name]}"

      products = []
      page = 1
      page_size = 30
      total = 0

      begin
        form_data = {
          id: bs[:id],
          page: page,
          page_size: page_size,
          access_token: access_token,
        }

        response = HTTP.post(products_url, form: form_data)

        raise Errors::UnprocessableEntity.new('访问材料在线服务器失败') unless response.status.success?

        result = JSON.parse(response.body.to_s).with_indifferent_access

        raise Errors::UnprocessableEntity.new('获取结果失败') unless result[:success]

        data = result[:data]

        products.push(*data[:list])

        puts "第#{page}页，#{data[:list].length}条数据"

        total = data[:total][:num]

        page = page + 1
      end while products.length < total

      puts "共#{products.length}个产品"

      sleep(0.1.seconds)

      product_details = []

      products.each_with_index do |product, index|
        puts "正在获取产品详情 #{index}: #{product[:name]}"

        form_data = {
          id: product[:id],
          access_token: access_token,
        }

        response = HTTP.post(product_url, form: form_data)

        next unless response.status.success?

        result = JSON.parse(response.body.to_s).with_indifferent_access

        next unless result[:success]

        product_details.push(result[:data])

        sleep(0.1.seconds)
      end

      Axlsx::Package.new do |p|
        p.workbook.add_worksheet(:name => "产品列表") do |sheet|
          sheet.add_row [
            'id',
            'name',
            'mold_ids',
            'picture_ids',
            'content',
            'store_id',
            'place',
            'model',
            'absorption',
            'size',
            'brand',
            'style',
            'min_price',
            'max_price',
            'browsenums',
            'ctime',
            'mold_name',
            'effect_tags',
            'is_commonly',
            'is_customized',
            'customized_desc',
            'install_pivot',
            'su_desc',
            'color_system',
            'color_num',
            'install_desc',
            'mold_id',
            'is_collection',
          ]
          product_details.each do |detail|
            row = [
              detail[:id].to_s,
              detail[:name].to_s,
              detail[:mold_ids].to_s,
              detail[:picture_ids].to_s,
              detail[:content].to_s,
              detail[:store_id].to_s,
              detail[:place].to_s,
              detail[:model].to_s,
              detail[:absorption].to_s,
              detail[:size].to_s,
              detail[:brand].to_s,
              detail[:style].to_s,
              detail[:min_price].to_s,
              detail[:max_price].to_s,
              detail[:browsenums].to_s,
              detail[:ctime].to_s,
              detail[:mold_name].to_s,
              detail[:effect_tags].to_s,
              detail[:is_commonly].to_s,
              detail[:is_customized].to_s,
              detail[:customized_desc].to_s,
              detail[:install_pivot].to_s,
              detail[:su_desc].to_s,
              detail[:color_system].to_s,
              detail[:color_num].to_s,
              detail[:install_desc].to_s,
              detail[:mold_id].to_s,
              detail[:is_collection].to_s,
            ]
            sheet.add_row(row, types: row.map { :string })
          end
        end
        p.serialize(rootDir.join("#{bs[:id]}_#{bs[:name]}.xlsx"))
      end
    end
  end
end
