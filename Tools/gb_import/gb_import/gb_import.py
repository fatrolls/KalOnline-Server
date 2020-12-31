#!BPY
"""
Name: 'Geometry Binary (.gb)...'
Blender: 242
Group: 'Import'
Tooltip: 'Import GB File Format (.gb)'
"""
 
__author__ = "Peter S. Stevens"
__email__   = "peter.stevens@hushmail.com"
__url__ = ("blender", "elysiun", "Project homepage, http://www.kalunderground.com/")
__version__ = "0.0.1"
__bpydoc__ = """\
Imports a Geometry Binary extension file into Blender.

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

def is_degenerate(vertices):
    if vertices[0] == vertices[1]:
        return True
    elif vertices[0] == vertices[2]:
        return True
    elif vertices[1] == vertices[2]:
        return True
    return False

class Vertex:
    def __init__(self, x, y, z, nx, ny, nz, tu, tv):
        self.position = (x, y, z)
        self.normal = (nx, ny, nz)
        self.texture = (tu, tv)
    def blend(self):
        vertex = Blender.NMesh.Vert(self.position[0], self.position[1], \
                                    self.position[2])
        return vertex
    def __str__(self):
        return '[Position %s, Normal %s, Texture %s]' % (self.position, \
               self.normal, self.texture)

class GBError(Exception):
    def __init__(self, msg):
        Exception.__init__(self)
        self.msg = msg
    def __str__(self):
        return self.msg

class GBMesh:
    def __init__(self, v):
        self.gb_version = v
        self.header = ()
        self.name = '';
        self.bones = ()
        self.vertices = []
        self.indices = ()
    def read(self, stream, meta = None):
        # Read mesh header.
        self.header = struct.unpack('<2I2B2HB', stream.read(15))
        
        print self.header
        
        # Read mesh data.
        #if meta is not None:
        #    self.name, = struct.unpack('s', meta[header[0]:])
        if self.header[6] > 0: # bone count
            self.bones = struct.unpack('<%dB' % self.header[6], \
                                       stream.read(self.header[6]))
        
        # To-do: Support all vertex formats
        if self.header[2] > 5: # vertex type
            raise GBError('Vertex type %d not supported.' % self.header[2])
        
        for i in xrange(self.header[4]):
            #x, y, z, nx, ny, nz, tu, tv = struct.unpack('<8f', stream.read(32))
            x, y, z = struct.unpack('<3f', stream.read(12));
            
            if self.header[2] == 1:
                if self.gb_version > 10:
                    stream.seek(4, 1)
            elif self.header[2] == 2:
                if self.gb_version > 10:
                    stream.seek(8, 1)
                else:
                    stream.seek(4, 1) # Header Version = 8
            elif self.header[2] == 3:
                if self.gb_version > 10:
                    stream.seek(12, 1)
                else:
                    stream.seek(8, 1) # Header Version = 8
            elif self.header[2] == 4:
                if self.gb_version > 10:
                    stream.seek(16, 1)
                else:
                    stream.seek(12, 1) # Header Version = 8
            elif self.header[2] == 5:
                if self.gb_version > 10:
                    stream.seek(20, 1)
                else:
                    stream.seek(16, 1) # Header Version = 8
            
            # maps
            #if self.header[2] == 5 and self.gb_version == 11:
            #    stream.seek(8, 1)
            
            nx, ny, nz, tu, tv = struct.unpack('<5f', stream.read(20))
            self.vertices.append(Vertex(x, y, z, nx, ny, nz, tu, tv))
        self.indices = struct.unpack('<%dH' % self.header[5], \
                                     stream.read(self.header[5] << 1))
    def blend(self, object):
        mesh =  Blender.NMesh.New()
        for vertex in self.vertices:
            mesh.verts.append(vertex.blend())
        if self.header[3] == 1: # triangle strip
            for i in xrange(2, len(self.indices)):
                vertices = []
                if not i % 2:
                    vertices = [mesh.verts[j] for j in self.indices[i - 2:i + 1]]
                else:
                    vertices = [mesh.verts[j] for j in self.indices[i:i - 3:-1]]
                if not is_degenerate(vertices):
                    face = Blender.NMesh.Face(vertices)
                    mesh.faces.append(face)
        else: # triangle list
            print len(mesh.verts)
            for i in xrange(0, len(self.indices), 3):
                vertices = [mesh.verts[j] for j in self.indices[i:i+3]]
                face = Blender.NMesh.Face(vertices)
                mesh.faces.append(face)
        object.link(mesh)

class GBMaterial:
    def __init__(self):
        self.texture = ''
        self.ambient = 0
        self.diffuse = 0
        self.emissive = 0
        self.specular = 0
        self.shininess = 0.0
    def read(self, stream, meta = None):
        data = struct.unpack('<IHI2HI', stream.read(18))
        print data
    def __str__(self):
        print 'Texture: %s, Ambient: %x' % self.texture, self.ambient

class GBObject:
    class GbHeader:                            # UInt8 * 164
        def __init__(self):
            self.version = 0                   # UInt8
            self.bone_count = 0                # UInt8
            self.bone_id = 0                   # UInt8
            self.material_count = 0            # UInt8
            self.unknown0 = 0                  # UInt32
            self.file_name = ""                # UInt8 * 64
            self.file_name_length = 0          # UInt32
            self.vertex_count = ()             # UInt16 * 12
            self.index_count = 0               # UInt16
            self.xbone_count = 0               # UInt16
            self.key_frame_count = 0           # UInt32
            self.descriptor_length = 0         # UInt32
            self.collision_length = 0          # UInt32
            self.transformation_count = 0      # UInt16
            self.animation_count = 0           # UInt16
            self.mesh_count = 0                # UInt16
            self.unknown1 = 1                  # UInt16
            self.bounding_box_min = None       # Vector3D
            self.bounding_box_max = None       # Vector3D
            self.bounding_sphere_center = None # Vector3D
            self.bounding_sphere_radius = 0.0  # Float
        def read(self, fs):
            self.version, \
            self.bone_count, \
            self.bone_id, \
            self.material_count = struct.unpack('<4B', fs.read(4))
            
            print '%d, %d, %d, %d' % (self.version, \
                                      self.bone_count, \
                                      self.bone_id, \
                                      self.material_count)
            
            if self.version > 9:
                self.unknown0 = struct.unpack('<I', fs.read(4))
            
            if self.version > 11:
                self.file_name = struct.unpack('<64s', fs.read(64))
            
            self.file_name_length = struct.unpack('<I', fs.read(4))
            
            if self.version == 8:
                self.vertex_count = struct.unpack('<6H', fs.read(12))
            else:
                self.vertex_count = struct.unpack('<12H', fs.read(24))
            
            self.index_count, \
            self.xbone_count, \
            self.key_frame_count, \
            self.descriptor_length = struct.unpack('<2H2I', fs.read(12))
            
            print '%d, %d, %d, %d' % (self.index_count, \
                                      self.xbone_count, \
                                      self.key_frame_count, \
                                      self.descriptor_length)
            
            if (self.version > 8):
                self.collision_length = struct.unpack('<I', fs.read(4))
            
            print '%d' % self.collision_length
            
            self.transformation_count = struct.unpack('<H', fs.read(2))
            
            print '%d' % self.transformation_count
            
            if self.version == 8:
                self.animation_count = struct.unpack('<B', fs.read(1))
            else:
                self.animation_count = struct.unpack('<H', fs.read(2))
            
            print '%d' % self.animation_count
            
            self.mesh_count, \
            self.unknown1 = struct.unpack('<2H', fs.read(4))
            
            if self.version > 10:
                fs.read(24)
                #self.bounding_box_min = Vector3D()
                #self.bounding_box_min.__deserialize(fs)
                #self.bounding_box_max = Vector3D()
                #self.bounding_box_max.__deserialize(fs)
            
            if self.version > 8:
                fs.read(16)
                #self.bounding_sphere_center = Vector3D()
                #self.bounding_sphere_center.__deserialize(fs)
                #self.bounding_sphere_radius = struct.unpack('f', fs.read(4))
    def __init__(self):
        self.materials = []
        self.meshes = []
    def read(self, stream):
        header = GBObject.GbHeader()
        header.read(stream)
        
        # Read model header; Version 12 only!
        #version, = struct.unpack('<B', stream.read(1))
        #if version != 12:
        #    raise GBError('Version %d not supported.' % version)
        #header = struct.unpack('<3BI64sI18HI4H10f', stream.read(163))
        # Read model and material data.
        #stream.seek(-header[22], 2)
        #data = stream.read(header[22])
        #stream.seek(164, 0)
        # Read model data.
        for i in xrange(header.material_count):
            material = GBMaterial()
            material.read(stream)
            self.materials.append(material)
        for i in xrange(header.mesh_count):
            mesh = GBMesh(header.version)
            mesh.read(stream)
            self.meshes.append(mesh)
                
#        i = 0
#        
#        if header.bone_id != 0:
#            for i in xrange(header.bone_count):
#                matrix = struct.unpack('<16f', stream.read(64))
#                parent = struct.unpack('<B', stream.read(1))[0]
#                if parent == 255:
#                    parent = -1
#                print '(%d "bone.%03d" (parent %d))' % (i, i, parent)
        
        armature = Blender.Armature.Armature()
        armature.makeEditable()
        
        joints = {}
        i = 0
        
        identity = Blender.Mathutils.Matrix([1, 0, 0, 0],\
                                          [0, 1, 0, 0],\
                                          [0, 0, 1, 0],\
                                          [0, 0, 0, 1])
        
        if header.bone_id != 0:
            for i in xrange(header.bone_count):
                
                matrix = struct.unpack('<16f', stream.read(64))
                parent = struct.unpack('<B', stream.read(1))[0]
                
                local = Blender.Mathutils.Matrix([matrix[ 0], matrix[ 1], matrix[ 2], matrix[ 3]],\
                                                 [matrix[ 4], matrix[ 5], matrix[ 6], matrix[ 7]],\
                                                 [matrix[ 8], matrix[ 9], matrix[10], matrix[11]],\
                                                 [matrix[12], matrix[13], matrix[14], matrix[15]])
                
                bone = Blender.Armature.Editbone()
                
                combined = None
                
                if joints.has_key(parent):
                    bone.parent = armature.bones['bone.%03d' % parent]
                    bone.head = joints[parent].translationPart()
                    combined = local + joints[parent]
                else:
                    bone.head = identity.translationPart()
                    combined = local + identity
                
                bone.tail = combined.translationPart()
                #bone.matrix = combined
                joints[i] = combined
                
                armature.bones['bone.%03d' % i] = bone
                
                i = i + 1
                    
#                bone = Blender.Armature.Editbone()
#                
#                m = struct.unpack('<16f', stream.read(64))
#                p = struct.unpack('<B', stream.read(1))[0]
#                
#                local_matrix = Blender.Mathutils.Matrix([m[0], m[1], m[2], m[3]],\
#                                                        [m[4], m[5], m[6], m[7]],\
#                                                        [m[8], m[9], m[10], m[11]],\
#                                                        [m[12], m[13], m[14], m[15]])
#                
#                #if( patentBone != NULL )
#                #    trMatrix = boneMatrix * parentBone->trMatrix;
#                #else
#                #    trMatrix = boneMatrix;
#                #
#                #vertexTransformMatrix = offsetMatrix * trMatrix;
#                
#                combined_matrix = None
#                final_matrix = None
#                
#                if joints.has_key(p):
#                    combined_matrix = local_matrix * joints[p]['BONE_SPACE']
#                    final_matrix = offset_matrix * combined_matrix
#                    bone.tail = final_matrix.translationPart()
#                    bone.head = joints[p]['CHARACTER_SPACE'].translationPart()
#                    bone.parent = armature.bones['bone.%03d' % p]
#                else:
#                    combined_matrix = local_matrix
#                    final_matrix = offset_matrix * combined_matrix
#                    bone.tail = final_matrix.translationPart()
#                    bone.head = Blender.Mathutils.Vector(0.0, 0.0, 0.0)
#                
#                print 'tail: ', bone.tail
#                print 'head: ', bone.head
#                
#                armature.bones['bone.%03d' % i] = bone
#                joints[i] = {'BONE_SPACE' : combined_matrix, 'CHARACTER_SPACE' : final_matrix}
#                i = i + 1
#        
        scene = Blender.Scene.getCurrent()
        object = Blender.Object.New('Armature')
        object.link(armature)
        armature.update()
        scene.link(object)
        scene.update()
    def blend(self, scene):
        # Link object meshes to Blender scene.
        for mesh in self.meshes:
            object = Blender.Object.New('Mesh')
            mesh.blend(object)
            scene.link(object)

def gb_import(file_name):
    # Read object from file.
    file_stream = open(file_name, 'rb')
    object = GBObject()
    object.read(file_stream)
    file_stream.close()
    # Add object to Blender scene.
    scene = Blender.Scene.GetCurrent()
    object.blend(scene)

def file_selector_callback(file_name):
    gb_import(file_name)

def main():
    Blender.Window.FileSelector(file_selector_callback, 'Import GB', '*.gb')

if __name__ == '__main__':
    main()
