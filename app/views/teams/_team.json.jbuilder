json.extract! team, :id, :company_id, :name, :manager_id, :active, :created_at, :updated_at
json.url team_url(team, format: :json)
