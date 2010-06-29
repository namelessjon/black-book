#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
class Layout < Mustache
  self.template_extension = 'html'
  self.template_path = '../templates'

  def title
    'Addresses!'
  end
end
