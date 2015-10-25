feature 'decorating partial object' do
  background do
    Author.create! name: 'aamine'
    nari = Author.create! name: 'nari'
    nari.books.create! title: 'the gc book'
  end

  scenario 'decorating implicit @object' do
    visit '/authors'
    expect(page).to have_content 'the gc book'
    expect(page).to have_content 'the gc book'.reverse
  end

  scenario 'decorating implicit @collection' do
    visit '/authors?partial=collection'
    expect(page).to have_content 'the gc book'
    expect(page).to have_content 'the gc book'.reverse
  end

  scenario 'decorating objects in @locals' do
    visit '/authors?partial=locals'
    expect(page).to have_content 'the gc book'
    expect(page).to have_content 'the gc book'.upcase
  end
end
