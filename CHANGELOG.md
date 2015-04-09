# Changelog

## 0.11.0 (2015-04-09)

- Using semantic versioning and tracking changes in the CHANGELOG.md file
- All configuration moved into vagrant.yml
- Refactored synced folders setup
  - Focused on better Windows support with SMB and rsync
  - Added an experimental `smb2` synced folder option, which does not require running vagrant as admin, but requires initial manual setup.
  - rsync can now be done per project instead of the whole <Projects> folder
- Documentation overhaul
- Fixes in setup.sh - making sure brew formulae are up to date.
