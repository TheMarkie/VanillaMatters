//=============================================================================
// JCDentonMale.
//=============================================================================
class JCDentonMale extends Human;

// Colored hand textures
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex1a.bmp"       NAME="WeaponHandsTex1a"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex2a.bmp"       NAME="WeaponHandsTex2a"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex3a.bmp"       NAME="WeaponHandsTex3a"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex4a.bmp"       NAME="WeaponHandsTex4a"     GROUP="VM" MIPS=On

#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex1b.bmp"       NAME="WeaponHandsTex1b"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex2b.bmp"       NAME="WeaponHandsTex2b"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex3b.bmp"       NAME="WeaponHandsTex3b"     GROUP="VM" MIPS=On
#exec TEXTURE IMPORT FILE="Textures\WeaponHandsTex4b.bmp"       NAME="WeaponHandsTex4b"     GROUP="VM" MIPS=On

// ----------------------------------------------------------------------
// TravelPostAccept()
// ----------------------------------------------------------------------

event TravelPostAccept()
{
    local DeusExLevelInfo info;

    Super.TravelPostAccept();

    switch(PlayerSkin)
    {
        case 0: MultiSkins[0] = Texture'JCDentonTex0'; break;
        case 1: MultiSkins[0] = Texture'JCDentonTex4'; break;
        case 2: MultiSkins[0] = Texture'JCDentonTex5'; break;
        case 3: MultiSkins[0] = Texture'JCDentonTex6'; break;
        case 4: MultiSkins[0] = Texture'JCDentonTex7'; break;
    }
}

// ----------------------------------------------------------------------
// ----------------------------------------------------------------------

defaultproperties
{
     StartingSkills=(Class'DeusEx.SkillWeaponPistol',Class'DeusEx.SkillWeaponRifle',Class'DeusEx.SkillWeaponHeavy',Class'DeusEx.SkillWeaponLowTech',Class'DeusEx.SkillComputer',Class'DeusEx.SkillTech',Class'DeusEx.SkillLockpicking',Class'DeusEx.SkillMedicine',Class'DeusEx.SkillEnviro')
     CarcassType=Class'DeusEx.JCDentonMaleCarcass'
     JumpSound=Sound'DeusExSounds.Player.MaleJump'
     HitSound1=Sound'DeusExSounds.Player.MalePainSmall'
     HitSound2=Sound'DeusExSounds.Player.MalePainMedium'
     Land=Sound'DeusExSounds.Player.MaleLand'
     Die=Sound'DeusExSounds.Player.MaleDeath'
     Mesh=LodMesh'DeusExCharacters.GM_Trench'
     MultiSkins(0)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(1)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(2)=Texture'DeusExCharacters.Skins.JCDentonTex3'
     MultiSkins(3)=Texture'DeusExCharacters.Skins.JCDentonTex0'
     MultiSkins(4)=Texture'DeusExCharacters.Skins.JCDentonTex1'
     MultiSkins(5)=Texture'DeusExCharacters.Skins.JCDentonTex2'
     MultiSkins(6)=Texture'DeusExCharacters.Skins.FramesTex4'
     MultiSkins(7)=Texture'DeusExCharacters.Skins.LensesTex5'
}
