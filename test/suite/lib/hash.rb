#!/usr/bin/ruby
# Jonathan D. Stott <jonathan.stott@gmail.com>
require 'hash'
BareTest.suite "DefinedHash" do
  setup do
    class ::Person < DefinedHash
      property :name, String
      property :page, String
    end
  end

  teardown do
    Object.send(:remove_const, :Person)
  end

  suite ".properties" do
    assert "properties list is correct" do
      equal(Person.properties, {:name => String, :page => String})
    end
  end

  suite ".new", :provides => :new do
    assert "Basic .new works" do
      Person.new
    end

    assert ".new with properties works" do
      Person.new(:name => 'foo')
    end

    assert ".new with invalid properties works" do
      Person.new(:name => 'foo', :num => 1)
    end
  end

  suite "A DefinedHash", :depends_on => :new do
    setup do
      @person         = Person.new(:name => 'Bob', 'page' => 'bob', :num => 1)
    end

    assert "has valid properties set" do
      @person[:name] == 'Bob'
    end

    assert "has strings set" do
      @person[:page] == 'bob'
    end

    assert "Doesn't have non-valid keys set" do
      @person.has_key?(:num) == false
    end
  end

  suite "Array properties", :depends_on => :new do
    setup do
      class ::Person
        property :numbers, [String]
        property :emails,   [{:name => String}]
      end
    end

    assert "An array property is assigned as an array" do
      @person = Person.new(:numbers => %w{5551234})
      equal_unordered(%w{5551234}, @person[:numbers])
    end

    assert "A non-array property is assigned as an array" do
      @person = Person.new(:numbers => "5551234")
      equal_unordered(%w{5551234}, @person[:numbers])
    end

    assert "A hash in array is added properly" do
      @person = Person.new(:emails => { 'name' => 'gmail', :foo => 'bar'})
      equal_unordered([{:name => 'gmail'}], @person[:emails])
    end
    assert "A hash in array is added properly" do
      @person = Person.new(:emails => [{ 'name' => 'gmail', :foo => 'bar'}])
      equal_unordered([{:name => 'gmail'}], @person[:emails])
    end
  end



  suite "Testing validity", :depends_on => :new do
    setup do
      class ::Person
        property :nick, String, :optional => true
      end
    end

    suite "invalid" do
      setup :invalid_person, [
          {:name => 'name'},
          {:page => 'page'},
          { :name => 'name', :page => 1 },
          { :name => 1, :page => 'page' },
          {:name => 'name', :page => 'page', :nick => 2 }
        ] do |invalid_person|
        @person = Person.new(invalid_person)
      end

      assert ":invalid_person is invalid" do
        @person.valid? == false
      end
    end

    suite "valid" do
      setup :valid_person, [
        {:name => 'name', :page => 'page'},
        {:name => 'name', :page => 'page', :nick => 'namz' }
      ] do |valid_person|
        @person = Person.new(valid_person)
      end

      assert ":valid_person is valid" do
        @person.valid? == true
      end
    end
  end
end
