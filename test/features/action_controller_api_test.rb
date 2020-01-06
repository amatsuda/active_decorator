# frozen_string_literal: true
require 'test_helper'

if Rails::VERSION::MAJOR >= 5

class ActionControllerAPITest < ActionDispatch::IntegrationTest
  setup do
    Bookstore.create! name: 'junkudo'
  end

  test 'decorating objects in api only controllers' do
    get "/api/bookstores/#{Bookstore.last.id}.json"

    assert_equal({"initial" => "j", "name" => "junkudo"}, response.parsed_body)
  end

  test 'error handling in api only controllers' do
    get "/api/bookstores/error.json"

    assert_response :error
  end
end

end
