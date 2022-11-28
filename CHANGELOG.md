# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.2.0]

### Changed

- BREAKING CHANGE: change `spec.containers.*.env.*.values_from` -> `spec.containers.*.env.*.value_from`
- BREAKING CHANGE: change `spec.containers.*.ports.*.protocol` defaulting from "TCP" to `null`

## [0.1.0] BREAKING CHANGES

### Added

- Add support for reading secrets from secret manager for container environment variables

### Changed

- Updated IAM module to support IAM members validation

### Fixed

- Fix template variable that is required (was defined as optional)
- Fix disabling module
- Fix IAM usage where Terraform complains over mismatched types in ternary operator

### Removed

- BREAKING CHANGE: Drop support for Terraform Google Provider < 4.1
- BREAKING CHANGE: Drop support for Terraform < 1.0

## [0.0.2]

### Added

- Support for provider 4.x

## [0.0.1]

### Added

- Initial Implementation

<!-- markdown-link-check-disable -->

[unreleased]: https://github.com/mineiros-io/terraform-google-cloud-run/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/mineiros-io/terraform-google-cloud-run/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/mineiros-io/terraform-google-cloud-run/compare/v0.0.2...v0.1.0
[0.0.2]: https://github.com/mineiros-io/terraform-google-cloud-run/compare/v0.0.1...v0.0.2
[0.0.1]: https://github.com/mineiros-io/terraform-google-cloud-run/releases/tag/v0.0.1

<!-- markdown-link-check-disabled -->
