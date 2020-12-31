#!BPY

"""
Name: 'Geometry Binary (.gb)...'
Blender: 243
Group: 'Export'
Tooltip: 'Export to Geometry Binary file format (.gb)'
"""

__author__ = 'Peter S. Stevens'
__email__ = 'pstevens:cryptomail*org'
__url__ = ('blender', 'elysiun', 'Project homepage, http://www.kalunderground.com/')
__version__ = '0.1.0'
__bpydoc__ = """ \
This script exports Geomentry Binary (*.gb) files.
"""

# Copyright (c) 2007, Peter S. Stevens
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the author nor the names of its contributors
#       may be used to endorse or promote products derived from this software
#       without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

import Blender
import struct
import types

GB_VERSION_MIN = 8
GB_VERSION_MAX = 12
GB_VERSION = Blender.Draw.Create(GB_VERSION_MIN)

GB_SWAP_YZ = Blender.Draw.Create(0)
GB_FLIP_Z = Blender.Draw.Create(1)

GB_TRI_LIST = 0

def obb_to_aabb(vecs):
    min = vecs[0].copy()
    max = min.copy()
    
    for vector in vecs:
        if (vector.x < min.x):
            min.x = vector.x
        if (vector.x > max.x):
            max.x = vector.x
        if (vector.y < min.y):
            min.y = vector.y
        if (vector.y > max.y):
            max.y = vector.y
        if (vector.z < min.z):
            min.z = vector.z
        if (vector.z > max.z):
            max.z = vector.z
    
    return (min, max)

def get_mesh_triangles(mesh, matrix, local_matrix = None):
    if not isinstance(mesh, Blender.Types.MeshType):
        raise TypeError, 'Expected Blender.Types.MeshType received %s.' % type(mesh)
    
    if not isinstance(matrix, Blender.Types.matrix_Type):
        raise TypeError, 'Expected Blender.Types.matrix_Type received %s.' % type(matrix)

    if not isinstance(local_matrix, (Blender.Types.matrix_Type, types.NoneType)):
        raise TypeError, 'Expected Blender.Types.matrix_Type received %s.' % type(matrix)

    vertices = ''
    faces = '' # Default, triangle list. Optimized for speed, otherwise, change
               # to list type.
    uvs = [[] for i in xrange(len(mesh.verts))] # Vertex UV queue.
    vuv = [[] for i in xrange(len(mesh.verts))] # Vertex to UV mapping.
    #indices = [] # Uncomment for extending or debugging purposes.
    vertex_type = 0 #To-do: Add support for other vertex types.
    
    count = 0
    
    for face in mesh.faces:
        if len(face.verts) == 3: # Accept only triangles.
            for i, vertex in enumerate(face):
                index = vertex.index
                uv = Blender.Mathutils.Vector(0.0, 0.0)
                
                if mesh.faceUV: # Overwrite default vertex uv coordinates.
                    uv = face.uv[i]
                
                if not uv in uvs[index]: # Re-index vertices and duplicate
                                         # vertices with multiple uv
                                         # coordinates.
                    position = vertex.co.copy()
                    normal = vertex.no.copy()
                    
                    if local_matrix != None:
                        position *= local_matrix
                        normal *= local_matrix
                    
                    position *= matrix
                    normal *= matrix
                    
                    vertices += struct.pack('<8f', \
                        position.x, position.y, position.z, \
                        normal.x, normal.y, normal.z, \
                        uv.x, uv.y * -1.0)
                    #indices.append(index) # Uncomment for extending or
                                           # debugging purposes.
                    uvs[index].append(uv)
                    vuv[index].append(count)
                    count += 1
                if GB_FLIP_Z.val:
                    faces = struct.pack('<H', vuv[index][uvs[index].index(uv)]) + faces
                else:
                    faces += struct.pack('<H', vuv[index][uvs[index].index(uv)])
        else:
            raise TypeError, 'Mesh: %s, only triangle primitives are supported.' % mesh.name
    
    header = [0, \
        0, \
        vertex_type, \
        GB_TRI_LIST, \
        len(vertices) / (((vertex_type % 4) * 4) + 32), \
        len(faces) >> 1, \
        0]
    
    return (header, vertices, faces)

def get_mesh_material(mesh, materials):
    if not isinstance(mesh, Blender.Types.MeshType):
        raise TypeError, 'Expected Blender.Types.MeshType received %s.' % type(mesh)
    
    data = ''
    material = None
    texture = None
    image_name = 'noimage.tga' # Default, no image.
    
    if not len(mesh.materials) or (mesh.materials[0] == None):
        raise ValueError, 'Mesh: %s, has no assigned material.' % mesh.name
    else:
        material = mesh.materials[0]
        
        if len(material.getTextures()) and (material.getTextures()[0] != None):
            texture = material.getTextures()[0].tex
            if texture.getImage() != None:
                image_name = texture.getImage().getName()
        
        if not image_name in materials['image']:
            materials['image'][image_name] = materials['length']
            data += image_name + '\0'
            materials['length'] += len(data)
        
        if not material.getName() in materials['material']:
            materials['material'][material.getName()] = materials['length']
            pack = lambda a, r, g, b: struct.pack('<4B', r, g, b, a)
            byteme = lambda x: x * 255
            alpha = byteme(material.alpha)
            data += pack(alpha, *map(byteme, material.rgbCol))
            data += pack(alpha, *map(byteme, material.mirCol))
            data += pack(alpha, *map(byteme, material.specCol))
            data += struct.pack('<f20x', material.spec)
            materials['length'] = len(data)
    
    header = struct.pack('<IH3I', \
        materials['image'][image_name], \
        0, \
        len(image_name),
        0, \
        materials['material'][material.getName()])
    
    return (header, data)

def gb_export(file_path):
    if not file_path.endswith('.gb'):
        file_path += '.gb'
    
    if Blender.sys.exists(file_path):
        if Blender.Draw.PupMenu('Overwrite ' + file_path + '?%t|Yes%x0|No%x1'):
            return
    
    okay = Blender.Draw.PupBlock(
        'Export Options, Version: %s' % __version__, \
        [('Version', GB_VERSION, GB_VERSION_MIN, GB_VERSION_MAX, 'Version'), \
        ('Swap Y/Z Axes', GB_SWAP_YZ, 'Swap y and z axes'), \
        ('Flip Z Axis', GB_FLIP_Z, 'Flip z axis'), \
        '© 2007 %s' % __author__])
    
    if not okay:
        Blender.Draw.PupMenu('Warning%t|Exporting aborted by user.')
        return
    
    Blender.Window.EditMode(0)
    Blender.Window.WaitCursor(1)
    Blender.Window.DrawProgressBar(0.0, 'Exporting data ...')
    
    objects = Blender.Object.GetSelected()
    
    if not len(objects):
        Blender.Draw.PupMenu('Error%t|No objects selected.')
        Blender.Window.WaitCursor(0)
        return
    
    meshes = []
    
    for object in objects: # Retrieve all meshes.
        if object.getType() == 'Mesh':
            meshes.append(object)
    
    if not len(meshes):
        Blender.Draw.PupMenu('Error%t|No mesh objects selected.')
        Blender.Window.WaitCursor(0)
        return
    
    file_name = Blender.sys.basename(file_path)
    
    header = [GB_VERSION.val, \
        0, 0, 
        len(meshes), \
        0, \
        file_name, \
        len(file_name), \
        [0 for x in xrange(12)], \
        0, 0, 0, 0, 0, 0, 0, 0, \
        1, \
        Blender.Mathutils.Vector(), \
        Blender.Mathutils.Vector(), \
        Blender.Mathutils.Vector(), \
        0.0]
    
    material_data = ''
    mesh_data = ''
    footer_data = file_name + '\0\0' # Account the extra null terminator for
                                     # the material overlay string option.
    
    materials = {'length': 0, 'material': {}, 'image': {}} # Footer data indexer.
    
    matrix = Blender.Mathutils.Matrix() # Identity matrix.
    
    if GB_FLIP_Z.val:
        matrix[2][2] = -1
    
    if GB_SWAP_YZ.val:
        matrix = Blender.Mathutils.RotationMatrix(-90, 4, 'x') * matrix
    
    min_max = None # Bounding Box minimum and maximum
    
    for mesh in meshes:
        mesh_obj = mesh.getData(mesh=True)
        name_offset = len(footer_data)
        footer_data += mesh.name + '\0'
        
        aabb = obb_to_aabb(mesh.getBoundBox())
        
        if min_max != None:
            if min_max[0] > aabb[0]:
                min_max[0] = aabb[0]
            if min_max[1] < aabb[1]:
                min_max[1] = aabb[1]
        else:
            min_max = list(aabb)
        
        try:
            materials['length'] = len(footer_data)
            
            (material_header, \
            material_footer) = get_mesh_material(mesh_obj, materials)
            
            if GB_VERSION.val > 7: # Material headers not supported in version
                                   # seven, but material data is?
                material_data += material_header
            footer_data += material_footer
            
            local_matrix = None
            
            if mesh.getParent() != None: # local matrix relative to parent.
                local_matrix = mesh.getMatrix('localspace')
            
            (mesh_header, \
            mesh_vertices, \
            mesh_faces) = get_mesh_triangles(mesh_obj, matrix, local_matrix)
            
            header[7][mesh_header[2]] += mesh_header[4] # Update vertices count
            header[8] += mesh_header[5] # Update indices count
            
            mesh_header[0] = name_offset
            if len(material_data): # Version seven check, don't want a negative
                                   # material index.
                mesh_header[1] = (len(material_data) / 18) - 1
            mesh_data += struct.pack('<2I2B2HB', *mesh_header)
            mesh_data += mesh_vertices + mesh_faces
        except Exception, error:
            Blender.Draw.PupMenu('Error%t|' + str(error))
            Blender.Window.WaitCursor(0)
            return
    
    header[11] = len(footer_data) # Update descriptor (footer) length
    header[15] = (len(material_data) / 18) # Update material count
    header[17:19] = map(lambda x: x * matrix, min_max) # Update bounding box.
    
    header_data = struct.pack('4B', *header[:4])
    if GB_VERSION.val > 9:
            header_data += struct.pack('<I', header[4])
    if GB_VERSION.val > 11:
        header_data += struct.pack('<64s', header[5])
    header_data += struct.pack('<I', header[6])
    if GB_VERSION.val == 8:
        header_data += struct.pack('<6H', *header[7][:6])
    else:
        header_data += struct.pack('<12H', *header[7])
    header_data += struct.pack('<2H2I', *header[8:12])
    if GB_VERSION.val > 8:
        header_data += struct.pack('<I', header[12])
    header_data += struct.pack('<H', header[13])
    if GB_VERSION.val == 8:
        header_data += struct.pack('<B', header[14])
    else:
        header_data += struct.pack('<H', header[14])
    header_data += struct.pack('<2H', *header[15:17])
    if GB_VERSION.val > 10:
        header_data += struct.pack('<3f', *header[17])
        header_data += struct.pack('<3f', *header[18])
    if GB_VERSION.val > 8:
        header_data += struct.pack('<3f', *header[19])
        header_data += struct.pack('<f', header[20])
    
    file_stream = None
    
    try:
        file_stream = open(file_path, 'wb')
        file_stream.write(header_data)
        file_stream.write(material_data)
        file_stream.write(mesh_data)
        file_stream.write(footer_data)
    except IOError, error:
        Blender.Draw.PupMenu('Error%t|' + str(error))
        Blender.Window.WaitCursor(0)
    else:
        if file_stream != None:
            file_stream.close()
    
    Blender.Window.DrawProgressBar(1.0, 'Completed exporting data.')
    Blender.Window.WaitCursor(0)

def main():
    Blender.Window.FileSelector(
        gb_export, \
        'Export...', \
        Blender.sys.makename(ext='.gb'))

if __name__ == '__main__':
    main()
