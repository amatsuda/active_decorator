require 'spec_helper'

describe MoviesController, :type => :controller do
  let(:movie){ Movie.create }

  it 'reveals fakes' do
    expect{ get :show, :id => movie.id }.not_to raise_error
  end
end
