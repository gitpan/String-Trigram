#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "ppport.h"
#include <math.h>
#include <malloc.h>
#include <stdio.h>

double _computeActSim(int sameTrigs,
		   int allTrigs,
		   double warp) {

	return 1 - pow ((allTrigs - sameTrigs)/(double)allTrigs, warp);
}

//void XS_pack_charPtrPtr(SV * arg, char ** array, int count) {
//     int i;
//     AV * avref;
//
//     avref = (AV*)sv_2mortal((SV*)newAV());
//     for (i = 0; i < count; i++) {
//	 av_push(avref, newSVpv(array[i], strlen(array[i])));
//     }
//
//     SvSetSV(arg, newRV((SV*)avref));
//}

MODULE = String::Trigram	PACKAGE = String::Trigram

PROTOTYPES: DISABLE


double
_computeActSim (sameTrigs, allTrigs, warp)
	int	sameTrigs
	int	allTrigs
	double	warp

#char **
#_extractTrigrams (inp)
#	char *	inp
#
#	PREINIT:
#		int count_charPtrPtr;
#		int i;
#		char** trigs;
#
#	CODE:
##		if (inp == NULL) {
#		   
#		}
#		
#		i                = 0;
#		count_charPtrPtr = strlen(inp) - 2;
#		trigs            = malloc(count_charPtrPtr * sizeof(inp));
#		RETVAL           = trigs;
#
#		for (i = 0; i < count_charPtrPtr; i++) {
#		       trigs[i] = malloc(4 * sizeof(inp));
#		       memcpy(trigs[i], inp + i, 3);
#		       trigs[i][3] = '\0';
#		}
#
#	OUTPUT:
#		RETVAL
