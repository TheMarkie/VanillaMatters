//=============================================================================
// AmmoDartFlare.
//=============================================================================
class AmmoDartFlare extends AmmoDart;

// Vanilla Matters: Replacement textures.
#exec TEXTURE IMPORT FILE="Textures\AmmoDartTex3.bmp"                   NAME="AmmoDartTex3"                     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\BeltIconAmmoDartsInjector.bmp"      NAME="BeltIconAmmoDartsInjector"        GROUP="VMUI" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\LargeIconAmmoDartsInjector.bmp"     NAME="LargeIconAmmoDartsInjector"       GROUP="VMUI" MIPS=On

defaultproperties
{
     ItemName="Injector Darts"
     Icon=Texture'DeusEx.VMUI.BeltIconAmmoDartsInjector'
     largeIcon=Texture'DeusEx.VMUI.LargeIconAmmoDartsInjector'
     Description="Mini-crossbow injector darts are capable of establishing a remote connection to any computer or terminal, disrupting many forms of electronic devices, or causing electronic damage to robots."
     beltDescription="INJ DART"
     Skin=Texture'DeusEx.VM.AmmoDartTex3'
}
