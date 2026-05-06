# Bloomberg Spaces profile (RHEL8 remote dev environment)
# No bbvpn — proxy not needed. No brew — apt/dnf only.

# PyPI — use Bloomberg index
set -gx UV_INDEX_URL "https://pypi.bloomberg.com/simple"
set -gx UV_EXTRA_INDEX_URL "https://pypi.org/simple"

# bbcmake: prefer over system cmake if available
if command -q bbcmake
    set -gx CMAKE_FORMATTER bbcmake
else
    set -gx CMAKE_FORMATTER cmake-format
end

# BDE-specific
abbr -a bde-fmt 'clang-format -style=file'  # uses ~/.clang-format → bloomberg style
