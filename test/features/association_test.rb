# frozen_string_literal: true

require 'test_helper'

class AssociationIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    company = Company.create! name: 'NaCl'
    @matz = company.authors.create! name: 'matz'
    @matz.books.create!(
      title: 'the world of code',
      publisher_attributes: { name: 'nikkei linux' }
    )
    @matz.books.create!(
      title: 'the ruby programming language',
      publisher_attributes: { name: "o'reilly" }
    )
    @matz.create_profile! address: 'Matsue city, Shimane'
    @matz.profile.create_profile_history! updated_on: Date.new(2017, 2, 7)
    @matz.magazines.create! title: 'rubima'
  end

  test 'decorating associated objects' do
    visit "/authors/#{@matz.id}"
    assert page.has_content? 'the world of code'.upcase
    assert page.has_content? 'the ruby programming language'.upcase
    assert page.has_content? 'nikkei linux'.upcase
    if Rails.version.to_f >= 5.1
      assert page.has_content? 'nikkei linux'.reverse
    end
    assert page.has_content? 'secret'
    assert page.has_content? '2017/02/07'
    assert page.has_content? 'rubima'.upcase
    assert page.has_content? 'NaCl'.reverse
  end

  test "decorating associated objects that owner doesn't have decorator" do
    movie = Movie.create! author: @matz
    visit "/movies/#{movie.id}"
    assert page.has_content? 'matz'.reverse
  end
end
