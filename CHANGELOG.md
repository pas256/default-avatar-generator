# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.3] - 2026-09-07

### Fixed

- `ImageConverter.svg_to_jpeg` no longer uses vips's own SVG loader at all — it now
  rasterizes via the `rsvg-convert` CLI first, then hands vips the resulting PNG.
  0.2.2's buffer-load change did not actually fix the underlying issue: apps that load
  Rails Active Storage call `Vips.block_untrusted(true)` on boot, which disables vips's
  `svgload` **and** `svgload_buffer` process-wide (both are flagged `untrusted`), so the
  conversion still failed 100% of the time in any app using Active Storage. This adds a
  new system dependency: `librsvg2-bin` (Debian/Ubuntu) / `librsvg` (Homebrew).

## [0.2.2] - 2026-09-07

### Fixed

- `ImageConverter.svg_to_jpeg` now loads the SVG directly from memory via
  `Vips::Image.new_from_buffer` instead of writing it to a temp file first.
  The temp-file round trip was intermittently raising
  `Vips::Error: ... is not a known file format` in production.

## [0.2.1] - 2026-08-30

### Changed

- Updated dependencies and CI actions
- Added CLAUDE.md project documentation

## [0.1.0] - 2024-04-08

### Added

- Initial project setup as a ruby gem
- Generates SVG and JPEG images based on the included SVG files
