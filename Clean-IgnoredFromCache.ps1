# Define paths and globs based on your .gitignore

$pathsToClean = @(
    ".vs",
    "Binaries",
    "Plugins/*/Binaries",
    "Build",
    "Intermediate",
    "Plugins/*/Intermediate",
    "Saved",
    "DerivedDataCache",
    "Content/Fab",
    "Content/CSDefender",
    "Content/Rock_Collection_04"
)

Write-Host "`n--- Cleaning Git Cache of Ignored Paths ---`n"

foreach ($path in $pathsToClean) {
    # Expand wildcards using Get-ChildItem if needed
    $matches = Get-ChildItem -Path $path -Directory -Recurse -ErrorAction SilentlyContinue

    if ($matches.Count -eq 0 -and -not (Test-Path $path)) {
        Write-Host "⏭️  Skipping '$path' — not found."
        continue
    }

    # Check if anything under this path is actually tracked
    $tracked = git ls-files "$path" 2>$null
    if ($tracked) {
        Write-Host "🧹 Removing '$path' from Git cache..."
        git rm -r --cached "$path"
    } else {
        Write-Host "✅ '$path' exists but is not tracked — skipping."
    }
}

Write-Host "`n✅ Done. Now commit and push the cleanup:"
Write-Host "   git commit -m \"Clean ignored files from Git cache\""
Write-Host "   git push"
