require 'spec_helper'

feature 'decorating partial object' do
  background do
    Author.create! :name => 'aamine'
    nari = Author.create! :name => 'nari'
    nari.books.create! :title => 'the gc book'
  end
  after do
    Book.delete_all
    Author.delete_all
  end

  scenario 'decorating implicit @object' do
    visit '/authors'
    page.should have_content 'the gc book'
    page.should have_content 'the gc book'.reverse
  end

  scenario 'decorating implicit @collection' do
    visit '/authors?partial=collection'
    page.should have_content 'the gc book'
    page.should have_content 'the gc book'.reverse
  end

  scenario 'decorating objects in @locals' do
    visit '/authors?partial=locals'
    page.should have_content 'the gc book'
    page.should have_content 'the gc book'.upcase
  end
end
