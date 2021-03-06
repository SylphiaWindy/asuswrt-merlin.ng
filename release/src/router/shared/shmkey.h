
/* asuswrt shm keys */
#define SHMKEY_LAN      1001
#ifdef RTCONFIG_BONJOUR
#define SHMKEY_BONJOUR  1002
#endif
#ifdef RTCONFIG_TAGGED_BASED_VLAN
#define SHMKEY_VLAN1    1003
#define SHMKEY_VLAN2    1004
#define SHMKEY_VLAN3    1005
#define SHMKEY_VLAN4    1006
#define SHMKEY_VLAN5    1007
#define SHMKEY_VLAN6    1008
#define SHMKEY_VLAN7    1009
#define SHMKEY_VLAN8    1010
#endif
#ifdef RTCONFIG_CAPTIVE_PORTAL
#define SHMKEY_FREEWIFI 1011
#define SHMKEY_CP       1012
#endif

#define KEY_SHM_CFG	2001

#define SHMKEY_AMASDB	3001
#define SHMKEY_AMASDB_ALL	3002

#define KEY_WLC_EVENT 		30583
#define KEY_TG_ROAMING_EVENT 	34951
#define KEY_ROAMING_EVENT 	34952

