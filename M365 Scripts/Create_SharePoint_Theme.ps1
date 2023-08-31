Connect-SPOService -URL https://theneighborlyway-admin.sharepoint.com

$themepalette = @{
"themePrimary" = "#00798c";
"themeLighterAlt" = "#000506";
"themeLighter" = "#001316";
"themeLight" = "#00242a";
"themeTertiary" = "#004954";
"themeSecondary" = "#006b7b";
"themeDarkAlt" = "#0f8698";
"themeDark" = "#2897a8";
"themeDarker" = "#54b0bf";
"neutralLighterAlt" = "#e6eee5";
"neutralLighter" = "#e2eae1";
"neutralLight" = "#d9e1d8";
"neutralQuaternaryAlt" = "#cad1c9";
"neutralQuaternary" = "#c1c8c0";
"neutralTertiaryAlt" = "#b9c0b8";
"neutralTertiary" = "#595959";
"neutralSecondary" = "#373737";
"neutralPrimaryAlt" = "#2f2f2f";
"neutralPrimary" = "#000000";
"neutralDark" = "#151515";
"black" = "#0b0b0b";
"white" = "#ecf4eb";
}

Add-SPOTheme -Identity “NVI Standard” -Palette $themepalette -IsInverted $false
