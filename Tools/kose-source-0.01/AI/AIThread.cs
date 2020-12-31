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
using System.Collections.Generic;
using System.Threading;

namespace KalServer.AI
{
    abstract class AIEvent
    {
        protected long _lastcalled;
        protected long _delay;

        public long LastCalled { get { return this._lastcalled; } }
        public long Delay { get { return this._delay; } }

        public abstract void Run();
    }

    class AIThread
    {
        private List<AIEvent> _scheduledevents;   
        private List<AIEvent> _readytodelete;     
        private static AIThread _ait = new AIThread();

        public List<AIEvent> ReadyToDelete { get { return this._readytodelete; } }
        private const short WAKEUP_INTERVAL = 100;

        public AIThread()
        {
            _scheduledevents = new List<AIEvent>();
            _readytodelete = new List<AIEvent>();
        }

        public static void Run()
        {
            Console.WriteLine("AIThread started!");
            while (true)
            {
                foreach (AIEvent aitask in _ait._scheduledevents)
                {
                    if (aitask.LastCalled + aitask.Delay < Environment.TickCount)
                    {
                        aitask.Run();
                        if (aitask is AIDelayedEvent) _ait._readytodelete.Add(aitask);
                    }
                }
                foreach (AIEvent aievent in _ait._readytodelete)
                {
                    if (_ait._scheduledevents.Contains(aievent))
                    {
                        Console.WriteLine("AIEvent deleted!");
                        _ait._scheduledevents.Remove(aievent);
                    }
                }
                Thread.Sleep(WAKEUP_INTERVAL);
            }
        }

        public static void Enqueue(AIEvent aievent)
        {
            Monitor.Enter(_ait._scheduledevents);  
            if (aievent != null)                
                _ait._scheduledevents.Add(aievent);
            Monitor.Exit(_ait._scheduledevents);
        }

        public static void Dequeue(AIEvent aievent)
        {
            Monitor.Enter(_ait._scheduledevents);
            if (_ait._scheduledevents.Contains(aievent))
                _ait._scheduledevents.Remove(aievent);
            Monitor.Exit(_ait._scheduledevents);
        }
    }
}
