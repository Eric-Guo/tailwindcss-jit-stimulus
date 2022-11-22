
status, status_title = case manufacturer.status
when 'manufacturer_recommend_reviewing'
  [0, '未审核']
when 'manufacturer_recommend_approved'
  [1, '审核通过']
when 'manufacturer_recommend_rejected'
  [2, '审核未通过']
end

json.status status
json.status_title status_title
