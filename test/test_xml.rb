require 'helper'

class TestXML < Test::Unit::TestCase
  context "An XML document" do
    setup do
      @doc = Amanzi::XML::Document.new 'Test'
    end
    should "contain an XML header" do
      assert @doc.to_s =~ /^\<\?xml/
    end
    context "with some tags" do
      setup do
        @doc.data.body do |body|
          body.head << "Header"
          body.content << "Some text"
        end
      end
      should "have only one body" do
        #puts "Have XML document: #{@doc}"
        body_tags = @doc.to_s.split(/[\r\n]+/).grep(/\<body/i)
        assert_equal 1, body_tags.length
      end
      should "have an data->body with two child tags" do
        assert_equal 'data', (data = @doc.children[0]).name.downcase
        assert_equal 'body', (body = data.children[0]).name.downcase
        assert_equal 2, body.children.length
      end
    end
  end

  context "An HTML document" do
    setup do
      @doc = Amanzi::HTML::Document.new 'Test HTML Document'
    end
    should "contain an XML header" do
      assert @doc.to_s =~ /^\<\?xml/
    end
    context "with some tags" do
      setup do
        @doc.body.h1 << "Header"
        @doc.body.p << "Some text"
        @doc.body.p << "Some more text"
        @doc.body.table do |t|
          t.tr do |tr|
            tr.td << 'a'
            tr.td << 'b'
          end
          t.tr do |tr|
            tr.td << '1'
            tr.td << '2'
          end
        end
      end
      should "have only one body" do
        #puts "Have HTML document: #{@doc}"
        body_tags = @doc.to_s.split(/[\r\n]+/).grep(/\<body/i)
        assert_equal 1, body_tags.length
      end
      should "have four table cell tags" do
        assert_equal 4, @doc.to_s.split(/[\r\n]+/).grep(/\<td/i).length
        assert_equal 4, @doc.to_s.split(/[\r\n]+/).grep(/\<\/td/i).length
      end
      should "have an html->body with four child tags" do
        assert_equal 'head', (head = @doc.children[0]).name.downcase
        assert_equal 'body', (body = @doc.children[1]).name.downcase
        assert_equal 4, body.children.length
      end
    end
  end
end
