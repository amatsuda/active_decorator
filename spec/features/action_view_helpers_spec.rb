feature 'fallback to helpers' do
  background do
    aamine = Author.create! :name => 'aamine'
    @rhg = aamine.books.create! :title => 'RHG'
    @rhg_novel = aamine.books.create! :title => 'RHG Novel', :type => 'Novel'
  end

  scenario 'invoking action_view helper methods' do
    visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}"
    within 'a.title' do
      page.should have_content 'RHG'
    end
    page.should have_css('img')
  end

  scenario 'invoking action_view helper methods on model subclass' do
    visit "/authors/#{@rhg_novel.author.id}/books/#{@rhg_novel.id}"
    within 'a.title' do
      page.should have_content 'RHG Novel'
    end
    page.should have_css('img')
  end

  scenario 'invoking action_view helper methods in rescue_from view' do
    visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}/error"
    page.should have_content('ERROR')
  end

  scenario 'make sure that action_view + action_mailer works' do
    visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}"
    click_link 'purchase'
    page.should have_content 'done'
  end
end
