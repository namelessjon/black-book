#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
class Edit < Person
  def action
    page ? "/#{page}" : '/'
  end

  def new?
    !!@person['_id']
  end

  def new_or_edit
    new? ? 'Editing' : 'New'
  end

  def button_text
    new? ? "Update" : "Create"
  end

  def title
    new? ? "Editing #{super}" : "New#{super}"
  end
end
