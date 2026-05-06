# Work profile — Bloomberg

# PyPI — use Bloomberg index (uv respects these)
set -gx UV_INDEX_URL "https://pypi.bloomberg.com/simple"
set -gx UV_EXTRA_INDEX_URL "https://pypi.org/simple"

# bbcmake: prefer over system cmake if available
if command -q bbcmake
    set -gx CMAKE_FORMATTER bbcmake
else
    set -gx CMAKE_FORMATTER cmake-format
end

# ── bbvpn proxies ─────────────────────────────────────────────────────────────
# Do NOT export these globally — they break when off VPN.
# Prefix commands with ext_proxy or dev_proxy as needed:
#   ext_proxy brew install fish
#   dev_proxy curl https://blp-dpkg.dev.bloomberg.com
#
# ext_proxy: external internet (github.com, ghcr.io, pypi.org, etc.)
abbr -a ext_proxy 'http_proxy=http://proxy.bloomberg.com:81 https_proxy=http://proxy.bloomberg.com:81'
# dev_proxy: Bloomberg internal services (bbgithub, dpkg, etc.)
abbr -a dev_proxy 'http_proxy=http://bproxy.tdmz1.bloomberg.com:80 https_proxy=http://bproxy.tdmz1.bloomberg.com:80'

# BDE-specific
abbr -a bde-fmt 'clang-format -style=file'  # uses ~/.clang-format → work style
