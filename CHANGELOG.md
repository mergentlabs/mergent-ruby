## [Unreleased]

## [1.0] - 2022-03-10

- Switch to the V2 API
  - Add `id` attribute to Task
  - Make `name` optional
  - Add optional `queue` attribute to Task that defaults to `default`
  - Remove `description` from Task
- Add support for creating, deleting, and updating Schedules

## [0.2.2] - 2022-01-20

- Add `Mergent::RequestValidator` to validate that webhooks came from Mergent's API

## [0.2.1] - 2022-01-20

- Add `Mergent::RequestValidator` to validate that webhooks came from Mergent's API

## [0.2.0] - 2022-01-20

- Add `Mergent::RequestValidator` to validate that webhooks came from Mergent's API

## [0.1.2] - 2022-1-13

- Define explicit methods in `Mergent::Task`, to allow for use of verifying doubles when testing against them.
- Remove deprecated `cron` method definition

## [0.1.1] - 2021-12-21

- Define explicit methods in `Mergent::Task`, to allow for use of verifying doubles when testing against them.
- Update summary and description for RubyGems.org

## [0.1.0] - 2021-11-21

- Initial release
