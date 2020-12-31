/* KalOnline Server Emulator                                 
 * Copyright (C) 2006 ingam0r <ingam0r@m2x.eu> 
 *                                                     
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by 
 * the Free Software Foundation; either version 2 of the License, or (at 
 * your option) any later version.                                     
 *                                                   
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details. 
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software 
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA                                                     *
 *                                                               
 * If you make useful changes to the code please contribute them to this
 * project. I would be happy to include your useful changes in one of the 
 * next releases. Thank you! 
 * You can find the latest release of this source code at our official
 * release site: http://www.kalunderground.com . Don't bother to visit
 * them.
*/
	
using System;

namespace KalServer.AI
{
    class AIScheduledEvent : AIEvent
    {
        private const int MIN_DELAY = 500;  /* Minimal delay for between events */
        private Callback __callback;
                
        /* Calls CallbackFunc every delay milliseconds
        */
        public AIScheduledEvent(Callback cbFunc, long delay)
        {
            __callback = cbFunc;
            if (delay < MIN_DELAY)
            {
                delay = MIN_DELAY;
            }
            this._delay = delay;
        }

        public override void Run()
        {
            this._lastcalled = Environment.TickCount;
            __callback(null);
        }
    }
}
