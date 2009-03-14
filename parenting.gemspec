# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{parenting}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ari Lerner"]
  s.date = %q{2009-03-14}
  s.description = %q{Being a responsible parent is hard. This lil gem makes it easy!}
  s.email = ["arilerner@mac.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "PostInstall.txt", "README.rdoc", "Rakefile", "lib/parenting.rb", "lib/parenting/base.rb", "script/console", "script/destroy", "script/generate", "test/test_helper.rb", "test/test_parenting.rb"]
  s.has_rdoc = true
  s.homepage = %q{Being a responsible parent is hard. This lil gem makes it easy!}
  s.post_install_message = %q{PostInstall.txt}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{parenting}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Being a responsible parent is hard}
  s.test_files = ["test/test_helper.rb", "test/test_parenting.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
