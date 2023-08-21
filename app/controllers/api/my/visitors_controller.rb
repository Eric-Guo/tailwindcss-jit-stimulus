# frozen_string_literal: true

module Api
  module My
    class VisitorsController < ApplicationController
      before_action :authenticate_user!

      before_action do
        unless Visitor.user_auth?(current_user)
          render status: 403, json: {
            message: '无权限'
          }
        end
      end

      def index
        @list = Visitor.where(user_id: current_user.id).order(created_at: :desc)

        @total = @list.count

        page, page_size = pagination_params
        @list = @list.page(page).per(page_size)
      end

      def show
        @visitor = Visitor.where(user_id: current_user.id).find(params[:id])
      end

      def create
        expired_at = params[:expired_at].presence&.strip
        remark = params[:remark]

        raise StandardError.new('结束时间不能为空') if expired_at.blank?
        raise StandardError.new('结束时间格式不正确') unless expired_at =~ /^\d{4}[^\d]((0[1-9])|(1[0-2]))[^\d]((0[1-9])|([1-2][0-9])|(3[0-1]))$/

        ThtriApi.create_visitor({
          expiredAt: "#{expired_at} 23:59:59 +0800".to_datetime.iso8601,
          remark: remark,
        }, { 'Cookie': request.headers['HTTP_COOKIE'] })

        render json: { message: '创建成功' }
      end

      def update
        expired_at = params[:expired_at].presence&.strip
        remark = params[:remark]

        args = {
          visitor_id: params[:id],
          remark: remark
        }

        args[:enabled] = true if params.has_key?(:lengthen)

        if args[:enabled]
          raise StandardError.new('结束时间格式不正确') unless expired_at =~ /^\d{4}[^\d]((0[1-9])|(1[0-2]))[^\d]((0[1-9])|([1-2][0-9])|(3[0-1]))$/
          args[:expiredAt] = "#{expired_at} 23:59:59 +0800".to_datetime.iso8601
        end

        ThtriApi.update_visitor(args, { 'Cookie': request.headers['HTTP_COOKIE'] })

        render json: { message: '更新成功' }
      end

      def disable
        ThtriApi.update_visitor({
          visitor_id: params[:id],
          enabled: false,
        }, { 'Cookie': request.headers['HTTP_COOKIE'] })

        render json: { message: '更新成功' }
      end
    end
  end
end
