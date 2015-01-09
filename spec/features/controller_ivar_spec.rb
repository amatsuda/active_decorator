require 'spec_helper'

feature 'decorating controller ivar' do
  background do
    @matz = Author.create! :name => 'matz'
    @matz.books.create! :title => 'the world of code'
    Author.create! :name => 'takahashim'
  end

  after do
    Author.delete_all
    Book.delete_all
  end

  scenario 'decorating a model object in ivar' do
    visit "/authors/#{@matz.id}"
    page.should have_content 'matz'
    page.should have_content 'matz'.capitalize
  end

  scenario 'decorating model scope in ivar' do
    visit '/authors'
    page.should have_content 'takahashim'
    page.should have_content 'takahashim'.reverse
  end

  scenario "decorating models' array in ivar" do
    visit '/authors?variable_type=array'
    page.should have_content 'takahashim'
    page.should have_content 'takahashim'.reverse
  end

  scenario 'decorating model association proxy in ivar' do
    visit "/authors/#{@matz.id}/books"
    page.should have_content 'the world of code'
    page.should have_content 'the world of code'.reverse
  end
end
