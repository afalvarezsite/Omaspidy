# miles_morales.sh - Theme Variables for Miles Morales
export THEME_NAME="Miles Morales"
export COLOR_PRIMARY="#ff1e43"
export COLOR_PRIMARY_GLOW="#ff5773"
export COLOR_SECONDARY="#d500f9"
export COLOR_BG_DARK="#08080a"
export COLOR_BG_LIGHT="#141419"
export COLOR_FG="#f8f9fa"
export COLOR_INACTIVE="#4a4b57"

# FZF dynamic theme options
export FZF_THEME="--color=\"bg+:${COLOR_BG_LIGHT},bg:${COLOR_BG_DARK},spinner:${COLOR_PRIMARY_GLOW},hl:${COLOR_SECONDARY}\" \
--color=\"fg:${COLOR_FG},header:${COLOR_PRIMARY_GLOW},info:#d500f9,pointer:#ff1e43\" \
--color=\"marker:${COLOR_PRIMARY},fg+:#ffffff,prompt:${COLOR_PRIMARY},hl+:${COLOR_SECONDARY},border:${COLOR_PRIMARY_GLOW}\""
