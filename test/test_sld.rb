require 'helper'

class TestXML < Test::Unit::TestCase
  context "An SLD document" do
    setup do
      @doc = Amanzi::SLD::Document.new 'Test SLD Document'
    end
    should "contain an XML header" do
      #puts "Have SLD document: #{@doc}"
      assert @doc.to_s =~ /^\<\?xml/
    end
    should "have a StyledLayerDescriptor->NamedLayer->UserStyle->Name tree" do
      assert_equal @doc.name, 'StyledLayerDescriptor'
      assert_equal (layer = @doc.children[0]).name, 'NamedLayer'
      assert_equal layer.children[0].name, 'Name'
      assert_equal (style = layer.children[1]).name, 'UserStyle'
      assert_equal style.children[0].name, 'Name'
      assert_equal 2, layer.children.length
    end

    context "with some line styles" do
      setup do
        @doc.comment "Add a simple line style"
        @doc.add_line_symbolizer :stroke_width => 5
        @doc.comment "Add a more complex line style with filter"
        @doc.add_line_symbolizer :stroke_width => 5, :stroke => '#2080a0' do |f|
          f.geometry = 'LineString'
        end
      end
      should "have two LineSymbolizers" do
        #puts "Have SLD document: #{@doc}"
        tags = @doc.to_s.split(/[\r\n]+/).grep(/\<LineSymbolizer/i)
        assert_equal 2, tags.length
      end
      should "have a geometry type function call" do
        tags = @doc.to_s.split(/[\r\n]+/).grep(/\<ogc\:Function/i)
        assert_equal 1, tags.length
        assert /geometryType/.match tags[0]
      end
    end

    context "with polygon style and complex filter" do
      setup do
        @doc.comment "Polygon with complex Filter"
        @doc.add_polygon_symbolizer(:stroke_width => 2, :stroke => '#dddddd', :fill => '#aaaaaa', :fill_opacity => 0.4) do |f|
          f.op(:and) do |f|
            f.geometry = 'Polygon'
            f.op(:or) do |f|
              f.property.not_exists? :highway
              f.property.exists? :waterway
              f.property[:natural] = 'water'
            end
          end
        end
      end
      should "have one PolygonSymbolizers" do
        #puts "Have SLD document: #{@doc}"
        assert_equal 1, @doc.to_s.split(/[\r\n]+/).grep(/\<PolygonSymbolizer/i).length
        assert_equal 1, @doc.to_s.split(/[\r\n]+/).grep(/\<\/PolygonSymbolizer/i).length
      end
      should "have a geometry type function call" do
        tags = @doc.to_s.split(/[\r\n]+/).grep(/\<ogc\:Function/i)
        assert_equal 1, tags.length
        assert /geometryType/.match tags[0]
      end
    end

    context "with multiple symbolizers using the same filter rules" do
      setup do
        @doc.comment "Multiple symbolizers and complex filter"
        @doc.
          add_line_symbolizer(:stroke_width => 7, :stroke => '#303030').
          add_line_symbolizer(:stroke_width => 5, :stroke => '#e0e0ff') do |f|
          f.op(:and) do |f|
            f.geometry = 'LineString'
            f.property.exists? :highway
            f.op(:or) do |f|
              f.property[:highway] = 'secondary'
              f.property[:highway] = 'tertiary'
            end
          end
        end
      end
      should "have two LineSymbolizers" do
        #puts "Have SLD document: #{@doc}"
        assert_equal 2, @doc.to_s.split(/[\r\n]+/).grep(/\<LineSymbolizer/i).length
        assert_equal 2, @doc.to_s.split(/[\r\n]+/).grep(/\<\/LineSymbolizer/i).length
      end
      should "have a geometry type function call" do
        tags = @doc.to_s.split(/[\r\n]+/).grep(/\<ogc\:Function/i)
        assert_equal 1, tags.length
        assert /geometryType/.match tags[0]
      end
      should "have four CssParameter tags" do
        assert_equal 4, @doc.to_s.split(/[\r\n]+/).grep(/\<CssParameter/i).length
        assert_equal 4, @doc.to_s.split(/[\r\n]+/).grep(/\<\/CssParameter/i).length
      end
      should "have an rule->filter->and tree with three children" do
        assert_equal 'StyledLayerDescriptor', @doc.name
        assert_equal 'NamedLayer', (layer = @doc.children[0]).name
        assert_equal 'UserStyle', (style = layer.children[1]).name
        assert_equal 3, style.children.length
        assert_equal 'FeatureTypeStyle', (fstyle = style.children[2]).name
        assert_equal 'Rule', (rule = fstyle.children[0]).name
        assert_equal 3, rule.children.length
        assert_equal 'Filter', (filter = rule.children[0]).name
        assert_equal 1, filter.children.length
        assert_equal 'And', (andtag = filter.children[0]).name
        assert_equal 3, andtag.children.length
        assert_equal 'PropertyIsEqualTo', (geom = andtag.children[0]).name
        assert_equal 2, geom.children.length
        assert_equal 'Literal', (gname = geom.children[1]).name
        assert_equal 'LineString', gname.children[0]
        assert_equal 'Or', (props = andtag.children[2]).name
        assert_equal 2, props.children.length
        assert_equal 'PropertyIsEqualTo', (propB = props.children[1]).name
        assert_equal 'PropertyName', propB.children[0].name
        assert_equal 'highway', propB.children[0].contents
        assert_equal 'tertiary', propB.children[1].contents
      end
    end
  end
end
