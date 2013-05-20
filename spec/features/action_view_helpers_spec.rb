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

  scenario 'When invoked respond_to? in decorator, delegate to view_context' do
    visit "/authors/#{@rhg.author.id}"
    page.should have_content('true')
  end
end
