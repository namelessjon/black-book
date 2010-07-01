#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
module BlackBook
  module Views
    class Layout < ::Mustache
      self.template_extension = 'html'

      def title
        BlackBook::App.name
      end
    end
  end
end
