# frozen_string_literal: true

require 'sinatra'
require 'base64'
require_relative '../lib/default_avatar_generator'

helpers do
  def render_avatar(image, format)
    if format == 'jpeg'
      "<img src='data:image/jpeg;base64,#{Base64.strict_encode64(image)}' width='100%' height='100%'>"
    else
      image
    end
  end
end

get '/' do # rubocop:disable Metrics/BlockLength
  # Get format from query parameter, default to SVG
  format = params['format'] || 'svg'

  # Generate a new SVG avatar
  random_char = ('A'..'Z').to_a.sample
  svg = DefaultAvatarGenerator::Generator.new(text: { character: random_char }).generate

  # Convert to JPEG if requested
  image = if format == 'jpeg'
            DefaultAvatarGenerator::ImageConverter.svg_to_jpeg(svg)
          else
            svg
          end

  # Set content type to HTML
  content_type 'text/html'

  # Return HTML that displays the SVG
  <<-HTML
    <!DOCTYPE html>
    <html>
      <head>
        <title>Default Avatar Generator Demo</title>
        <style>
          body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
            font-family: system-ui, -apple-system, sans-serif;
          }
          .container {
            text-align: center;
            background: white;
            padding: 2rem;
            border-radius: 10px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
          }
          h1 {
            color: #333;
            margin-bottom: 1rem;
          }
          .format-selector {
            margin-bottom: 2rem;
            display: flex;
            gap: 1rem;
            justify-content: center;
            align-items: center;
          }
          .format-selector label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
          }
          .format-selector input[type="radio"] {
            cursor: pointer;
          }
          .avatars-container {
            display: flex;
            flex-direction: column;
            gap: 2rem;
            justify-content: center;
          }
          .avatar-row {
            display: flex;
            gap: 2rem;
            justify-content: center;
          }
          .avatar {
            width: 512px;
            height: 512px;
            display: block;
          }
          .avatar.medium {
            width: 64px;
            height: 64px;
          }
          .avatar.small {
            width: 32px;
            height: 32px;
          }
          .avatar.circle {
            border-radius: 50%;
            overflow: hidden;
          }
        </style>
      </head>
      <body>
        <div class="container">
          <h1>Default Avatar Generator</h1>
          <div class="format-selector">
            <label>
              <input type="radio" name="format" value="svg" #{format == 'svg' ? 'checked' : ''} onchange="window.location.href='?format=svg'">
              SVG
            </label>
            <label>
              <input type="radio" name="format" value="jpeg" #{format == 'jpeg' ? 'checked' : ''} onchange="window.location.href='?format=jpeg'">
              JPEG
            </label>
          </div>
          <div class="avatars-container">
            <div class="avatar-row">
              <div class="avatar">
                #{render_avatar(image, format)}
              </div>
              <div class="avatar circle">
                #{render_avatar(image, format)}
              </div>
            </div>
            <div class="avatar-row">
              <div class="avatar medium">
                #{render_avatar(image, format)}
              </div>
              <div class="avatar medium circle">
                #{render_avatar(image, format)}
              </div>
            </div>
            <div class="avatar-row">
              <div class="avatar small">
                #{render_avatar(image, format)}
              </div>
              <div class="avatar small circle">
                #{render_avatar(image, format)}
              </div>
            </div>
          </div>
        </div>
      </body>
    </html>
  HTML
end
