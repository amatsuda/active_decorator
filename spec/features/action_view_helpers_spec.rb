feature 'fallback to helpers' do
  background do
    aamine = Author.create! name: 'aamine'
    @rhg = aamine.books.create! title: 'RHG'
  end

  scenario 'invoking action_view helper methods' do
    visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}"
    within 'a.title' do
      expect(page).to have_content 'RHG'
    end
    expect(page).to have_css('img')
  end

  scenario 'invoking action_view helper methods in rescue_from view' do
    visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}/error"
    expect(page).to have_content('ERROR')
  end

  scenario 'make sure that action_view + action_mailer works' do
    visit "/authors/#{@rhg.author.id}/books/#{@rhg.id}"
    click_link 'purchase'
    expect(page).to have_content 'done'
  end
end
