# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Ruby gem (`default-avatar-generator`) that generates unique default avatars for user accounts by layering SVG templates (background + foreground shape + text glyph) and optionally rasterizing to JPEG via libvips.

## Commands

```bash
bundle install              # install dependencies
bundle exec rspec           # run all specs
bundle exec rspec spec/default_avatar_generator/colors_spec.rb   # run a single spec file
bundle exec rspec spec/default_avatar_generator/colors_spec.rb:12  # run a single example by line
bundle exec rubocop         # lint
bundle exec rubocop -a      # lint with autocorrect
bundle exec rake            # default task: runs spec then rubocop (same as CI)
./viewer                    # starts a Sinatra dev server at http://localhost:9292 to preview generated avatars (reload to regenerate)
```

Ruby version is pinned in `.ruby-version`; libvips must be installed on the system (native dependency of `ruby-vips`) for image generation/conversion to work.

## Publishing

`.github/workflows/publish.yml` runs on **every push to `main`** and unconditionally builds and pushes the gem to both the GitHub Package Registry and RubyGems.org (via `rubygems/release-gem@v1`) — there's no tag or version-change gate. This means:

- Bump `DefaultAvatarGenerator::VERSION` in `lib/default_avatar_generator/version.rb` as part of any PR that should ship a new release; merging to `main` without bumping it will make the GitHub Package Registry push fail (gem push rejects a version that already exists) and the RubyGems step will effectively be a no-op.
- Locally, `bundle exec rake release` (bump version first) does the equivalent: tags the commit, pushes commits/tags, and pushes the `.gem` file to rubygems.org. Prefer letting CI handle publishing on merge rather than running this locally, to avoid double-publishing.

## Architecture

Avatar generation is a pipeline of SVG **layers** composed together, then optionally rasterized:

1. **`Generator`** (`lib/default_avatar_generator/generator.rb`) — the entry point. Randomly picks a background/foreground/text template from its `AVAILABLE_*` constants, randomly picks colors via `Colors`, and builds one `Layer` subclass instance per layer type. Accepts an `options` hash (`:background`, `:foreground`, `:text`) whose values are merged over (and override) the randomly-generated params, so callers can pin specific colors/characters/transforms while leaving the rest random.
2. **`Layer`** (`layer.rb`) — abstract base. Loads an SVG template file, does `{{param}}` placeholder substitution via a `params` hash, parses the result with Nokogiri, and returns just the first child element inside the template's `<svg>` root (so it can be inlined into a parent SVG). Subclasses (`BackgroundLayer`, `ForegroundLayer`, `TextLayer`) only override `template_path`, pointing at `lib/assets/{backgrounds,foregrounds,text}/<name>.svg`.
3. **`Composer`** — wraps the rendered output of all layers in one `<svg viewBox="0 0 512 512">` and minifies the markup via `SvgUtils.minify`.
4. **`ImageConverter.svg_to_jpeg`** — writes the composed SVG to a tempfile, loads it with `Vips::Image`, converts to sRGB, and returns a JPEG buffer (`Q: 90`).
5. **`Colors`** — a static Tailwind-derived color palette (`COLORS`, color name → shade 50-950 → hex). Helpers pick "solid" shades (300-900) for backgrounds vs "contrast" shades (50/100/950) for foreground/text so text stays legible against the shape it sits on; `opposite_shade` maps a shade to its visual inverse so foreground and text use contrasting shades of the *same* color.

Templates live under `lib/assets/{backgrounds,foregrounds,text}/*.svg` and use `{{param_name}}` placeholders (e.g. `{{color1}}`, `{{color}}`, `{{transformation}}`, `{{character}}`) filled in by `Layer#process_template`. Adding a new background/foreground/text variant means adding an SVG template with the right placeholders and registering its base filename in the corresponding `AVAILABLE_*` array in `Generator`.

Note in `Generator`: the `base` text template is deliberately excluded from `AVAILABLE_TEXT` because libvips' SVG renderer (librsvg) doesn't yet support `dominant-baseline`, which that template relies on.

The `sample/` Sinatra app (run via `./viewer`) is a manual visual smoke-test harness, not part of the gem's public API — it's how avatar output is eyeballed during development.
