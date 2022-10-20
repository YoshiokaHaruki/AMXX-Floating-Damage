#if defined _non_reapi_support_included
	#endinput
#endif
#define _non_reapi_support_included

/**
 * ReAPI support for Non-ReAPI servers
 * 
 * This file created by Yoshioka Haruki (xUnicorn a.k.a t3rkecorejz)
 * It's not final version of this include, new features will be added over time
 * 
 * Latest update: 20.10.2022
 */

#if !defined _fakemeta_util_included
	#include <fakemeta_util>
#endif

#if !defined _hamsandwich_included
	#include <hamsandwich>
#endif

/* ~ [ Consts ] ~ */
#define NULLENT								FM_NULLENT
#define PDATA_SAFE							2
#define MAX_ITEM_TYPES						6
#define ACT_RANGE_ATTACK1					28

#if AMXX_VERSION_NUM <= 182
	#define MAX_PLAYERS						32
	#define MAX_NAME_LENGTH					32
#endif

#define DEFAULT_LARGE_AWP_ZOOM				10
#define DEFAULT_LARGE_OTHER_SNIPERS_ZOOM	15
#define DEFAULT_SMALL_SNIPERS_ZOOM			40
#define DEFAULT_AUG_SG552_ZOOM				55
#define DEFAULT_NO_ZOOM						90

enum _Menu
{
	Menu_OFF,
	Menu_ChooseTeam,
	Menu_IGChooseTeam,
	Menu_ChooseAppearance,
	Menu_Buy,
	Menu_BuyPistol,
	Menu_BuyRifle,
	Menu_BuyMachineGun,
	Menu_BuyShotgun,
	Menu_BuySubMachineGun,
	Menu_BuyItem,
	Menu_Radio1,
	Menu_Radio2,
	Menu_Radio3,
	Menu_ClientBuy
};

/* ~ [ Macroses ] ~ */
#define BIT(%0)								( 1<<( %0 ) )
#define is_nullent(%0)						( %0 == NULLENT || pev_valid( %0 ) != PDATA_SAFE )
#define rg_create_entity(%0)				fm_create_entity( %0 )

/* ~ [ EntVars ] ~ */
#define set_entvar							set_pev
#define get_entvar							pev

#define var_classname						pev_classname
#define var_globalname						pev_globalname
#define var_origin							pev_origin
#define var_oldorigin						pev_oldorigin
#define var_velocity						pev_velocity
#define var_basevelocity					pev_basevelocity
#define var_clbasevelocity					pev_clbasevelocity
#define var_movedir							pev_movedir
#define var_angles							pev_angles
#define var_avelocity						pev_avelocity
#define var_punchangle						pev_punchangle
#define var_v_angle							pev_v_angle
#define var_endpos							pev_endpos
#define var_startpos						pev_startpos
#define var_impacttime						pev_impacttime
#define var_starttime						pev_starttime
#define var_fixangle						pev_fixangle
#define var_idealpitch						pev_idealpitch
#define var_pitch_speed						pev_pitch_speed
#define var_ideal_yaw						pev_ideal_yaw
#define var_yaw_speed						pev_yaw_speed
#define var_modelindex						pev_modelindex
#define var_model							pev_model
#define var_viewmodel						pev_viewmodel2
#define var_weaponmodel						pev_weaponmodel2
#define var_absmin							pev_absmin
#define var_absmax							pev_absmax
#define var_mins							pev_mins
#define var_maxs							pev_maxs
#define var_size							pev_size
#define var_ltime							pev_ltime
#define var_nextthink						pev_nextthink
#define var_movetype						pev_movetype
#define var_solid							pev_solid
#define var_skin							pev_skin
#define var_body							pev_body
#define var_effects							pev_effects
#define var_gravity							pev_gravity
#define var_friction						pev_friction
#define var_light_level						pev_light_level
#define var_sequence						pev_sequence
#define var_gaitsequence					pev_gaitsequence
#define var_frame							pev_frame
#define var_animtime						pev_animtime
#define var_framerate						pev_framerate
#define var_controller						pev_controller
#define var_blending						pev_blending
#define var_scale							pev_scale
#define var_rendermode						pev_rendermode
#define var_renderamt						pev_renderamt
#define var_rendercolor						pev_rendercolor
#define var_renderfx						pev_renderfx
#define var_health							pev_health
#define var_frags							pev_frags
#define var_weapons							pev_weapons
#define var_takedamage						pev_takedamage
#define var_deadflag						pev_deadflag
#define var_view_ofs						pev_view_ofs
#define var_button							pev_button
#define var_impulse							pev_impulse
#define var_chain							pev_chain
#define var_dmg_inflictor					pev_dmg_inflictor
#define var_enemy							pev_enemy
#define var_aiment							pev_aiment
#define var_owner							pev_owner
#define var_groundentity					pev_groundentity
#define var_spawnflags						pev_spawnflags
#define var_flags							pev_flags
#define var_colormap						pev_colormap
#define var_team							pev_team
#define var_max_health						pev_max_health
#define var_teleport_time					pev_teleport_time
#define var_armortype						pev_armortype
#define var_armorvalue						pev_armorvalue
#define var_waterlevel						pev_waterlevel
#define var_watertype						pev_watertype
#define var_target							pev_target
#define var_targetname						pev_targetname
#define var_netname							pev_netname
#define var_message							pev_message
#define var_dmg_take						pev_dmg_take
#define var_dmg_save						pev_dmg_save
#define var_dmg								pev_dmg
#define var_dmgtime							pev_dmgtime
#define var_noise							pev_noise
#define var_noise1							pev_noise1
#define var_noise2							pev_noise2
#define var_noise3							pev_noise3
#define var_speed							pev_speed
#define var_air_finished					pev_air_finished
#define var_pain_finished					pev_pain_finished
#define var_radsuit_finished				pev_radsuit_finished
#define var_pContainingEntity				pev_pContainingEntity
#define var_playerclass						pev_playerclass
#define var_maxspeed						pev_maxspeed
#define var_fov								pev_fov
#define var_weaponanim						pev_weaponanim
#define var_pushmsec						pev_pushmsec
#define var_bInDuck							pev_bInDuck
#define var_flTimeStepSound					pev_flTimeStepSound
#define var_flSwimTime						pev_flSwimTime
#define var_flDuckTime						pev_flDuckTime
#define var_iStepLeft						pev_iStepLeft
#define var_flFallVelocity					pev_flFallVelocity
#define var_gamestate						pev_gamestate
#define var_oldbuttons						pev_oldbuttons
#define var_groupinfo						pev_groupinfo
#define var_iuser1							pev_iuser1
#define var_iuser2							pev_iuser2
#define var_iuser3							pev_iuser3
#define var_iuser4							pev_iuser4
#define var_fuser1							pev_fuser1
#define var_fuser2							pev_fuser2
#define var_fuser3							pev_fuser3
#define var_fuser4							pev_fuser4
#define var_vuser1							pev_vuser1
#define var_vuser2							pev_vuser2
#define var_vuser3							pev_vuser3
#define var_vuser4							pev_vuser4
#define var_euser1							pev_euser1
#define var_euser2							pev_euser2
#define var_euser3							pev_euser3
#define var_euser4							pev_euser4

/* ~ [ Offset's ] ~ */
#define linux_diff_weapon					4
#define linux_diff_animating				4
#define linux_diff_player					5

#define m_WeaponBox_rgpPlayerItems			34
#define m_flFrameRate						36
#define m_flGroundSpeed						37
#define m_flLastEventCheck					38
#define m_fSequenceFinished					39
#define m_fSequenceLoops					40
#define m_pPlayer							41
#define m_pNext								42
#define m_iId								43
#define m_Weapon_flNextPrimaryAttack		46
#define m_Weapon_flNextSecondaryAttack		47
#define m_Weapon_flTimeWeaponIdle			48
#define m_Weapon_iPrimaryAmmoType			49
#define m_Weapon_iClip						51
#define m_Weapon_fInReload					54
#define m_Weapon_iDirection					60
#define m_Weapon_flAccuracy					62
#define m_Weapon_flLastFire					63
#define m_Weapon_iShotsFired				64
#define m_Weapon_iGlock18ShotsFired			70
#define m_Activity							73
#define m_IdealActivity						74
#define m_Weapon_iWeaponState				74
#define m_Weapon_flNextReload				75
#define m_LastHitGroup						75
#define m_Weapon_flDecreaseShotsFired		76
#define m_flNextAttack						83
#define m_flVelocityModifier				108
#define m_iTeam								114
#define m_iMenu								205
#define m_flLastFired						220
#define m_iFOV								363
#define m_rgpPlayerItems					367
#define m_pActiveItem						373
#define m_rgAmmo							376
#define m_szAnimExtention					492

/* ~ [ Natives to stocks ] ~ */
stock set_member( const pEntity, const any: mOffset, const any: iValue, const any: iExtraValue = 0 )
{
	if ( is_nullent( pEntity ) )
		return;

	if ( 0 < pEntity <= 32 ) 
	{
		switch ( mOffset )
		{
			// Int Player
			case m_rgAmmo, m_LastHitGroup, m_Activity, m_IdealActivity, m_iFOV, m_iTeam, m_iMenu: {
				set_pdata_int( pEntity, mOffset + iExtraValue, iValue, linux_diff_player );
			}
			// Float Player
			case m_flNextAttack, m_flVelocityModifier, m_flLastFired: {
				set_pdata_float( pEntity, mOffset + iExtraValue, iValue, linux_diff_player );
			}
			// Animation: Float Player
			case m_flFrameRate, m_flGroundSpeed, m_flLastEventCheck: {
				set_pdata_float( pEntity, mOffset + iExtraValue, iValue, linux_diff_animating );
			}
			// Animation: Int Player
			case m_fSequenceLoops, m_fSequenceFinished: {
				set_pdata_int( pEntity, mOffset + iExtraValue, iValue, linux_diff_animating );
			}
		}
	}
	else
	{
		switch ( mOffset )
		{
			// Int Weapon
			case m_Weapon_iGlock18ShotsFired, m_Weapon_iPrimaryAmmoType, m_Weapon_iWeaponState, m_Weapon_iClip, m_Weapon_iShotsFired, m_Weapon_fInReload, m_Weapon_iDirection: {
				set_pdata_int( pEntity, mOffset + iExtraValue, iValue, linux_diff_weapon );
			}
			// Float Weapon
			case m_Weapon_flTimeWeaponIdle, m_Weapon_flNextPrimaryAttack, m_Weapon_flNextSecondaryAttack, m_Weapon_flDecreaseShotsFired, m_Weapon_flAccuracy, m_Weapon_flLastFire, m_flLastEventCheck, m_Weapon_flNextReload: {
				set_pdata_float( pEntity, mOffset + iExtraValue, iValue, linux_diff_weapon );
			}
		}
	}
}

stock any: get_member( const pEntity, const any: mOffset, const any: iExtraValue = 0 )
{
	if ( is_nullent( pEntity ) )
		return -1;

	if ( 0 < pEntity <= 32 ) 
	{
		switch ( mOffset )
		{
			// Int Player
			case m_LastHitGroup, m_iTeam, m_iMenu, m_rgAmmo, m_iFOV: {
				return get_pdata_int( pEntity, mOffset + iExtraValue, linux_diff_player );
			}
			// CBase Player
			case m_pActiveItem, m_rgpPlayerItems: {
				return get_pdata_cbase( pEntity, mOffset + iExtraValue, linux_diff_player );
			}
		}
	}
	else
	{
		switch ( mOffset )
		{
			// Int Weapon
			case m_iId, m_Weapon_iGlock18ShotsFired, m_Weapon_iWeaponState, m_Weapon_iPrimaryAmmoType, m_Weapon_iClip, m_Weapon_iShotsFired, m_Weapon_fInReload, m_Weapon_iDirection: {
				return get_pdata_int( pEntity, mOffset + iExtraValue, linux_diff_weapon );
			}
			// Float Weapon
			case m_Weapon_flTimeWeaponIdle, m_Weapon_flNextSecondaryAttack, m_Weapon_flDecreaseShotsFired, m_flLastEventCheck, m_Weapon_flNextReload: {
				return Float: get_pdata_float( pEntity, mOffset + iExtraValue, linux_diff_weapon );
			}
			// CBase Weapon
			case m_WeaponBox_rgpPlayerItems, m_pPlayer, m_pNext: {
				return get_pdata_cbase( pEntity, mOffset + iExtraValue, linux_diff_weapon );
			}
		}
	}

	return -1;
}

stock FClassnameIs( const pEntity, const szClassName[ ] )
{
	static szBuffer[ MAX_NAME_LENGTH ];
	get_entvar( pEntity, var_classname, szBuffer, charsmax( szBuffer ) );

	return equal( szClassName, szBuffer );
}

stock bool: rh_emit_sound2( const pEntity, const pRecipient, const iChannel, const szSample[ ], Float: flVolume = VOL_NORM, Float: flAttenuation = ATTN_NORM, const bitsFlags = 0, const iPitch = PITCH_NORM, bitsEmitFlags = 0, const Float: vecOrigin[ 3 ] = { 0.0, 0.0, 0.0 } )
{
	#pragma unused pRecipient, bitsEmitFlags, vecOrigin
	
	if ( is_nullent( pEntity ) )
		return false;

	emit_sound( pEntity, iChannel, szSample, flVolume, flAttenuation, bitsFlags, iPitch );
	return true;
}

enum GiveType
{
	GT_APPEND,          // Just give item
	GT_REPLACE,         // Give the item and remove all other weapons from the slot
	GT_DROP_AND_REPLACE // Give the item and drop all other weapons from the slot
};

stock rg_give_item( const pPlayer, const szItemName[ ], GiveType: iGiveType = GT_APPEND )
{
	if ( !is_user_alive( pPlayer ) )
		return NULLENT;

	new pItem = rg_give_custom_item( pPlayer, szItemName, iGiveType );
	if ( is_nullent( pItem ) )
		return NULLENT;

	return pItem;
}

stock rg_give_custom_item( const pPlayer, const szItemName[ ], GiveType: iGiveType = GT_APPEND, const iWeaponUId = 0 )
{
	if ( !is_user_alive( pPlayer ) )
		return NULLENT;

	new pItem = fm_create_entity( szItemName );
	if ( is_nullent( pItem ) )
		return NULLENT;

	set_entvar( pItem, var_impulse, iWeaponUId );
	ExecuteHam( Ham_Spawn, pItem );

	if ( iGiveType == GT_DROP_AND_REPLACE )
		rg_drop_items_by_slot( pPlayer, InventorySlotType: ExecuteHamB( Ham_Item_ItemSlot, pItem ) );
	else if ( iGiveType == GT_REPLACE )
		rg_remove_items_by_slot( pPlayer, InventorySlotType: ExecuteHamB( Ham_Item_ItemSlot, pItem ) );

	if ( !ExecuteHamB( Ham_AddPlayerItem, pPlayer, pItem ) )
	{
		set_entvar( pItem, var_flags, FL_KILLME );
		set_entvar( pItem, var_nextthink, get_gametime( ) );

		return NULLENT;
	}
	
	ExecuteHamB( Ham_Item_AttachToPlayer, pItem, pPlayer );
	rh_emit_sound2( pPlayer, 0, CHAN_ITEM, "items/gunpickup2.wav" );

	return pItem;
}

enum InventorySlotType {
	NONE_SLOT,
	PRIMARY_WEAPON_SLOT,
	PISTOL_SLOT,
	KNIFE_SLOT,
	GRENADE_SLOT,
	C4_SLOT,
};

stock rg_drop_items_by_slot( const pPlayer, const InventorySlotType: iSlot )
{
	new pItem, szWeaponName[ MAX_NAME_LENGTH ];
	pItem = get_member( pPlayer, m_rgpPlayerItems, iSlot );
	while ( !is_nullent( pItem ) )
	{
		get_entvar( pItem, var_classname, szWeaponName, charsmax( szWeaponName ) );
		engclient_cmd( pPlayer, "drop", szWeaponName );

		pItem = get_member( pItem, m_pNext );
	}
}

stock rg_remove_items_by_slot( const pPlayer, const InventorySlotType: iSlot )
{
	if ( !is_user_alive( pPlayer ) )
		return false;

	if ( iSlot == C4_SLOT )
		CBasePlayer_RemovePlayerItemEx( pPlayer, "weapon_c4" );
	else
	{
		new pItem, szWeaponName[ MAX_NAME_LENGTH ];
		pItem = get_member( pPlayer, m_rgpPlayerItems, iSlot );
		while ( !is_nullent( pItem ) )
		{
			get_entvar( pItem, var_classname, szWeaponName, charsmax( szWeaponName ) );
			CBasePlayer_RemovePlayerItemEx( pPlayer, szWeaponName );

			pItem = get_member( pItem, m_pNext );
		}
	}

	return true;
}

// https://github.com/s1lentq/ReGameDLL_CS/blob/b9cccc691bdabbf9cb573be8ee5e39c9a4f70c4a/regamedll/dlls/API/CSPlayer.cpp#L135
stock bool: CBasePlayer_RemovePlayerItemEx( const pPlayer, const szItemName[ ] )
{
	if ( !is_user_alive( pPlayer ) )
		return false;

	if ( szItemName[ 0 ] == EOS )
		return false;

	new pItem = UTIL_GetItemByName( pPlayer, szItemName );
	if ( is_nullent( pItem ) )
		return false;

	if ( pItem == get_member( pPlayer, m_pActiveItem ) )
		ExecuteHamB( Ham_Weapon_RetireWeapon, pItem );

	if ( !ExecuteHamB( Ham_RemovePlayerItem, pPlayer, pItem ) )
		return false;

	ExecuteHamB( Ham_Item_Kill, pItem );
	set_member( pPlayer, m_rgAmmo, 0, get_member( pItem, m_Weapon_iPrimaryAmmoType ) );
	set_entvar( pPlayer, var_weapons, get_entvar( pPlayer, var_weapons ) & ~( 1<<( get_member( pItem, m_iId ) ) ) );

	return true;
}

stock UTIL_GetItemByName( const pPlayer, const szItemName[ ] )
{
	for ( new i, pItem = NULLENT; i < MAX_ITEM_TYPES; i++ )
	{
		pItem = get_member( pPlayer, m_rgpPlayerItems, i );
		while ( !is_nullent( pItem ) )
		{
			if ( FClassnameIs( pItem, szItemName ) )
				return pItem;

			pItem = get_member( pItem, m_pNext );
		}
	}
	return -1;
}