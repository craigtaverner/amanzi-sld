#!/usr/bin/env ruby

# This script uses the amanzi-sld DSL to create a sample SLD file
# containing a few examples. The examples are done in a few different
# ways to demonstrate the SLD syntax.

require 'amanzi/sld'

Amanzi::SLD::Config.config[:geometry_property] = 'the_geom'
#Amanzi::SLD::Config.config[:verbose] = true

sld = Amanzi::SLD::Document.new "Example"

# Create XML using the underlying pure-XML DSL from Amanzi::XML
sld.comment "Pure-XML DSL"
sld.feature_type_style.rule.line_symbolizer.stroke do |stroke|
  stroke.css_parameter(:name => "stroke") << '#dddddd'
  stroke.css_parameter(:name => "stroke-width") << '1'
end

# Now create some SLD XML using the higher level SLD-specific syntax

# First a simple example, a LineSymbolizer with no filter
sld.comment "Simple Line DSL"
sld.add_line_symbolizer(:stroke_width => 2, :stroke => '#dddddd')

# Now try one with a filter, but specified using XML DSL
sld.comment "Line with Filter, using XML DSL"
sld.feature_type_style.rule do |rule|
  rule.filter.ns(:ogc).property_is_equal_to do |f|
    f.function(:name => 'geometryType').property_name << 'the_geom'
    f.literal << 'Polygon'
  end
  rule.polygon_symbolizer do |s|
    s.fill do |f|
      f.css_parameter(:name=>"fill") << '#aaaaaa'
      f.css_parameter(:name=>"fill-opacity") << '0.4'
    end
    s.stroke.css_parameter(:name => "stroke") << '#ffe0e0'
  end
end

# And now see how simple these can be with the SLD syntax
sld.comment "Line with Filter, using SLD DSL"
sld.add_line_symbolizer(:stroke_width => 2, :stroke => '#dddddd') do |f|
  f.geometry = 'LineString'
end
sld.comment "Polygon with Filter, using SLD DSL"
sld.add_polygon_symbolizer(:stroke_width => 2, :stroke => '#dddddd', :fill => '#aaaaaa', :fill_opacity => 0.4) do |f|
  f.geometry = 'Polygon'
end
sld.comment "Polygon with Filter, using SLD DSL, and more compact polygon filtering syntax"
sld.add_polygon_symbolizer(:stroke_width => 2, :stroke => '#dddddd', :fill => '#aaaaaa', :fill_opacity => 0.4, :geometry => 'Polygon')

# Using SLD syntax for Filtering makes it simler to do really complex things
sld.comment "Polygon with complex Filter"
sld.add_polygon_symbolizer(:stroke_width => 2, :stroke => '#dddddd', :fill => '#aaaaaa', :fill_opacity => 0.4) do |f|
  f.op(:and) do |f|
    f.geometry = 'Polygon'
    f.op(:or) do |f|
      f.property.not_exists? :highway
      f.property.exists? :waterway
      f.property[:natural] = 'water'
    end
  end
end

# Combining the compact geometry option with other filter settings
sld.comment "Polygon with combined simple and complex Filter"
sld.add_polygon_symbolizer(:stroke_width => 2, :stroke => '#dddddd', :fill => '#aaaaaa', :fill_opacity => 0.4, :geometry => 'Polygon') do |f|
  f.op(:or) do |f|
    f.property.not_exists? :highway
    f.property.exists? :waterway
    f.property[:natural] = 'water'
  end
end

# Adding a set of symbolizers within the same rules filter
sld.comment "Multiple symbolizers and complex filter"
sld.
  add_line_symbolizer(:stroke_width => 7, :stroke => '#303030').
  add_line_symbolizer(:stroke_width => 5, :stroke => '#e0e0ff') do |f|
  f.op(:and) do |f|
    f.property.exists? :highway
    f.op(:or) do |f|
      f.property[:highway] = 'secondary'
      f.property[:highway] = 'tertiary'
    end
  end
end

puts sld.to_xml(:tab => '    ')

#HTML::Document.test

