feature 'decorating controller ivar' do
  background do
    @matz = Author.create! name: 'matz'
    @matz.books.create! title: 'the world of code'
    Author.create! name: 'takahashim'
  end

  scenario 'decorating a model object in ivar' do
    visit "/authors/#{@matz.id}"
    expect(page).to have_content 'matz'
    expect(page).to have_content 'matz'.capitalize
  end

  scenario 'decorating model scope in ivar' do
    visit '/authors'
    expect(page).to have_content 'takahashim'
    expect(page).to have_content 'takahashim'.reverse
  end

  scenario "decorating models' array in ivar" do
    visit '/authors?variable_type=array'
    expect(page).to have_content 'takahashim'
    expect(page).to have_content 'takahashim'.reverse
  end

  scenario "decorating models' proxy object in ivar" do
    visit '/authors?variable_type=proxy'
    expect(page).to have_content 'takahashim'
    expect(page).to have_content 'takahashim'.reverse
  end

  scenario 'decorating model association proxy in ivar' do
    visit "/authors/#{@matz.id}/books"
    expect(page).to have_content 'the world of code'
    expect(page).to have_content 'the world of code'.reverse
  end
end
