class SkillWeaponLowTech extends VMSkill;

defaultproperties
{
     UpgradeName="Weapons: Low-Tech"
     Description="The use of melee weapons.|n|nAffects: Melee weapons, Throwing Knives, Prod, Pepper Gun.|n|nUNTRAINED: Agent can use melee weaponry.|n|nMASTER: Agent can render most opponents unconscious or dead with a single blow.|n|nMelee Damage: +20% / 50% / 100%|nStun Duration: +20% / 50% / 100%|n|n[Throwing Knives]|nDamage: +0% / 50% / 100%|nAccuracy: +0% / 15% / 25%"
     Icon=Texture'DeusExUI.UserInterface.SkillIconWeaponLowTech'
     Costs=(1250,2500,3750)
     GlobalValues=((Name=MeleeWeaponDamage,Values=(0,0.2,0.5,1)))
     CategoryValues=((Name=Damage,Values=((Name=WeaponProd,Values=(0,0.2,0.5,1)),(Name=WeaponPepperGun,Values=(0,0.2,0.5,1)),(Name=WeaponShuriken,Values=(0,0,0.5,1)))),(Name=Accuracy,Values=((Name=WeaponShuriken,Values=(0,0,0.15,0.25)))))
}
