======================================================================
                              _______________________
                             / //_/ __ \/ ___// ____/
                            / ,< / / / /\__ \/ __/   
                           / /| / /_/ /___/ / /___   
                          /_/ |_\____//____/_____/   

		      KalOnline Server Emulator (KOSE)
  			 Copyright (C) 2006 ingam0r
			<ingam0r@kalunderground.com> 

======================================================================

Welcome to KOSE! 
The open source implementation of the Kalonline client-server 
protocol. Please visit our homepage at http://kose.kalunderground.com
for the latest updates and news regarding the project. If you have 
any questions visit our forum at http://www.kalunderground.com .

Have fun!



0. TABLE OF CONTENTS
--------------------

1. License
2. Contributing
3. Using the source
4. Using the binaries
5. Start exploring the world


1. LICENSE
----------                                                    

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by 
the Free Software Foundation; either version 2 of the License, or (at 
your option) any later version.                                     
                                                   
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details. 

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software 
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 
USA                          


2. CONTRIBUTING
---------------

If you make useful changes to the code please contribute them to this
project. I would be happy to include your useful changes in one of the 
next releases. Thank you! 
You can find the latest release of this source code at our official
release site: http://kose.kalunderground.com . Don't bother to visit.


3. USING THE SOURCE
-------------------

To compile the source you can use Mono or .Net. Whatever you prefer. 
Be sure to include a reference to the Mono.Data.SqliteClient assembly 
as it is needed to communicate with the database. 

I don't give exact step-by-step instructions on compiling since you 
should know what you are doing if you want to build it from source.

If you get compiler errors while building you should check whether 
you environment is set up correctly. Perhaps you forget to include 
a refernce to System.Data?

If everything worked and you have a compiled .exe go ahead to step 4.


4. USING THE BINARIES
---------------------

After you downloaded the binaries extract them in a folder 
(eg. c:\kalserver ). Then download the data-archive from the project 
homepage (http://kose.kalunderground.com) and extract it into the 
same directory like your executables.


5. START EXPLORING THE WORLD
----------------------------

Make your client connect to port 30011 on the computer where the 
server is running and log in using the following account:

User: admin
Pass: admin

You will start in D1. If you would like to change your inventory or 
your character settings you have to download a tool like SQLiteAdmin 
(http://sqliteadmin.orbmu2k.de) and change the database.