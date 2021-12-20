# frozen_string_literal: true

require_relative "lib/mergent/version"

Gem::Specification.new do |spec|
  spec.name = "mergent"
  spec.version = Mergent::VERSION
  spec.author = "Mergent"
  spec.email = "support@mergent.co"

  spec.summary = "Ruby library for the Mergent API."
  spec.description = "Ruby library for the Mergent API. See https://mergent.co for details."
  spec.homepage = "https://mergent.co"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mergentlabs/mergent-ruby"
  spec.metadata["changelog_uri"] = "https://github.com/mergentlabs/mergent-ruby/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
