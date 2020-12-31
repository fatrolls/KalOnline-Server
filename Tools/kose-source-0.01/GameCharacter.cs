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
using System.Collections;
using System.Collections.Generic;
using System.Text;

namespace KalServer
{
    /* Represents a character. Can be a monster or a player    */
    public abstract class GameCharacter
    {
        protected int uniqueID;

        protected int hpAktuell;
        protected int hpMaximal;
        protected short manaAktuell;
        protected short manaMaximal;

        protected byte charLevel;
        protected short charEvasion;
        protected short charDefense;
        protected byte charAbsorption;
        protected short onTarget;
        protected short minPhysicalDMG;
        protected short maxPhysicalDMG;
        protected short minMagicalDMG;
        protected short maxMagicalDMG;

        protected Stats charStats;
        protected ObjectPosition charPosition;
        protected Resistances charResistances;

        public int UniqueID { get { return this.uniqueID; } }

        public int HPAktuell { get { return this.hpAktuell; } set { this.hpAktuell = value; } }
        public int HPMaximal { get { return this.hpMaximal; } }
        public short ManaAktuell { get { return this.manaAktuell; } set { this.manaAktuell = value; } }
        public short ManaMaximal { get { return this.manaMaximal; } }

        public byte Level { get { return this.charLevel; } }
        public short Evasion { get { return this.charEvasion; } }
        public short Defense { get { return this.charDefense; } }
        public byte Absorption { get { return this.charAbsorption; } }
        public short OnTarget { get { return this.onTarget; } }

        public short MinPhysicalDMG { get { return this.minPhysicalDMG; } }
        public short MaxPhysicalDMG { get { return this.maxPhysicalDMG; } }
        public short MinMagicalDMG { get { return this.minMagicalDMG; } }
        public short MaxMagicalDMG { get { return this.maxMagicalDMG; } }
        public ObjectPosition Position { get { return this.charPosition; } set { this.charPosition = value; } }
        public Stats Stats { get { return this.charStats; } }

        public GameCharacter()
        {
            this.uniqueID = World.GetID();
            this.charPosition = new ObjectPosition();
            this.charStats = new Stats();
            this.charResistances = new Resistances();
        }

        public void SetStrength(byte newValue)
        {
            this.charStats.Strength = newValue;
            this.CalcPhysicalDMG();
        }

        public void SetHealth(byte newValue)
        {
            this.charStats.Health = newValue;
            this.hpMaximal = (short)(this.charStats.Health * 30);
        }

        public void SetIntelligence(byte newValue)
        {
            this.charStats.Intelligence = newValue;
            this.CalcMagicalDMG();
        }

        public void SetWisdom(byte newValue)
        {
            this.charStats.Wisdom = newValue;
            this.manaMaximal = (short)(this.charStats.Wisdom * 30);
            this.CalcMagicalDMG();
        }

        public void SetAgility(byte newValue)
        {
            this.charStats.Agility = newValue;
            this.CalcPhysicalDMG();
        }

        public void SetLevel(byte newValue)
        {
            this.charLevel = newValue;
        }

        private void CalcPhysicalDMG()
        {
            this.minPhysicalDMG = (short)((this.charStats.Agility / 4) + (this.charStats.Strength / 2) + 3);
            this.maxPhysicalDMG = (short)((this.charStats.Agility / 4) + (this.charStats.Strength / 2) + 15);
        }

        private void CalcMagicalDMG()
        {
            this.minMagicalDMG = (short)((this.charStats.Wisdom / 4) + (this.charStats.Intelligence / 2) + 3);
            this.maxMagicalDMG = (short)((this.charStats.Wisdom / 4) + (this.charStats.Intelligence / 2) + 15);
        }
    }
}
