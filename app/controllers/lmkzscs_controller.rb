class LmkzscsController < ApplicationController
  before_action :authenticate_user!

  def download
    case_lmkzsc = CaseLmkzsc.joins(:lmkzsc, :project).find_by!(cases_id: params[:case_id], lmkzsc_id: params[:id])
    lmkzsc = case_lmkzsc.lmkzsc
    # 判断今天的下载次数
    today_download_count = UserDownloadLog
                            .where(type_id: 1)
                            .where('created_at > current_date()')
                            .where(clerk_code: current_user.clerk_code)
                            # .where(case_id: case_lmkzsc.cases_id)
                            .count
    if today_download_count >= current_user.project_file_download_limit
      render plain: "今天下载次数已达上限 #{current_user.project_file_download_limit}"
    else
      url = ThtriApi.generate_download_url(path: lmkzsc.path, fileName: lmkzsc.name, userID: current_user.id)
      UserDownloadLog.create(type_id: 1, clerk_code: current_user.clerk_code, case_id: case_lmkzsc.cases_id, lmkzsc_id: lmkzsc.id)
      redirect_to url, allow_other_host: true
    end
  end
end
