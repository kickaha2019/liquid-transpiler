# frozen_string_literal: true

require_relative "lib/liquid_transpiler/version"

Gem::Specification.new do |spec|
  spec.name     = "liquid_transpiler"
  spec.version  = LiquidTranspiler::VERSION
  spec.platform = Gem::Platform::RUBY
  spec.authors  = ["Peter Rootham-Smith"]
  spec.email    = ["peter3111@alofmethbin.com"]
  spec.summary  = "Convert Liquid template files to Ruby code"
  spec.homepage = "https://github.com/kickaha2019/liquid_transpiler"
  spec.license  = "MIT"

  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kickaha2019/liquid_transpiler"
  spec.metadata["changelog_uri"] = "https://github.com/kickaha2019/liquid_transpiler/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob("{lib}/**/*") +
      Dir.glob("test/examples/*.rb") +
      Dir.glob("*.md")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "liquid", "~> 5.5.0"
  spec.add_development_dependency "minitest", "~> 5.20.0"

  spec.add_dependency "tzinfo", "~> 2.0.6"
  spec.add_dependency "tzinfo-data", "~> 1.2024.1"
end
