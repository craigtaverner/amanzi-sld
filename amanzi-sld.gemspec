# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{amanzi-sld}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Craig Taverner"]
  s.date = %q{2010-11-02}
  s.description = %q{Map styles are often defined using SLD, or Style Layer Descriptor documents. These XML documents are very long, verbose and complex to maintain. Amanzi:SLD is a simpler DSL designed to generate SLD documents, but using a very much simpler syntax. Many common cases might be a single line only, while the simplest SLD is usually a dozen lines or more.}
  s.email = %q{craig@amanzi.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/amanzi-sld.rb",
     "test/helper.rb"
  ]
  s.homepage = %q{http://github.com/craigtaverner/amanzi-sld}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A Ruby DSL for simpler SLD creation for styling maps}
  s.test_files = [
    "test/test_file.rb",
     "test/test_xml.rb",
     "test/test_sld.rb",
     "test/helper.rb",
     "examples/osm.rb",
     "examples/test.rb",
     "examples/osm_highway_shp.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_development_dependency(%q<differ>, [">= 0.1"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
      s.add_dependency(%q<differ>, [">= 0.1"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    s.add_dependency(%q<differ>, [">= 0.1"])
  end
end
