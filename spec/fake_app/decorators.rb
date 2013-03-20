# decorators
module AuthorDecorator
  def reverse_name
    name.reverse
  end

  def capitalized_name
    name.capitalize
  end
end
module BookDecorator
  def reverse_title
    title.reverse
  end

  def upcased_title
    title.upcase
  end

  def link
    link_to title, "#{request.protocol}#{request.host_with_port}/assets/sample.png"
  end

  def cover_image
    image_tag 'cover.png'
  end
end
