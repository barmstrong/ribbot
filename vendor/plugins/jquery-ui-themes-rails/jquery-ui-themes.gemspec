$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "jquery-ui-themes/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "jquery-ui-themes"
  s.version     = JqueryUiThemes::VERSION
  s.authors     = ["Mark Asson"]
  s.email       = ["mark@fatdude.net"]
  s.homepage    = "https://github.com/fatdude/jquery-ui-themes-rails"
  s.summary     = "Simple integration of jquery themes into the asset pipeline"
  s.description = "Allow inclusion of the pre built jquery themes in the asset pipeline without having to edit the files each time."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.markdown"]
  s.test_files = Dir["test/**/*"]
end
