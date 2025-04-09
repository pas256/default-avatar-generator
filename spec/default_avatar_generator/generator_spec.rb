# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DefaultAvatarGenerator::Generator do
  describe 'constants' do
    it 'defines available backgrounds' do
      expect(described_class::AVAILABLE_BACKGROUNDS).to contain_exactly(
        'solid',
        'gradient-2h',
        'gradient-3h',
        'gradient-slash',
        'gradient-backslash',
        'gradient-lr',
        'gradient-tb'
      )
    end

    it 'defines available foregrounds' do
      expect(described_class::AVAILABLE_FOREGROUNDS).to contain_exactly(
        'head1-solid',
        'head2',
        'head3'
      )
    end
  end

  describe '#generate' do
    let(:generator) { described_class.new(options) }
    let(:options) { {} }
    let(:composer) { instance_double(DefaultAvatarGenerator::Composer) }
    let(:background_layer) { instance_double(DefaultAvatarGenerator::BackgroundLayer) }
    let(:foreground_layer) { instance_double(DefaultAvatarGenerator::ForegroundLayer) }
    let(:text_layer) { instance_double(DefaultAvatarGenerator::TextLayer) }

    before do
      allow(DefaultAvatarGenerator::BackgroundLayer).to receive(:new).and_return(background_layer)
      allow(DefaultAvatarGenerator::ForegroundLayer).to receive(:new).and_return(foreground_layer)
      allow(DefaultAvatarGenerator::TextLayer).to receive(:new).and_return(text_layer)
      allow(DefaultAvatarGenerator::Composer).to receive(:new).and_return(composer)
      allow(composer).to receive(:compose)
    end

    it 'creates layers and composes them' do
      generator.generate

      expect(DefaultAvatarGenerator::Composer).to have_received(:new).with(
        [background_layer, foreground_layer, text_layer]
      )
      expect(composer).to have_received(:compose)
    end

    context 'with custom options' do
      let(:options) do
        {
          background: { color1: '#FF0000' },
          foreground: { color: '#00FF00' }
        }
      end

      it 'merges custom options with default params' do
        generator.generate

        expect(DefaultAvatarGenerator::BackgroundLayer).to have_received(:new) do |_style, params|
          expect(params[:color1]).to eq('#FF0000')
        end

        expect(DefaultAvatarGenerator::ForegroundLayer).to have_received(:new) do |_style, params|
          expect(params[:color]).to eq('#00FF00')
        end
      end
    end
  end

  describe '#select_background' do
    let(:generator) { described_class.new }

    it 'returns a random background from available backgrounds' do
      result = generator.select_background
      expect(described_class::AVAILABLE_BACKGROUNDS).to include(result)
    end
  end

  describe '#select_foreground' do
    let(:generator) { described_class.new }

    it 'returns a random foreground from available foregrounds' do
      result = generator.select_foreground
      expect(described_class::AVAILABLE_FOREGROUNDS).to include(result)
    end
  end

  describe '#background_params' do
    let(:generator) { described_class.new }

    it 'returns a hash with color parameters' do
      allow(DefaultAvatarGenerator::Colors).to receive(:select_solid_color).and_return('#2dd4bf')

      params = generator.background_params

      expect(params.keys).to contain_exactly(:color1, :color2, :color3, :color4, :color5, :color6)
      params.each_value do |color|
        expect(color).to eq('#2dd4bf')
      end
    end
  end

  describe '#foreground_params' do
    let(:generator) { described_class.new }

    it 'returns a hash with color and transform parameters' do
      allow(DefaultAvatarGenerator::Colors).to receive(:get).and_return('#3b0764')
      allow(DefaultAvatarGenerator::ForegroundLayer).to receive(:select_transform).and_return('rotate-90')

      params = generator.foreground_params

      expect(params).to include(
        color: '#3b0764',
        transformation: 'rotate-90'
      )
    end
  end
end
