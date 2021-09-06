class AugEMP extends VMAugmentation;

var() array<float> ResistanceMult;

static function bool Activate( VMPlayer player, int level ) {
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'EMP', default.ResistanceMult[level] );

    return true;
}

static function bool Deactivate( VMPlayer player, int level ) {
    player.CategoryModifiers.Modify( 'DamageResistanceMult', 'EMP', -default.ResistanceMult[level] );

    return true;
}

defaultproperties
{
     Icon=Texture'DeusExUI.UserInterface.AugIconEMP'
     SmallIcon=Texture'DeusExUI.UserInterface.AugIconEMP_Small'
     IsPassive=True
     UpgradeName="EMP Shield"
     Description="Nanoscale EMP generators partially protect individual nanites and reduce bioelectrical drain by canceling incoming pulses.|n|n[TECH ONE]|nDamage from EMP attacks is reduced by 25%.|n|n[TECH TWO]|nDamage from EMP attacks is reduced by 50%.|n|n[TECH THREE]|nDamage from EMP attacks is reduced by 75%.|n|n[TECH FOUR]|nAn agent is invulnerable to damage from EMP attacks."
     InstallLocation=AugmentationLocationSubdermal
     ResistanceMult=(0.25,0.5,0.75,1)
}
