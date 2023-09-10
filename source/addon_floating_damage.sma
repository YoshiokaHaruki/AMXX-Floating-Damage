new const PluginName[ ] =					"[AMXX] Addon: Floating Damage";
new const PluginVersion[ ] =				"1.0.5";
new const PluginAuthor[ ] =					"Yoshioka Haruki";
new const PluginPrefix[ ] =					"Floating Damager";

/* ~ [ Includes ] ~ */
#include <amxmodx>
#include <fakemeta_util>
#include <xs>

/**
 * If ur server can't use Re modules, just disable (with //) or delete this line
 */
#include <reapi>

/**
 * Don't touch this 😡
 */
#if !defined _reapi_included
	#include <hamsandwich>
	#include <non_reapi_support>
#endif

/* ~ [ Plugin Settings ] ~ */
const MAX_BODY_PARTS =						4;
const MAX_SUBMODELS =						11;
const ASCII_ZERO =							48;
new const MAX_BODY_SUBMODELS[ MAX_BODY_PARTS ] = {
	MAX_SUBMODELS, ...
};

const Float: DamagerTestDistance =			512.0;
new const Float: DamagerTestDamages[ 2 ] = {
	// Default, HeadShot
	1234.0, 5678.0
};

/**
 * Whether to enable Damager for new players.
 * If you turn off this function, you need to go to the menu and turn it on yourself
 */
#define EnableDamagerForNewPlayers

/**
 * With the settings enabled, while Damager is flying up,
 * it will turn behind the player
 */
#define EnableDamagerRotation

/* ~ [ Entity: Floating Damager ] ~ */
new const EntityDamagerReference[ ] =		"info_target";
new const EntityDamagerClassName[ ] =		"ent_floating_damage";
new const EntityDamagerModel[ ] =			"models/x_re/floating_damage.mdl";
const Float: EntityDamagerNextThink =		0.05;
const Float: EntityDamagerAnimFrameRate =	0.33;
const EntityDamagerSkinsCount =				10;

/* ~ [ Params ] ~ */
#if AMXX_VERSION_NUM <= 182
	new MaxClients;
#endif

#if !defined _reapi_included
	new gl_iszAllocString_Damager;
#endif

new gl_bitsUserDamagerEnabled;
new gl_iUserDamagerSkin[ MAX_PLAYERS + 1 ];
new Float: gl_flUserTotalDamage[ MAX_PLAYERS + 1 ][ MAX_PLAYERS + 1 ];

/* ~ [ Macroses ] ~ */
#if !defined Vector3
	#define Vector3(%0)						Float: %0[ 3 ]
#endif

#if AMXX_VERSION_NUM <= 183
	#define MAX_MENU_LENGTH					512
#endif

#define BIT_PLAYER(%0)						( BIT( %0 - 1 ) )
#define BIT_ADD(%0,%1)						( %0 |= %1 )
#define BIT_SUB(%0,%1)						( %0 &= ~%1 )
#define BIT_VALID(%0,%1)					( %0 & %1 )
#define BIT_INVERT(%0,%1)					( %0 ^= %1 )

#define IsUserValid(%0)						bool: ( 0 < %0 <= MaxClients )
#define UserDamagerEnabled(%0)				( BIT_VALID( gl_bitsUserDamagerEnabled, BIT_PLAYER( %0 ) ) ? true : false )
#define SetFormatex(%0,%1,%2)				( %1 = formatex( %0, charsmax( %0 ), %2 ) )
#define AddFormatex(%0,%1,%2)				( %1 += formatex( %0[ %1 ], charsmax( %0 ) - %1, %2 ) )

// https://dev-cs.ru/threads/222/post-76443
#define register_cmd_list(%0,%1,%2)			for ( new i; i < sizeof %1; i++ ) register_%0( %1[ i ], %2 )

#define var_start_origin					var_vuser1
#define var_start_velocity					var_vuser2

/* ~ [ AMX Mod X ] ~ */
public plugin_natives( )
{
	register_native( "get_user_damager_status", "native_get_user_damager_status" );
	register_native( "set_user_damager_status", "native_set_user_damager_status" );
	register_native( "get_user_damager_skin", "native_get_user_damager_skin" );
	register_native( "set_user_damager_skin", "native_set_user_damager_skin" );
}

public plugin_precache( )
{
	/* -> Precache Models <- */
	engfunc( EngFunc_PrecacheModel, EntityDamagerModel );

#if !defined _reapi_included
	/* -> Alloc String <- */
	gl_iszAllocString_Damager = engfunc( EngFunc_AllocString, EntityDamagerClassName );
#endif
}

public plugin_init( )
{
	register_plugin( PluginName, PluginVersion, PluginAuthor );

#if defined _reapi_included
	/* -> ReGameDLL <- */
	RegisterHookChain( RG_CBasePlayer_TakeDamage, "CBasePlayer__TakeDamage_Post", true );
#else
	/* -> HamSandwich: Player <- */
	RegisterHam( Ham_TakeDamage, "player", "CBasePlayer__TakeDamage_Post", true );

	/* -> HamSandwich: Entity <- */
	RegisterHam( Ham_Think, EntityDamagerReference, "CEntity__Think_Post", true );
#endif

	/* -> Lang Files <- */
	register_dictionary( "floating_damage.txt" );

	/* -> Register Commands <- */
	new DamagerCommands[ ][ ] = {
		"damager", "say /damager", "say damager", "say_team /damager", "say_team damager"
	};

	register_cmd_list(clcmd, DamagerCommands, "ClientCommand__DamagerMenu" );

	/* -> Register Menus <- */
	register_menucmd( register_menuid( "MenuDamager_Show" ), ( MENU_KEY_0|MENU_KEY_1|MENU_KEY_2|MENU_KEY_3 ), "MenuDamager_Handler" );

	/* -> Other <- */
#if AMXX_VERSION_NUM <= 182
	#if defined _reapi_included
		MaxClients = get_member_game( m_nMaxPlayers );
	#else
		MaxClients = get_maxplayers( );
	#endif
#endif
}

public plugin_cfg( )
{
#if AMXX_VERSION_NUM <= 182
	register_cvar( "Floating_Damage_Version", PluginVersion, ( FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED ) );
#else
	create_cvar( "Floating_Damage_Version", PluginVersion, ( FCVAR_SERVER | FCVAR_SPONLY | FCVAR_UNLOGGED ) );
#endif
}

public client_putinserver( pPlayer )
{
#if defined EnableDamagerForNewPlayers
	BIT_ADD( gl_bitsUserDamagerEnabled, BIT_PLAYER( pPlayer ) );
#endif

#if !defined _reapi_included
	set_entvar( pPlayer, var_groupinfo, get_entvar( pPlayer, var_groupinfo ) | ( BIT( 0 )|BIT( pPlayer ) ) );
#endif
}

#if AMXX_VERSION_NUM < 183
	public client_disconnect( pPlayer )
#else
	public client_disconnected( pPlayer )
#endif
		BIT_SUB( gl_bitsUserDamagerEnabled, BIT_PLAYER( pPlayer ) );

public ClientCommand__DamagerMenu( const pPlayer )
{
	MenuDamager_Show( pPlayer );
	return PLUGIN_HANDLED;
}

/* ~ [ ReGameDLL ] ~ */
public CBasePlayer__TakeDamage_Post( const pVictim, const pInflictor, const pAttacker, const Float: flDamage )
{
	if ( !is_user_alive( pAttacker ) || pVictim == pAttacker || !UserDamagerEnabled( pAttacker ) )
		return;

	if ( get_member( pVictim, m_iTeam ) == get_member( pAttacker, m_iTeam ) )
		return;

	new Vector3( vecOrigin ); get_entvar( pVictim, var_origin, vecOrigin );
	gl_flUserTotalDamage[ pAttacker ][ pVictim ] += flDamage;

	CDamager__SpawnEntity( pAttacker, pVictim, vecOrigin, gl_flUserTotalDamage[ pAttacker ][ pVictim ], bool: ( get_member( pVictim, m_LastHitGroup ) == HIT_HEAD ) );
}

#if !defined _reapi_included
	/* ~ [ HamSandwich ] ~ */
	public CEntity__Think_Post( const pEntity )
	{
		if ( is_nullent( pEntity ) )
			return;

		if ( get_entvar( pEntity, var_impulse ) == gl_iszAllocString_Damager )
			CDamager__Think( pEntity );
	}
#endif

/* ~ [ Menus ] ~ */
public MenuDamager_Show( const pPlayer )
{
	if ( !is_user_connected( pPlayer ) )
		return;

	new szMenu[ MAX_MENU_LENGTH ], iLen;
	SetFormatex( szMenu, iLen, "%L^n^n", LANG_PLAYER, "ML_Damager_Menu_Title" );

	new bitsKeys = MENU_KEY_0|MENU_KEY_1|MENU_KEY_2|MENU_KEY_3;

	AddFormatex( szMenu, iLen, "\r1. \w%L: %L^n^n", LANG_PLAYER, "ML_Damager_Menu_Status", LANG_PLAYER, UserDamagerEnabled( pPlayer ) ? "ML_Damager_Status_On" : "ML_Damager_Status_Off" );

	AddFormatex( szMenu, iLen, "\r2. \w%L: \y%i^n", LANG_PLAYER, "ML_Damager_Menu_Skin", gl_iUserDamagerSkin[ pPlayer ] + 1 );

	if ( is_user_alive( pPlayer ) )
		AddFormatex( szMenu, iLen, "\r3. \w%L^n", LANG_PLAYER, "ML_Damager_Menu_Show" );
	else
		BIT_SUB( bitsKeys, MENU_KEY_3 );

	AddFormatex( szMenu, iLen, "^n\r0. \w%L", LANG_PLAYER, "ML_Damager_Menu_Exit" );

	set_member( pPlayer, m_iMenu, Menu_OFF );
	show_menu( pPlayer, bitsKeys, szMenu, -1, "MenuDamager_Show" );
}

public MenuDamager_Handler( const pPlayer, const iMenuKey )
{
	if ( !is_user_connected( pPlayer ) || iMenuKey == 9 )
	{
		UTIL_DestroyMenu( pPlayer );
		return;
	}

	switch ( iMenuKey )
	{
		case 0: {
			BIT_INVERT( gl_bitsUserDamagerEnabled, BIT_PLAYER( pPlayer ) );
		}
		case 1: {
			if ( ++gl_iUserDamagerSkin[ pPlayer ] && gl_iUserDamagerSkin[ pPlayer ] >= EntityDamagerSkinsCount )
				gl_iUserDamagerSkin[ pPlayer ] = 0;
		}
		case 2: {
			new Vector3( vecEyeLevel ); UTIL_GetEyePosition( pPlayer, vecEyeLevel );
			new Vector3( vecEndPos ); UTIL_GetVectorAiming( pPlayer, vecEndPos );

			xs_vec_add_scaled( vecEyeLevel, vecEndPos, DamagerTestDistance, vecEndPos );

			engfunc( EngFunc_TraceLine, vecEyeLevel, vecEndPos, DONT_IGNORE_MONSTERS, pPlayer, 0 );
			get_tr2( 0, TR_vecEndPos, vecEndPos );

			for ( new i = 0; i < 2; i++ )
				CDamager__SpawnEntity( pPlayer, NULLENT, vecEndPos, DamagerTestDamages[ i ], bool: i );
		}
	}

	MenuDamager_Show( pPlayer );
}

/* ~ [ Other ] ~ */
public CDamager__SpawnEntity( const pPlayer, const pVictim, Vector3( vecOrigin ), const Float: flDamage, const bool: bHeadShot )
{
	new iDamagerSkin = gl_iUserDamagerSkin[ pPlayer ];
	if ( iDamagerSkin != 0 ) iDamagerSkin *= 2;
	if ( bHeadShot ) iDamagerSkin += 1;

	new pEntity = CDamager__FindActiveEntity( pPlayer, pVictim );
	if ( pEntity != NULLENT )
	{
		get_entvar( pEntity, var_start_origin, vecOrigin );
		engfunc( EngFunc_SetOrigin, pEntity, vecOrigin );

		get_entvar( pEntity, var_start_velocity, vecOrigin );
		set_entvar( pEntity, var_velocity, vecOrigin );

		set_entvar( pEntity, var_sequence, 0 );
		set_entvar( pEntity, var_renderamt, 255.0 );
		set_entvar( pEntity, var_nextthink, get_gametime( ) + 0.3 );
		set_entvar( pEntity, var_skin, iDamagerSkin );
		set_entvar( pEntity, var_body, CDamager__PrepareBody( flDamage ) );

		return pEntity;
	}

	pEntity = rg_create_entity( EntityDamagerReference );
	if ( is_nullent( pEntity ) )
		return NULLENT;

	vecOrigin[ 0 ] += random_float( -32.0, 32.0 );
	vecOrigin[ 1 ] += random_float( -32.0, 32.0 );
	vecOrigin[ 2 ] += 16.0;
	new Vector3( vecTemp ); xs_vec_copy( vecOrigin, vecTemp );

	new Vector3( vecVelocity ); vecTemp[ 2 ] += 64.0;
	UTIL_GetSpeedVector( vecOrigin, vecTemp, _, 1.0, vecVelocity );
	set_entvar( pEntity, var_velocity, vecVelocity );

	engfunc( EngFunc_SetOrigin, pEntity, vecOrigin );
	engfunc( EngFunc_SetModel, pEntity, EntityDamagerModel );

#if !defined _reapi_included
	set_entvar( pEntity, var_impulse, gl_iszAllocString_Damager );
#endif

	set_entvar( pEntity, var_classname, EntityDamagerClassName );
	set_entvar( pEntity, var_solid, SOLID_NOT );
	set_entvar( pEntity, var_movetype, MOVETYPE_NOCLIP );
	set_entvar( pEntity, var_owner, pPlayer );
	set_entvar( pEntity, var_playerclass, pVictim );
	set_entvar( pEntity, var_skin, iDamagerSkin );
	set_entvar( pEntity, var_body, CDamager__PrepareBody( flDamage ) );

	// Cache vars
	set_entvar( pEntity, var_start_origin, vecOrigin );
	set_entvar( pEntity, var_start_velocity, vecVelocity );

#if defined _reapi_included
	set_entvar( pEntity, var_effects, get_entvar( pEntity, var_effects ) | EF_OWNER_VISIBILITY );
#else
	set_entvar( pEntity, var_groupinfo, BIT( pPlayer ) );
#endif

	get_entvar( pPlayer, var_v_angle, vecTemp );

	vecTemp[ 1 ] -= 180.0;
	set_entvar( pEntity, var_angles, vecTemp );

#if defined _reapi_included
	SetThink( pEntity, "CDamager__Think" );
#endif

	set_entvar( pEntity, var_nextthink, get_gametime( ) + 0.3 );

	UTIL_SetEntityRendering( pEntity, _, _, kRenderTransAdd, 255.0 );

	return pEntity;
}

public CDamager__FindActiveEntity( const pPlayer, const pVictim )
{
	if ( !IsUserValid( pVictim ) )
		return NULLENT;

	if ( gl_flUserTotalDamage[ pPlayer ][ pVictim ] <= 0.0 )
		return NULLENT;

	new pEntity = MaxClients;
	while ( ( pEntity = fm_find_ent_by_class( pEntity, EntityDamagerClassName ) ) > 0 )
	{
		if ( get_entvar( pEntity, var_owner ) != pPlayer )
			continue;

		if ( get_entvar( pEntity, var_playerclass ) != pVictim )
			continue;

		return pEntity;
	}

	return NULLENT;
}

public CDamager__Think( const pEntity )
{
	static pOwner; pOwner = get_entvar( pEntity, var_owner );

#if defined EnableDamagerRotation
	static Vector3( vecAngles ); get_entvar( pOwner, var_v_angle, vecAngles );

	vecAngles[ 1 ] -= 180.0;
	set_entvar( pEntity, var_angles, vecAngles );
#endif

	if ( get_entvar( pEntity, var_sequence ) != 1 )
		UTIL_SetEntityAnim( pEntity, 1, .flFrameRate = Float: EntityDamagerAnimFrameRate );

	static Float: flRenderAmt; get_entvar( pEntity, var_renderamt, flRenderAmt );
	if ( ( flRenderAmt -= 15.0 ) && flRenderAmt <= 15.0 )
	{
		static pVictim; pVictim = get_entvar( pEntity, var_playerclass );

		if ( IsUserValid( pVictim ) )
			gl_flUserTotalDamage[ pOwner ][ pVictim ] = 0.0;

		UTIL_KillEntity( pEntity );
		return;
	}

	set_entvar( pEntity, var_renderamt, flRenderAmt );
	set_entvar( pEntity, var_nextthink, get_gametime( ) + Float: EntityDamagerNextThink );
}

public CDamager__PrepareBody( Float: flDamage )
{
	flDamage = floatmin( flDamage, 9999.0 );

	new szDamage[ MAX_BODY_PARTS + 1 ], aParts[ MAX_BODY_PARTS ]
	for ( new i, j = num_to_str( floatround( flDamage ), szDamage, charsmax( szDamage ) ); i < j; i++ )
		aParts[ i ] = ++szDamage[ i ] - ASCII_ZERO;

	return CalculateModelBodyArr( aParts, MAX_BODY_SUBMODELS, MAX_BODY_PARTS );
}

/* ~ [ Natives ] ~ */
public bool: native_get_user_damager_status( const iPlugin, const iParams )
{
	enum { arg_player = 1 };

	new pPlayer = get_param( arg_player );
	if ( !is_user_connected( pPlayer ) )
	{
		log_error( AMX_ERR_NATIVE, "[%s] Invalid Player (%i)", PluginPrefix, pPlayer );
		return false;
	}

	return bool: UserDamagerEnabled( pPlayer );
}

public bool: native_set_user_damager_status( const iPlugin, const iParams )
{
	enum { arg_player = 1, arg_value };

	new pPlayer = get_param( arg_player );
	if ( !is_user_connected( pPlayer ) )
	{
		log_error( AMX_ERR_NATIVE, "[%s] Invalid Player (%i)", PluginPrefix, pPlayer );
		return false;
	}

	new bool: bValue = bool: get_param( arg_value );
	bValue ? BIT_ADD( gl_bitsUserDamagerEnabled, BIT_PLAYER( pPlayer ) ) : BIT_SUB( gl_bitsUserDamagerEnabled, BIT_PLAYER( pPlayer ) );

	return true;
}

public native_get_user_damager_skin( const iPlugin, const iParams )
{
	enum { arg_player = 1 };

	new pPlayer = get_param( arg_player );
	if ( !is_user_connected( pPlayer ) )
	{
		log_error( AMX_ERR_NATIVE, "[%s] Invalid Player (%i)", PluginPrefix, pPlayer );
		return -1;
	}

	return gl_iUserDamagerSkin[ pPlayer ];
}

public bool: native_set_user_damager_skin( const iPlugin, const iParams )
{
	enum { arg_player = 1, arg_value };

	new pPlayer = get_param( arg_player );
	if ( !is_user_connected( pPlayer ) )
	{
		log_error( AMX_ERR_NATIVE, "[%s] Invalid Player (%i)", PluginPrefix, pPlayer );
		return false;
	}

	gl_iUserDamagerSkin[ pPlayer ] = clamp( get_param( arg_value ), 0, ( EntityDamagerSkinsCount - 1 ) );
	return true;
}

/* ~ [ Stocks ] ~ */
// https://dev-cs.ru/threads/222/page-7#post-77015
stock CalculateModelBodyArr( const parts[ ], const sizes[ ], const count )
{
	static bodyInt32, temp, it, tempCount; bodyInt32 = 0; tempCount = count;
	while ( tempCount-- )
	{
		if ( sizes[ tempCount ] == 1 )
			continue;

		temp = parts[ tempCount ];
		for ( it = 0; it < tempCount; it++ )
			temp *= sizes[it];

		bodyInt32 += temp;
	}
	return bodyInt32;
}

/* -> Destroy Menu <- */
stock UTIL_DestroyMenu( const pPlayer )
{
	show_menu( pPlayer, 0, "^n", 1 );
	menu_cancel( pPlayer );
}

/* -> Destroy Entity <- */
stock UTIL_KillEntity( const pEntity )
{
	set_entvar( pEntity, var_flags, FL_KILLME );
	set_entvar( pEntity, var_nextthink, get_gametime( ) );
}

/* -> Set Entity Animation <- */
stock UTIL_SetEntityAnim( const pEntity, const iSequence = 0, const Float: flFrame = 0.0, const Float: flFrameRate = 1.0 )
{
	set_entvar( pEntity, var_frame, flFrame );
	set_entvar( pEntity, var_framerate, flFrameRate );
	set_entvar( pEntity, var_animtime, get_gametime( ) );
	set_entvar( pEntity, var_sequence, iSequence );
}

/* -> Set Entity Rendering <- */
stock UTIL_SetEntityRendering( const pEntity, const iRenderFx = kRenderFxNone, const Float: flRenderColor[ 3 ] = { 255.0, 255.0, 255.0 }, const iRenderMode = kRenderNormal, const Float: flRenderAmount = 16.0 )
{
	set_entvar( pEntity, var_renderfx, iRenderFx );
	set_entvar( pEntity, var_rendercolor, flRenderColor );
	set_entvar( pEntity, var_rendermode, iRenderMode );
	set_entvar( pEntity, var_renderamt, flRenderAmount );
}

/* -> Get speed Vector to 2 points <- */
stock UTIL_GetSpeedVector( const Vector3( vecStartOrigin ), const Vector3( vecEndOrigin ), Float: flSpeed = 0.0, Float: flTime = 1.0, Vector3( vecVelocity ) )
{
	if ( !flSpeed )
		flSpeed = xs_vec_distance( vecStartOrigin, vecEndOrigin ) / flTime;
	else flSpeed /= flTime;

	xs_vec_sub( vecEndOrigin, vecStartOrigin, vecVelocity );
	xs_vec_normalize( vecVelocity, vecVelocity );
	xs_vec_mul_scalar( vecVelocity, flSpeed, vecVelocity );
}

/* -> Get player eye position <- */
stock UTIL_GetEyePosition( const pPlayer, Vector3( vecEyeLevel ) )
{
	static Vector3( vecOrigin ); get_entvar( pPlayer, var_origin, vecOrigin );
	static Vector3( vecViewOfs ); get_entvar( pPlayer, var_view_ofs, vecViewOfs );

	xs_vec_add( vecOrigin, vecViewOfs, vecEyeLevel );
}

/* -> Get player aiming <- */
stock UTIL_GetVectorAiming( const pPlayer, Vector3( vecAiming ) ) 
{
	static Vector3( vecViewAngle ); get_entvar( pPlayer, var_v_angle, vecViewAngle );
	static Vector3( vecPunchAngle ); get_entvar( pPlayer, var_punchangle, vecPunchAngle );

	xs_vec_add( vecViewAngle, vecPunchAngle, vecViewAngle );
	angle_vector( vecViewAngle, ANGLEVECTOR_FORWARD, vecAiming );
}
