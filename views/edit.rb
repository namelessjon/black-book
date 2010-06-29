#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
class Edit < Layout
  def action
    page ? "/#{page}" : '/'
  end

  def button_text
    page ? "Update" : "Create"
  end

  def title
    page ? "Editing #{name} - #{super}" : "New - #{super}"
  end

  def name
    @person['name']
  end

  def page
    @person['page']
  end

  def emails
    @person['emails']
  end

  def addresses
    @person['addresses']
  end

  def numbers
     @person['numbers']
  end
end
