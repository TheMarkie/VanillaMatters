class SkillEnviro extends VMSkill;

defaultproperties
{
     UpgradeName="Environmental Training"
     Description="Experience with operating in various hazardous environments, and using specialized equipments.|n|nUNTRAINED: Agent can use the hazmat suit, ballistic armor, thermoptic camo, rebreather and tech goggles. An agent can also swim normally.|n|nMASTER: Agent wears suits and armor like a second skin, moves like a dolphin underwater.|n|nEquipment Durability: +25% / 75% / 150%|nSwimming Speed: +50% / 100% / 200%|nLung Capacity: 15 / 20 / 25 / 30 seconds"
     Icon=Texture'DeusExUI.UserInterface.SkillIconEnviro'
     Costs=(1250,2000,2750)
     GlobalValues=((Name=EquipmentChargeMult,Values=(0,0.25,0.75,1.5)),(Name=UnderwaterTimeBonus,Values=(0,5,10,20)),(Name=SwimmingSpeedMult,Values=(0,0.5,1,2)))
}
