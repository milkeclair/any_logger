# frozen_string_literal: true

require_relative "lib/any_logger/version"

Gem::Specification.new do |spec|
  spec.name = "any_logger"
  spec.version = AnyLogger::VERSION
  spec.authors = ["milkeclair"]
  spec.email = ["milkeclair.black@gmail.com"]

  spec.summary = "easy swap for LogSubscribers in rails"
  spec.description = "easy swap for LogSubscribers in rails"
  spec.homepage = "https://github.com/milkeclair/any_logger"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "actionmailer"
  spec.add_dependency "actionpack"
  spec.add_dependency "activejob"
  spec.add_dependency "activerecord"
  spec.add_dependency "activestorage"
  spec.add_dependency "activesupport"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
