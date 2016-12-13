# frozen_string_literal: true
require 'test_helper'

class MoviesControllerTest < ActionController::TestCase
  test 'reveals fakes' do
    movie = Movie.create
    assert_nothing_raised { get :show, id: movie.id }
  end
end
