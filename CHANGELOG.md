# Changelog

## 0.4.0 (2025-01-16)

### Breaking
- Adds a struct for the `PhoenixImportmap.Importmap` module that implements the `Phoenix.HTML.Safe` protocol. This change is a breaking change if you currently use `raw` to
interpolate the importmap into the template.

## 0.3.0 (2025-01-09)

### Breaking
- Use a reference to consuming projects' Endpoint module to generate digested asset paths in production.
