# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DefaultAvatarGenerator do
  it 'has a version number' do
    expect(DefaultAvatarGenerator::VERSION).not_to be_nil
  end
end
