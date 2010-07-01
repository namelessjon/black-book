#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
module BlackBook
  module Views
    class Person < Layout
      def title
        "#{name} - #{super}"
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
  end
end
