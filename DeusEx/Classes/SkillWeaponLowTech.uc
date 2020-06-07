//=============================================================================
// SkillWeaponLowTech.
//=============================================================================
class SkillWeaponLowTech extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Low-Tech"
     Description="The use of melee weapons.|n|nAffects: Melee weapons, Throwing Knives, Prod, Pepper Gun.|n|nUNTRAINED: An agent can use melee weaponry.|n|nTRAINED:|n+20% melee damage.|n+20% prod and pepper gun stun duration.|n|nADVANCED:|n+50% melee damage|n+50% prod and pepper gun stun duration|nThrowing Knives:|n+50% damage|n+15% accuracy|n|nMASTER: An agent can render most opponents unconscious or dead with a single blow.|n+100% melee damage.|n+100% prod and pepper gun stun duration.|nThrowing Knives:|n+100% damage|n+25% accuracy"
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponLowTech'
     Costs=(1350,2700,4500)
     SkillValues=((Name="MeleeWeaponDamage",Values=(0,0.2,0.5,1)),(Name="WeaponProdDamage",Values=(0,0.2,0.5,1)),(Name="WeaponPepperGunDamage",Values=(0,0.2,0.5,1)),(Name="WeaponShurikenDamage",Values=(0,0,0.5,1)),(Name="WeaponShurikenAccuracy",Values=(0,0,0.15,0.25)))
}
