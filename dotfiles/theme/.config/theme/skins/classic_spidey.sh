# classic_spidey.sh - Theme Variables for Spider-Man Classic
export THEME_NAME="Spider-Man Classic"
export COLOR_PRIMARY="#e60026"
export COLOR_PRIMARY_GLOW="#ff3b5c"
export COLOR_SECONDARY="#00e5ff"
export COLOR_BG_DARK="#0c0d12"
export COLOR_BG_LIGHT="#16171f"
export COLOR_FG="#f8f9fa"
export COLOR_INACTIVE="#474b5c"

# FZF dynamic theme options
export FZF_THEME="--color=\"bg+:${COLOR_BG_LIGHT},bg:${COLOR_BG_DARK},spinner:${COLOR_PRIMARY_GLOW},hl:${COLOR_SECONDARY}\" \
--color=\"fg:${COLOR_FG},header:${COLOR_PRIMARY_GLOW},info:#d500f9,pointer:#00e676\" \
--color=\"marker:${COLOR_PRIMARY},fg+:#ffffff,prompt:${COLOR_PRIMARY},hl+:${COLOR_SECONDARY},border:${COLOR_PRIMARY_GLOW}\""
