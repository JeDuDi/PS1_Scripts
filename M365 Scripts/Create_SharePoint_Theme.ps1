<#

    .PURPOSE
        This script pushes a new theme to SPO.
    .NOTES
        Created by JeDuDi

#>

Connect-SPOService -URL https://yourtenant-admin.sharepoint.com

$themepalette = @{
"themePrimary" = "#00748c";
"themeLighterAlt" = "#000506";
"themeLighter" = "#001316";
"themeLight" = "#00242a";
"themeTertiary" = "#004954";
"themeSecondary" = "#006b7b";
"themeDarkAlt" = "#0f8698";
"themeDark" = "#2897a8";
"themeDarker" = "#53b0bf";
"neutralLighterAlt" = "#e6eee5";
"neutralLighter" = "#e2eae1";
"neutralLight" = "#d9e1d8";
"neutralQuaternaryAlt" = "#cad1c9";
"neutralQuaternary" = "#c1c8c0";
"neutralTertiaryAlt" = "#b9c0b8";
"neutralTertiary" = "#565959";
"neutralSecondary" = "#373737";
"neutralPrimaryAlt" = "#2f2f2f";
"neutralPrimary" = "#000000";
"neutralDark" = "#151315";
"black" = "#0c0b0b";
"white" = "#ecf4eb";
}

Add-SPOTheme -Identity “Tenant Standard” -Palette $themepalette -IsInverted $false
