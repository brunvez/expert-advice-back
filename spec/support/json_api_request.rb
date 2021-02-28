module JsonApiRequest
  def jsonapi_request_headers
    content_type = 'application/vnd.api+json'
    {
      'ACCEPT': content_type,
      'CONTENT_TYPE': content_type
    }
  end

  def json_api_auth_headers(user: nil)
    user = user || User.create!(email: 'email@example.com', password: 'password123')
    account = user.accounts.build
    account_user = AccountUser.new(user: user, account: account)
    application = Doorkeeper::Application.create!(name: 'json_api_test', redirect_uri: 'https://example.test/')
    token = Doorkeeper::AccessToken.create!(application: application, resource_owner_id: user.id)

    { 'Authorization': "Bearer #{token.token}" }
  end

  def json
    JSON.parse(response.body).with_indifferent_access
  end
end
