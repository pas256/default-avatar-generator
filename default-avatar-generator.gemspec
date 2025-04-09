# frozen_string_literal: true

require_relative 'lib/default_avatar_generator/version'

Gem::Specification.new do |spec|
  spec.name          = 'default-avatar-generator'
  spec.version       = DefaultAvatarGenerator::VERSION
  spec.authors       = ['Peter Sankauskas']
  spec.email         = ['peter+avatar@pas.ventures']

  spec.summary       = 'Generate unique, default avatars for user accounts'
  spec.description   = 'Generates beautiful and unique default avatars for user accounts'
  spec.homepage      = 'https://github.com/pas256/default-avatar-generator'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.0.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[
                          lib/**/*
                          README.md
                          LICENSE.txt
                          CHANGELOG.md
                        ])
  spec.require_paths = ['lib']

  # Runtime dependencies
  spec.add_dependency 'nokogiri', '~> 1.18' # For XML/SVG processing
  spec.add_dependency 'ruby-vips', '~> 2.2' # For image generation

  spec.metadata['rubygems_mfa_required'] = 'true'
end
