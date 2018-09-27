/*****************************************************************************
 * License : All rights reserved for TES Electronic Solutions GmbH
 *           See included /docs/license.txt for details
 * Project : D/AVE NX
 * Purpose : Make build-time svnversion information available
 *           NOTE: THIS FILE IS AUTOGENERATED BY SVNVER SCRIPT
 ****************************************************************************/

#define SVNVERSION "$SVNVERSION$"
#define SVNDATE    "$SVNDATE$"

const char g_driver_svnversion_string[] = SVNVERSION;
const char g_driver_svndate_string[]    = SVNDATE;
const char g_driver_svnver_fileid[]     = "@@SVN:" SVNVERSION " driver";

const char *get_driver_svnver_fileid(void) { return g_driver_svnver_fileid; }

