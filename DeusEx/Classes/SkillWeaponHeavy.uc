//=============================================================================
// SkillWeaponHeavy.
//=============================================================================
class SkillWeaponHeavy extends VMSkill;

defaultproperties
{
     SkillName="Weapons: Destructive"
     Description="The use of explosive or heavy weaponry, including flamethrowers, LAWs, the experimental plasma and GEP guns, in addition to grenades.|n|nUNTRAINED: An agent can use heavy weapons, but with difficult movement. An agent can also throw grenades, attach them to surfaces as proximity devices, or disarm a previously armed one.|n- Safety margin for disarming proximity devices is 1s.|n|nTRAINED:|n+20% damage and +5% accuracy.|n-20% stabilization time and +10% recoil recovery.|n-10% reload time.|n+20% gas stun duration.|n-15% GEP lock-on time.|n+80% safety margin.|n|nADVANCED: An agent can move swiftly with heavy weapons.|n+50% damage, +12.5% accuracy.|n-50% stabilization time and +25% recoil recovery.|n-25% reload time.|n+50% gas stun duration.|n-37.5% lock-on time.|n+200% safety margin.|n|nMASTER: An agent is an expert in all forms of destruction.|n+100% damage, +25% accuracy.|n-100% stabilization time and +50% recoil recovery.|n-50% reload time.|n+100% gas stun duration.|n-75% lock-on time.|n+400% safety margin."
     SkillIcon=Texture'DeusExUI.UserInterface.SkillIconWeaponHeavy'
     Costs=(1575,3150,5250)
}
