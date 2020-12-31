"""
Sword 3D Proof-of-Concept Geometry Binary Blender Exporter 

Copyright (c) 2007, Peter S. Stevens, The Phantom. All rights reserved.
<pstevens@cryptomail.com, phantom@kalunderground.com>

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation; either version 2 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 51
Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
"""

import struct
import Blender

GB_VERSION = 8

scene = Blender.Scene.GetCurrent()
object = scene.getActiveObject()
mesh = object.getData(False, True)

triangulate = False
    
for face in mesh.faces:
   if len(face.v) != 3:
        face.sel = 1
        triangulate = True
    
if triangulate == True:
    Blender.Mesh.Mode(3)
    if Blender.Window.EditMode():
        Blender.Window.EditMode(0)
    mesh.quadToTriangle(0)

#mesh.remDoubles(0.0)

vertices = []
indices = []

length = len(mesh.verts)

unique_vertices = {}
duplicate_vertices = {}

for face in mesh.faces:
    if len(face.v) == 3:
        for i, v in enumerate(face):
            vertex = (v.co.x, v.co.y, v.co.z, v.no.x, v.no.y, v.no.z, face.uv[i].x, face.uv[i].y)
            if not unique_vertices.has_key(vertex):
                if duplicate_vertices.has_key(v.index):
                    unique_vertices[vertex] = length
                    length += 1
                else:
                    duplicate_vertices[v.index] = None
                    unique_vertices[vertex] = v.index
            indices.append(unique_vertices[vertex])
    else:
        print 'problem'

temp = unique_vertices.values()

for v in mesh.verts:
    try:
        temp.index(v.index)
    except ValueError:
        vertex = (v.co.x, v.co.y, v.co.z, v.no.x, v.no.y, v.no.z, 0.0, 0.0)
        unique_vertices[vertex] = v.index

vertices = unique_vertices.items()

def cmp_by_value(a, b):
    return cmp(a[1], b[1])

vertices.sort(cmp_by_value)

stream = open('C:\\%s.gb' % mesh.name, 'wb')

footer = '%s.gb\0%s\0' % (mesh.name, mesh.name)

# GB Header
header = struct.pack('<B2xBIH10xH6xI3x2H', \
    GB_VERSION, \
    1, \
    len(mesh.name) + 3, \
    len(vertices), \
    len(indices), \
    len(footer) + (len(mesh.materials) * 36) + len(mesh.name) + 5, \
    1,\
    1)

stream.write(header)

if len(mesh.materials) and (mesh.materials[0] != None):
    material = mesh.materials[0]
    texture = '%s.tga\0' % mesh.name
    
    # Material Header
    header = struct.pack('<I2xI4xI', \
        len(footer), \
        len(texture) - 1,
        len(footer) + len(texture))
    
    stream.write(header)
    
    footer += texture
    
    footer += struct.pack('12Bf20x', \
        material.mirR * 255, \
        material.mirG * 255, \
        material.mirB * 255, \
        material.alpha * 255, \
        material.R * 255, \
        material.G * 255, \
        material.B * 255, \
        material.alpha * 255, \
        material.specR * 255, \
        material.specG * 255, \
        material.specB * 255, \
        material.alpha * 255, \
        material.spec)
else:
    Blender.Draw.PupMenu('Error%t|No materials.')

# Mesh Header
header = struct.pack('<I6x2Hx', \
    0, \
    len(vertices), \
    len(indices))

stream.write(header)

for v in vertices:
    data = struct.pack('<8f', \
        v[0][0], v[0][1], v[0][2], \
        v[0][3], v[0][4], v[0][5], \
        v[0][6], -v[0][7])
    stream.write(data)

index = vertices[0][1] - 0

for i in xrange(len(indices)):
    data = struct.pack('<H', indices[i] - index)
    stream.write(data)

stream.write(footer)

stream.close()