# Work profile — Bloomberg
set -gx UV_INDEX_URL "https://pypi.bloomberg.com/simple"
set -gx UV_EXTRA_INDEX_URL "https://pypi.org/simple"

# bbcmake: prefer over system cmake-format if available
if command -q bbcmake
    set -gx CMAKE_FORMATTER bbcmake
else
    set -gx CMAKE_FORMATTER cmake-format
    set -W # suppress warning; bbcmake not installed is fine on non-BDE machines
end

# Bloomberg proxy (if needed — uncomment)
# set -gx https_proxy http://proxy.bloomberg.com:8080
# set -gx http_proxy  http://proxy.bloomberg.com:8080

# BDE-specific
abbr -a bde-fmt 'clang-format -style=file'  # uses ~/.clang-format → work style
