# frozen_string_literal: true

require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  test 'reveals fakes' do
    movie = Movie.create
    if Rails::VERSION::MAJOR >= 5
      assert_nothing_raised { get :show, params: {id: movie.id} }
    else
      assert_nothing_raised { get :show, id: movie.id }
    end
  end
end
