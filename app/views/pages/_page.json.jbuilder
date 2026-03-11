json.extract! page, :id, :lesson_id, :title, :content, :position, :created_at, :updated_at
json.url page_url(page, format: :json)
