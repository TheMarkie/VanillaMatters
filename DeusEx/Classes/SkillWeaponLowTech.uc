//=============================================================================
// SkillWeaponLowTech.
//=============================================================================
class SkillWeaponLowTech extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Low-Tech"
     Description="The use of melee weapons such as knives, throwing knives, swords, pepper guns, and prods.|n|nUNTRAINED: An agent can use melee weaponry.|n|nTRAINED:|n+20% melee damage.|n+20% prod and pepper gun stun duration.|n|nADVANCED:|n+50% damage.|n+50% prod and pepper gun stun duration.|n+50% Shuriken damage.|n+15% Shuriken accuracy.|n|nMASTER: An agent can render most opponents unconscious or dead with a single blow.|n+100% damage.|n+100% prod and pepper gun stun duration.|n+100% Shuriken damage.|n+25% Shuriken accuracy."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponLowTech'
     Costs=(1350,2700,4500)
     SkillValues=((Name="MeleeWeaponDamage",Values=(0,0.2,0.5,1)),(Name="WeaponProdDamage",Values=(0,0.2,0.5,1)),(Name="WeaponPepperGunDamage",Values=(0,0.2,0.5,1)),(Name="WeaponShurikenDamage",Values=(0,0,0.5,1)),(Name="WeaponShurikenAccuracy",Values=(0,0,0.15,0.25)))
}
