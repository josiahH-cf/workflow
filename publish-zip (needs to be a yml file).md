name: Build and publish zip

on:
  push:
    branches: [ "main" ]

permissions:
  contents: write

jobs:
  zip-and-release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      # Create a zip of a folder (change "dist" to whatever you want to package)
      - name: Create zip
        run: |
          rm -f package.zip
          zip -r package.zip dist -x "**/.DS_Store"

      # Create or update a release named "latest" using a fixed tag "latest"
      - name: Create/Update latest release
        uses: softprops/action-gh-release@v2
        with:
          tag_name: latest
          name: Latest
          prerelease: false
          files: package.zip
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}