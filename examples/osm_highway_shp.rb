#!/usr/bin/env ruby

# This SLD should work with OSM standard export to SHP format, as provided by CloudMade
# on their downloads pages. In those files the properties are all provided as values
# of the TYPE parameter. I tested this on an extract from Berlin and it handles a range
# of zoom levels.

# In case you are running this from source
$:<< 'lib'
$:<< '../lib'

# In case you have amanzi/sld as a ruby gem
require 'rubygems'
require 'amanzi/sld'

# Define some common filtering rules
major_highways = Proc.new do |f|
  f.op(:or) do |f|
    f.property[:TYPE] = 'primary'
    f.property[:TYPE] = 'motorway'
  end
end

highways = Proc.new do |f|
  f.op(:or) do |f|
    f.property[:TYPE] = 'primary'
    f.property[:TYPE] = 'secondary'
    f.property[:TYPE] = 'motorway'
  end
end

main_roads = Proc.new do |f|
  f.op(:or) do |f|
    f.property[:TYPE] = 'primary'
    f.property[:TYPE] = 'secondary'
    f.property[:TYPE] = 'tertiary'
    f.property[:TYPE] = 'motorway'
    f.property[:TYPE] = 'residential'
  end
end

sld = Amanzi::SLD::Document.new "OSM Highways"

# when zoomed out, draw only main highways
sld.add_line_symbolizer :stroke => '#b0b0b0', :stroke_width => 1, :min_scale => 70000 do |f|
  highways.call f
end
sld.add_line_symbolizer :stroke => '#b0b0b0', :stroke_width => 3, :min_scale => 70000 do |f|
  major_highways.call f
end
sld.add_line_symbolizer :stroke => '#f0f0a0', :stroke_width => 2, :min_scale => 70000 do |f|
  major_highways.call f
end

# moderate zoom, show main roads only
sld.add_line_symbolizer :stroke => '#b0b0b0', :stroke_width => 1, :max_scale => 70000, :min_scale => 35000 do |f|
  main_roads.call f
end
sld.add_line_symbolizer :stroke => '#b0b0b0', :stroke_width => 3, :max_scale => 70000, :min_scale => 35000 do |f|
  highways.call f
end
sld.add_line_symbolizer :stroke => '#f0f0a0', :stroke_width => 2, :max_scale => 70000, :min_scale => 35000 do |f|
  highways.call f
end

# zoomed in more, show all roads with some width and draw main and highways over that
sld.add_line_symbolizer :stroke => '#d0d0d0', :stroke_width => 2, :max_scale => 35000, :min_scale => 15000
sld.add_line_symbolizer :stroke => '#909090', :stroke_width => 3, :max_scale => 35000, :min_scale => 15000 do |f|
  highways.call f
end
sld.add_line_symbolizer :stroke => '#b0b0b0', :stroke_width => 1, :max_scale => 35000, :min_scale => 15000
sld.add_line_symbolizer :stroke => '#b0f0f0', :stroke_width => 1, :max_scale => 35000, :min_scale => 15000 do |f|
  main_roads.call f
end
sld.add_line_symbolizer :stroke => '#f0f0a0', :stroke_width => 2, :max_scale => 35000, :min_scale => 15000 do |f|
  highways.call f
end

# zoomed in the most, show all roads, and highlight main roads and highways
sld.add_line_symbolizer :stroke => '#909090', :stroke_width => 3, :max_scale => 15000
sld.add_line_symbolizer :stroke => '#f0f0f0', :stroke_width => 2, :max_scale => 15000
sld.add_line_symbolizer :stroke => '#909090', :stroke_width => 5, :max_scale => 15000 do |f|
  main_roads.call f
end

sld.add_line_symbolizer :stroke => '#909090', :stroke_width => 7, :max_scale => 15000 do |f|
  highways.call f
end

sld.add_line_symbolizer :stroke => '#e0e0e0', :stroke_width => 3, :max_scale => 15000 do |f|
  main_roads.call f
end

sld.add_line_symbolizer :stroke => '#f0f0a0', :stroke_width => 5, :max_scale => 15000 do |f|
  highways.call f
end

#sld.add_text_symbolizer :property => 'name', :font_size => 18, :halo => 2, :max_scale => 15000 do |f|
#  highways.call f
#end

puts sld.to_xml :tab => '  '

