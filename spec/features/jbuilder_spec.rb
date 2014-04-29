require 'spec_helper'

feature 'decorating partial object in Jbuilder' do
  background do
    Author.create! :name => 'aamine'
    nari = Author.create! :name => 'nari'
    nari.books.create! :title => 'the gc book'
  end
  after do
    Book.delete_all
    Author.delete_all
  end

  scenario 'decorating objects in Jbuilder partials' do
    visit "/authors/#{Author.last.id}.json"
    page.source.should eq '{"name":"nari","books":[{"title":"the gc book","reverse_title":"koob cg eht"}]}'
  end
end
