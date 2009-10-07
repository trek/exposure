# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{exposure}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Trek Glowacki"]
  s.date = %q{2009-10-07}
  s.description = %q{}
  s.email = ["trek.glowacki@gmail.com"]
  s.extra_rdoc_files = ["Manifest.txt"]
  s.files = ["Manifest.txt", "README.mdown", "Rakefile", "exposure.gemspec", "lib/exposure.rb", "lib/exposure/common.rb", "lib/exposure/configuration.rb", "lib/exposure/patterns/resource.rb", "lib/exposure/patterns/resources.rb", "script/console", "script/destroy", "script/generate", "spec/custom_matchers.rb", "spec/exposure_spec.rb", "spec/factories/pirate_factory.rb", "spec/factories/ship_factory.rb", "spec/finders/finder_spec.rb", "spec/finders/nested_resources_finder_spec.rb", "spec/fixtures/pirates/edit.erb", "spec/fixtures/pirates/index.erb", "spec/fixtures/pirates/new.erb", "spec/fixtures/pirates/show.erb", "spec/fixtures/ships/edit.erb", "spec/fixtures/ships/index.erb", "spec/fixtures/ships/new.erb", "spec/fixtures/ships/show.erb", "spec/flashers/flash_with_block_spec.rb", "spec/flashers/flash_with_method_spec.rb", "spec/flashers/flash_with_proc_spec.rb", "spec/flashers/flash_with_string_spec.rb", "spec/resource_spec.rb", "spec/resources_spec.rb", "spec/responders/respond_to_mime_types_spec.rb", "spec/responders/respond_with_block_spec.rb", "spec/responders/respond_with_method_spec.rb", "spec/responders/respond_with_proc_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "spec/spec_rails_helper.rb", "tasks/rspec.rake", "tasks/shoulda.rake"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{exposure}
  s.rubygems_version = %q{1.3.4}
  s.summary = nil

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<hoe>, [">= 2.3.3"])
    else
      s.add_dependency(%q<hoe>, [">= 2.3.3"])
    end
  else
    s.add_dependency(%q<hoe>, [">= 2.3.3"])
  end
end
