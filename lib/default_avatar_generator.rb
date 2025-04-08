# frozen_string_literal: true

require 'vips'
require_relative 'default_avatar_generator/version'
require_relative 'default_avatar_generator/colors'
require_relative 'default_avatar_generator/layer'
require_relative 'default_avatar_generator/background_layer'
require_relative 'default_avatar_generator/foreground_layer'
require_relative 'default_avatar_generator/text_layer'
require_relative 'default_avatar_generator/svg_utils'
require_relative 'default_avatar_generator/composer'
require_relative 'default_avatar_generator/generator'
require_relative 'default_avatar_generator/image_converter'

module DefaultAvatarGenerator
  class Error < StandardError; end
end
