require 'spec_helper'

feature 'fallback to helpers' do
  background do
    aamine = Author.create! :name => 'aamine'
    @rhg = aamine.books.create! :title => 'RHG'
    @rhg_novel = aamine.books.create! :title => 'RHG Novel', :type => 'Novel'
  end

  scenario 'invoking action_view helper methods' do
    visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}"
    within 'a' do
      page.should have_content 'RHG'
    end
    page.should have_css('img')
  end

  scenario 'invoking action_view helper methods on model subclass' do
    visit "/authors/#{@rhg_novel.author.id}/books/#{@rhg_novel.id}"
    within 'a' do
      page.should have_content 'RHG Novel'
    end
    page.should have_css('img')
  end
end
