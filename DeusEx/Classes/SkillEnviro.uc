class SkillEnviro extends VMSkill;

defaultproperties
{
     UpgradeName="Environmental Training"
     Description="Experience with operating in various hazardous environments, and using specialized equipments.|n|n[UNTRAINED]|nAn agent can use the hazmat suit, ballistic armor, thermoptic camo, rebreather and tech goggles. An agent can also swim normally.|n- Lung capacity is 15 seconds.|n|n[TRAINED]|n+25% equipments' durability.|n+50% swimming speed and +5s lung capacity.|n|n[ADVANCED]|n+75% equipments' durability.|n+100% swimming speed and +10s lung capacity.|n|n[MASTER]|nAn agent wears suits and armor like a second skin, moves like a dolphin underwater.|n|n+150% equipments' durability.|n+200% swimming speed and +20s lung capacity."
     Icon=Texture'DeusExUI.UserInterface.SkillIconEnviro'
     Costs=(1250,2000,2750)
     GlobalValues=((Name="EquipmentChargeMult",Values=(0,0.25,0.75,1.5)),(Name="LungCapacity",Values=(0,5,10,20)),(Name="SwimmingSpeedMult",Values=(0,0.5,1,2)))
}
