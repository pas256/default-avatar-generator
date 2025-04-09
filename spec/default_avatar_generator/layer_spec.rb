# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DefaultAvatarGenerator::Layer do
  let(:test_layer_class) do
    Class.new(described_class) do
      def template_path
        File.join(__dir__, '..', 'fixtures', '6colors.svg')
      end
    end
  end

  let(:test_layer) { test_layer_class.new('6colors', params) }
  let(:params) do
    {
      color1: '#ff0000',
      color2: '#00ff00',
      color3: '#0000ff',
      color4: '#ffff00',
      color5: '#00ffff',
      color6: '#ff00ff'
    }
  end

  describe '#render' do
    it 'replaces template parameters with values from params' do
      rendered = test_layer.render
      expect(rendered.to_s).to include('stop-color="#ff0000"')
      expect(rendered.to_s).to include('stop-color="#00ff00"')
      expect(rendered.to_s).to include('stop-color="#0000ff"')
      expect(rendered.to_s).to include('stop-color="#ffff00"')
      expect(rendered.to_s).to include('stop-color="#00ffff"')
      expect(rendered.to_s).to include('stop-color="#ff00ff"')
    end

    it 'leaves unreplaced parameters that are not in params' do
      test_layer = test_layer_class.new('6colors', {})
      rendered = test_layer.render.to_s
      expect(rendered).to include('stop-color="{{color1}}"')
    end

    it 'returns the SVG group string' do
      rendered = test_layer.render
      expect(rendered).to start_with('<g')
      expect(rendered).to end_with('</g>')
    end
  end
end
