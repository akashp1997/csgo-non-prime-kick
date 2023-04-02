#include <sourcemod>
#include <SteamWorks>

#pragma semicolon 1

public Plugin myinfo = {
    name        = "CS:GO Non-Prime kick",
    author      = "Akash Purandare",
    description = "Automatically kicks non-premium players",
    version     = "1.0.0",
    url         = "https://fegaming.xyz"
};
public int isPluginEnabled = 1;

public OnPluginStart()
{
    public ConVar PluginEnabled = CreateConVar("sm_non_prime_kick_enabled", "1", "Whether the non-prime kick player plugin is enabled", FCVAR_PROTECTED, true, 0.0, true, 1.0);

    LoadTranslations("reset-score.phrases");
    HookConVarChange(PluginEnabled, PluginStatusChanged);
}

public void PluginStatusChanged(ConVar PluginEnabled, char[] oldValue, char[] newValue)
{
	int newVal = StringToInt(newValue);

    isPluginEnabled = newVal;
	if (newVal == 1) {
		LogMessage("%t", "PluginEnabledLog");
	}
	else
	{
		LogMessage("%t", "PluginDisabledLog");
	}
}

public void OnClientPostAdminCheck(int client)
{
    // If the plugin is disabled, skip premium check
    // If the user has BypassPremiumCheck, skip it
    if (isPluginEnabled == 0 || CheckCommandAccess(client, "BypassPremiumCheck", ADMFLAG_ROOT, true)) {
        return;
    }
    
    if (k_EUserHasLicenseResultDoesNotHaveLicense == SteamWorks_HasLicenseForApp(client, 624820))
    {
        KickClient(client, "%t", "KickReason");
    }
    return;
}