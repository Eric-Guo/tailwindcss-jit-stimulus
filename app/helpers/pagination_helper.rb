# frozen_string_literal: true

module PaginationHelper
  def pagination(page = 1, page_size = 10, total = 0, show_pages = 5)
    page_total = (total.to_f/page_size).ceil
    min_page_range = page
    max_page_range = page
    left_show_pages = ((show_pages - 1).to_f / 2).ceil
    right_show_pages = show_pages - left_show_pages - 1
    if page + right_show_pages > page_total
      left_show_pages += (page + right_show_pages - page_total)
    end
    while left_show_pages > 0 do
      min_page_range -= 1
      if min_page_range <= 1
        min_page_range = 1
        right_show_pages += left_show_pages
        left_show_pages = 0
      else
        left_show_pages -= 1
      end
    end
    while right_show_pages > 0 do
      max_page_range += 1
      if max_page_range >= page_total
        max_page_range = page_total
        right_show_pages = 0
      else
        right_show_pages -= 1
      end
    end
    {
      page_total: page_total,
      range: min_page_range..max_page_range,
      first_page: min_page_range > 1 && 1,
      last_page: max_page_range < page_total && page_total,
      backward: page > 1,
      backward_more: min_page_range > 2 && (page - show_pages >= 1 ? page - show_pages : 1),
      forward: page < page_total,
      forward_more: max_page_range < page_total - 1 && (page + show_pages <= page_total ? page + show_pages : page_total ),
    }
  end
end
