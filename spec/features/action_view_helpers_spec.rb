require 'spec_helper'

feature 'fallback to helpers' do
  background do
    aamine = Author.create! :name => 'aamine'
    @rhg = aamine.books.create! :title => 'RHG'
  end

  scenario 'invoking action_view helper methods' do
    visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}"
    within 'a' do
      page.should have_content 'RHG'
    end
    page.should have_css('img')
  end
end
