// Sound Preloader Script
// Copyright (C) 2014 Coffee Pancake
// Released under the MIT Licence (http://opensource.org/licenses/MIT)

// Documentation
// https://github.com/0xc0ffea/SecondLife-SoundPreload

integer SOUNDS_COUNT;
list    SOUNDS;

default
{
    state_entry()
    {
        // Setup the containing prim so people can walk through it
        // and trigger the required collision events.
        llSetLinkPrimitiveParamsFast(LINK_SET,[PRIM_PHANTOM,FALSE]);
        llVolumeDetect(TRUE);
        
        // Index the sounds contained
        integer x;
        SOUNDS_COUNT= llGetInventoryNumber(INVENTORY_SOUND);
        for (x=0;x<SOUNDS_COUNT;x++) {
            SOUNDS += [llGetInventoryName(INVENTORY_SOUND,x)];
        }
        
        llSay(DEBUG_CHANNEL,(string)SOUNDS_COUNT+" files indexed, "+(string)llGetFreeMemory()+" bytes free.");
    }

    collision_start( integer num_detected ) {
        if (SOUNDS_COUNT== 0) {return;}
        
        integer x;
        integer y;
        key target;
        
        // Loop through multiple collissions
        for (x=0;x<num_detected;x++) {
            // Get the UUID of whatever just collided with this prim
            target = llDetectedKey(x);
            
            // Only run preload loop for avatars
            if (llGetAgentSize(target) != ZERO_VECTOR) {
                // The preload loop
                for (y=0;y<SOUNDS_COUNT;y++) {
                    // Ask targets viewer to preload the sound
                    // this delays the script here 1 second
                    llPreloadSound(llList2String(SOUNDS,y));
                }
            }
        }
    }

    changed( integer change ) {
        if (change & CHANGED_INVENTORY) {
            llSay(DEBUG_CHANNEL,"Pending changes, script will restart in 5 seconds.");
            llSleep(5);
            llResetScript();
        }
    }
}
