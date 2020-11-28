class SkillWeaponLowTech extends VMSkill;

defaultproperties
{
     UpgradeName="Weapons: Low-Tech"
     Description="The use of melee weapons.|n|nAffects: Melee weapons, Throwing Knives, Prod, Pepper Gun.|n|n[UNTRAINED]|nAn agent can use melee weaponry.|n|n[TRAINED]|n+20% melee damage.|n+20% prod and pepper gun stun duration.|n|n[ADVANCED]|n+50% melee damage|n+50% prod and pepper gun stun duration|n|n<Throwing Knives>|n+50% damage|n+15% accuracy|n|n[MASTER]|nAn agent can render most opponents unconscious or dead with a single blow.|n+100% melee damage.|n+100% prod and pepper gun stun duration.|n|n<Throwing Knives>|n+100% damage|n+25% accuracy"
     Icon=Texture'DeusExUI.UserInterface.SkillIconWeaponLowTech'
     Costs=(1250,2500,3750)
     GlobalValues=((Name=MeleeWeaponDamage,Values=(0,0.2,0.5,1)))
     CategoryValues=((Name=Damage,Values=((Name=WeaponProd,Values=(0,0.2,0.5,1)),(Name=WeaponPepperGun,Values=(0,0.2,0.5,1)),(Name=WeaponShuriken,Values=(0,0,0.5,1)))),(Name=Accuracy,Values=((Name=WeaponShuriken,Values=(0,0,0.15,0.25)))))
}
