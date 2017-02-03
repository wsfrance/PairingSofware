/* fetch physical address (MAC) and ip address */
#include <windows.h>
//#include <winbase.h>
#include <stdio.h>
#include <tchar.h>
#include <lm.h>
#include "mex.h"

/* Include necessary libraries in source file instead of linking commands */
#pragma comment(lib, "Netapi32.lib")
#pragma comment(lib, "wsock32.lib")
#pragma comment(lib, "advapi32.lib")

/* physical address MAC */
static void GetMACaddress(void)
{
    /* storage for MAC */
	unsigned char MACAdd[6];						

	WKSTA_TRANSPORT_INFO_0 *NetPtr;					// Allocate data structure for Netbios
	DWORD dwEnumRead;
	DWORD dwTotalEnum;
	BYTE *Buffer;
	DWORD i;
    LPWSTR server = NULL;                  // may add server name   
	
	NET_API_STATUS dwStatus = NetWkstaTransportEnum(
		server,						
		0,							
		&Buffer,					
		MAX_PREFERRED_LENGTH,		
		&dwEnumRead,				
		&dwTotalEnum,			
		NULL);						

	NetPtr = (WKSTA_TRANSPORT_INFO_0 *)Buffer;	

	for(i=1; i< dwEnumRead; i++)		
	{												
	    /* Other data may be extracted from NetPtr structure, such as QoS and # of connections */
		swscanf((wchar_t *)NetPtr[i].wkti0_transport_address, L"%2hx%2hx%2hx%2hx%2hx%2hx", 
			&MACAdd[0], &MACAdd[1], &MACAdd[2], &MACAdd[3], &MACAdd[4], &MACAdd[5]);
    	printf("MAC Address: %02X-%02X-%02X-%02X-%02X-%02X", 
		MACAdd[0], MACAdd[1], MACAdd[2], MACAdd[3], MACAdd[4], MACAdd[5]);
		/* No. of clients using this protocol */
		// printf("# of connections %u", NetPtr[i].wkti0_number_of_vcs);
	}
    printf("\n");
	/* Release memory  */
	dwStatus = NetApiBufferFree(Buffer);
}

void GetIp()
{
	char HostName[255];
	char *ip;
	int i;
	PHOSTENT HostInfo;
	WORD wVersionRequested = MAKEWORD(1,1);
	WSADATA wsaData;
	
	/* socket error handling added */
	if ( WSAStartup( wVersionRequested, &wsaData ) == 0 )
		if( gethostname ( HostName, sizeof(HostName)) == 0)
		{
			if((HostInfo = gethostbyname(HostName)) != NULL)
			{
				i = 0;
				while(HostInfo->h_addr_list[i])
				{
					ip = inet_ntoa (*(struct in_addr *)HostInfo->h_addr_list[i]);
					++i;
					printf("IP Address: %s\n", ip);
				}
			}			
			printf("Host name: %s\n", HostName);
		}
}

/* Network ID fetching */
void GetID()
{
    char Buffer[128];
    DWORD len = sizeof(Buffer) - 1;
    
    if ( GetUserName(Buffer, &len) == 0 ) {
        fprintf(stderr, "Error from calling function GetUserName %d\n", GetLastError());
    }
    else 
        printf("User Name: %s\n", Buffer);
   if ( GetComputerName(Buffer, &len) == 0) {
        fprintf(stderr, "Error from calling function GetComputerName %d\n", GetLastError());
    }
    else
        printf("Computer Name: %s\n", Buffer); 
}

/* the gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
                  int nrhs, const mxArray *prhs[])
{
    GetMACaddress();
    GetIp();
    GetID();
}
