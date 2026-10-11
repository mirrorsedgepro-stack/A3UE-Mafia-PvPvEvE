class Templates 
{
    class Vanilla_Base;

    // The Mafia as the faction the players fight for (pick it as the rebel faction of a new campaign).
    class Vanilla_Mafia : Vanilla_Base
    {
        basepath = QPATHTOFOLDER(Templates\Vanilla);
        side = "Reb";
        flagTexture = "a3\data_f\flags\flag_altis_co.paa";
        name = "The Mafia Syndicate";
        file = "Vanilla_Reb_Mafia";
        maps[] = {};
        climate[] = {"arid", "arctic", "temperate", "tropical"};
        description = "A crime family grasping for power across the island, starting out with handguns, revolvers and SMGs.";
    };

    // The Mafia as Antistasi Ultimate's rival faction (pick it as the rivals of a new campaign).
    class Vanilla_Riv_Mafia : Vanilla_Base
    {
        basepath = QPATHTOFOLDER(Templates\Vanilla);
        side = "Riv";
        flagTexture = "\A3\Data_F\Flags\Flag_red_CO.paa";
        name = "The Mafia Syndicate (rivals)";
        file = "Vanilla_Riv_Mafia";
        maps[] = {};
        climate[] = {"arid", "arctic", "temperate", "tropical"};
        description = "Don Salvatore's crime family as the rival faction: an AI syndicate that fights the rebels for the island.";
    };
};
