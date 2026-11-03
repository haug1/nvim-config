local assets = {}
for target, triple in pairs({
  linux_x64 = "x86_64-unknown-linux-musl",
  linux_arm64 = "aarch64-unknown-linux-musl",
  darwin_x64 = "x86_64-apple-darwin",
  darwin_arm64 = "aarch64-apple-darwin",
}) do
  local directory = "ktrs-{{version}}-" .. triple
  table.insert(assets, {
    target = target,
    file = directory .. ".tar.gz",
    bin = directory .. "/ktrs",
  })
end

return {
  name = "ktrs",
  description = "Native Kotlin formatter and linter with LSP support.",
  homepage = "https://github.com/Hexay/ktrs",
  licenses = { "MIT", "Apache-2.0" },
  languages = { "Kotlin" },
  categories = { "LSP", "Formatter", "Linter" },
  source = { id = "pkg:github/Hexay/ktrs@v0.5.3", asset = assets },
  bin = { ktrs = "{{source.asset.bin}}" },
}
