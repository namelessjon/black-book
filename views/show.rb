#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
class Show < Person
  def addresses
    if addresses = super
      addresses.map! { |a| a['lines'] = a['address'].split(/\r?\n/).map! { |l| { :line => l } }; a }
      addresses
    else
      addresses
    end
  end
end
