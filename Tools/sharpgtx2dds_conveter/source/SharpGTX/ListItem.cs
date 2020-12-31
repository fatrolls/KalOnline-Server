using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

namespace SharpGTX {
    class ListItem {
        public string Path;

        public ListItem(string path) {
            this.Path = path;
        }

        public override string ToString() {
            return System.IO.Path.GetFileName(this.Path);
        }
    }
}
