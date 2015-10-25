feature 'decorating partial object in Jbuilder' do
  background do
    Author.create! :name => 'aamine'
    nari = Author.create! :name => 'nari'
    nari.books.create! :title => 'the gc book'
  end

  scenario 'decorating objects in Jbuilder partials' do
    visit "/authors/#{Author.last.id}.json"
    expect(page.source).to eq '{"name":"nari","books":[{"title":"the gc book","reverse_title":"koob cg eht"}]}'
  end
end
