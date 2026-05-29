# symbiote.sh - Theme Variables for Symbiote Suit
export THEME_NAME="Symbiote Suit"
export COLOR_PRIMARY="#ffffff"
export COLOR_PRIMARY_GLOW="#f8f9fa"
export COLOR_SECONDARY="#70757a"
export COLOR_BG_DARK="#050505"
export COLOR_BG_LIGHT="#121212"
export COLOR_FG="#e8eaed"
export COLOR_INACTIVE="#3c4043"

# FZF dynamic theme options
export FZF_THEME="--color=\"bg+:${COLOR_BG_LIGHT},bg:${COLOR_BG_DARK},spinner:${COLOR_PRIMARY_GLOW},hl:${COLOR_SECONDARY}\" \
--color=\"fg:${COLOR_FG},header:${COLOR_PRIMARY_GLOW},info:#70757a,pointer:#ffffff\" \
--color=\"marker:${COLOR_PRIMARY},fg+:#ffffff,prompt:${COLOR_PRIMARY},hl+:${COLOR_SECONDARY},border:${COLOR_PRIMARY_GLOW}\""
