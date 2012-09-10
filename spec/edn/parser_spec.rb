require 'spec_helper'

describe EDN::Parser do
  include RantlyHelpers

  let(:parser) { EDN::Parser.new }

  context "value" do
    it "should consume nil" do
      parser.value.should parse("nil")
    end
  end

  context "boolean" do
    it "should consume true" do
      parser.boolean.should parse("true")
    end

    it "should consume false" do
      parser.boolean.should parse("false")
    end
  end

  context "integer" do
    it "should consume integers" do
      rant(:integer).each do |int|
        parser.integer.should parse(int.to_s)
      end
    end
  end

  context "float" do
    it "should consume simple floats" do
      rant(RantlyHelpers::FLOAT).each do |float|
        parser.float.should parse(float.to_s)
      end
    end

    it "should consume floats with exponents" do
      rant(RantlyHelpers::FLOAT_WITH_EXP).each do |float|
        parser.float.should parse(float)
      end
    end
  end

  context "symbol" do
    it "should consume any symbols" do
      rant(RantlyHelpers::SYMBOL).each do |symbol|
        parser.symbol.should parse("#{symbol}")
      end
    end

    context "special cases" do
      it "should consume '/'" do
        parser.symbol.should parse('/')
      end

      it "should consume '.'" do
        parser.symbol.should parse('.')
      end

      it "should consume '-'" do
        parser.symbol.should parse('-')
      end
    end
  end

  context "keyword" do
    it "should consume any keywords" do
      rant(RantlyHelpers::SYMBOL).each do |symbol|
        parser.keyword.should parse(":#{symbol}")
      end
    end
  end

  context "tag" do
    it "should consume any tags" do
      rant(RantlyHelpers::SYMBOL).each do |symbol|
        parser.tag.should parse("##{symbol}")
      end
    end
  end

  context "string" do
    it "should consume any string" do
      rant(RantlyHelpers::STRING).each do |string|
        parser.string.should parse(string)
      end
    end
  end

  context "character" do
    it "should consume any character" do
      rant(RantlyHelpers::CHARACTER).each do |char|
        parser.character.should parse(char)
      end
    end
  end

  context "vector" do
    it "should consume an empty vector" do
      parser.vector.should parse('[]')
      parser.vector.should parse('[  ]')
    end

    it "should consume vectors of mixed elements" do
      rant(RantlyHelpers::VECTOR).each do |vector|
        parser.vector.should parse(vector)
      end
    end
  end

  context "list" do
    it "should consume an empty list" do
      parser.list.should parse('()')
      parser.list.should parse('( )')
    end

    it "should consume lists of mixed elements" do
      rant(RantlyHelpers::LIST).each do |list|
        parser.list.should parse(list)
      end
    end
  end

  context "set" do
    it "should consume an empty set" do
      parser.set.parse_with_debug('#{}')
      parser.set.should parse('#{}')
      parser.set.should parse('#{ }')
    end

    it "should consume sets of mixed elements" do
      rant(RantlyHelpers::SET).each do |set|
        parser.set.should parse(set)
      end
    end
  end

  context "map" do
    it "should consume an empty map" do
      parser.map.should parse('{}')
      parser.map.should parse('{ }')
    end

    it "should consume maps of mixed elements" do
      rant(RantlyHelpers::MAP).each do |map|
        parser.map.should parse(map)
      end
    end
  end

  context "tagged value" do
    it "should consume tagged values" do
      rant(RantlyHelpers::TAGGED_VALUE).each do |value|
        parser.tagged_value.should parse(value)
      end
    end
  end
end