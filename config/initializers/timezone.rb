Timezone::Lookup.config(:google) do |c|
   c.api_key = Rails.application.secrets.google_maps_api_key
   # c.client_id = Rails.application.secrets.oauth_client_id # if using 'Google for Work'
 end