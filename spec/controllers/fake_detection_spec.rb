require 'spec_helper'

describe MoviesController do
  let(:movie){ Movie.create }

  it 'reveals fakes' do
    expect{ get :show, :id => movie.id }.not_to raise_error(TypeError)
  end
end
