#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
class Person < Layout
  def title
    "#{name} - Addresses"
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
