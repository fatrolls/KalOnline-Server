# Copyright (c) 2007-2008 Peter S. Stevens
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

from Blender import Armature, Image, Material, Modifier, Mesh, Object, sys, Texture
from Blender.Armature import *
from Blender.Mesh import *
from Blender.Mathutils import *
from Blender.Object import *
from Blender.Texture import *
from struct import *
from math import *


TRIANGLE_LIST = 0
TRIANGLE_STRIP = 1

FRAMES_PER_SEC = 30


def is_degenerate(fi):
    if fi[0] == fi[1]:
        return True
    elif fi[0] == fi[2]:
        return True
    elif fi[1] == fi[2]:
        return True
    return False


class GeoBinArmature(object):
    
    __slots__ = ('innerObject', 'innerArmature', 'skeletalHierarchy')
    
    def __init__(self, obj):
        if obj == None or obj.getType() != 'Armature':
            raise TypeError, ""
        
        self.innerObject = obj
        self.innerArmature = obj.getData()
        
        if self.innerArmature == None:
            self.innerArmature = Armature.New(self.innerObject.name)
            self.innerObject.link(self.innerArmature)
        
        self.innerObject.drawMode = DrawModes.XRAY
        self.innerArmature.drawType = STICK
        self.innerArmature.envelopes = False
        self.innerArmature.vertexGroups = True
#        self.innerArmature.restPosition = True
        
        self.skeletalHierarchy = []
    
    def readFromFile(self, fs, gbf):
        joints = []
        
        self.innerArmature.makeEditable()
        
        for x in xrange(gbf.boneCount):
            joints.append(Matrix(unpack('<4f', fs.read(16)), \
                                 unpack('<4f', fs.read(16)), \
                                 unpack('<4f', fs.read(16)), \
                                 unpack('<4f', fs.read(16))))
            
            self.skeletalHierarchy.append(unpack('<B', fs.read(1))[0])
        
        for x, parent in enumerate(self.skeletalHierarchy):
            joint = joints[x].copy().invert()
            
            editBone = Editbone()
            
            if parent != 255:
                editBone.parent = self.innerArmature.bones["bone.%03d" % parent]
            
            editBone.matrix = joint
#            editBone.head = (Vector([0, 0, 0, 1]) * joint).resize3D()
#            editBone.tail = (Vector([0.5, 0, 0, 1]) * joint).resize3D()
            
            self.innerArmature.bones["bone.%03d" % x] = editBone
        
        self.innerArmature.update()
    
    def applyAnimations(self, anims):
        if anims != None and isinstance(anims, GeoBinAnimations):
            for i, animation in enumerate(anims):
                applyAnimation(anims, i)
    
    def applyAnimation(self, anims, idx):
        if anims == None or not isinstance(anims, GeoBinAnimations):
            raise TypeError, ""
        
        animation = anims[idx]
        
        action = NLA.NewAction("animation.%03d" % animation.id)
        action.setActive(self.innerObject)
        
        armaturePose = self.innerObject.getPose()
        
        poseBones = armaturePose.bones
        
        for keyFrame in animation.keyFrames:
            for b, parent in enumerate(self.skeletalHierarchy):
                i = keyFrame.transformationIndices[b]
                localMatrix = anims.transformationMatrices[i].copy()
                
                restBone = self.innerArmature.bones["bone.%03d" % b]
                restBoneMatrix = restBone.matrix['ARMATURESPACE'].copy().resize4x4()
                
                if parent == 255:
                    localMatrix *= restBoneMatrix.invert()
                else:
                    parentRestBone = self.innerArmature.bones["bone.%03d" % parent]
                    parentRestBoneMatrix = parentRestBone.matrix['ARMATURESPACE'].copy().resize4x4()
                    
                    localMatrix *= (restBoneMatrix * parentRestBoneMatrix.invert()).invert()
                
                poseBones["bone.%03d" % b].localMatrix = localMatrix
                poseBones["bone.%03d" % b].insertKey(self.innerObject, keyFrame.index, [Pose.ROT, Pose.LOC])
            
            armaturePose.update()


class GeoBinAnimationKeyFrame(object):
    
    __slots__ = ('duration', 'animationId', 'transformationIndices', 'index')
    
    def __init__(self, aid = 0):
        self.duration = 0
        self.animationId = aid
        self.transformationIndices = ()
        self.index = 0
    
    def readFromFile(self, fs):
        self.duration, \
        self.animationId = unpack('<HI', fs.read(6))
        self.index = int(floor((self.duration / 1000) * FRAMES_PER_SEC))


class GeoBinAnimation(object):
    
    __slots__ = ('keyFrames', 'id', 'keyFrameCount')
    
    def __init__(self):
        self.keyFrames = []
        self.id = 0
        self.keyFrameCount = 0
    
    def __readHeader(self, fs):
        self.id, \
        self.keyFrameCount = unpack('<IH', fs.read(6))
    
    def __readKeyFrames(self, fs):
        for x in xrange(self.keyFrameCount):
            keyFrame = GeoBinAnimationKeyFrame(self.id)
            keyFrame.readFromFile(fs)
            self.keyFrames.append(keyFrame)
    
    def readFromFile(self, fs):
        self.__readHeader(fs)
        self.__readKeyFrames(fs)


class GeoBinAnimations(list):
    
    __slots__ = ('transformationMatrices')
    
    def __init__(self):
        self.transformationMatrices = []
    
    def __readTransformations(self, fs, gbf):
        for animation in self:
            for x in xrange(animation.keyFrameCount):
                animation.keyFrames[x].transformationIndices = unpack('<%dH' % gbf.boneCount, fs.read(gbf.boneCount * 2))
        
        for x in xrange(gbf.transformationCount):
            translation = Vector(unpack('<3f', fs.read(12)))
            x, y, z, w = unpack('<4f', fs.read(16))
            rotation = Quaternion(w, x, y, z)
            scale = Vector(unpack('<3f', fs.read(12)))
            matrix = rotation.toMatrix().resize4x4() * TranslationMatrix(translation)
            self.transformationMatrices.append(matrix)
    
    def readFromFile(self, fs, gbf):
        for x in xrange(gbf.animationCount):
            animation = GeoBinAnimation()
            animation.readFromFile(fs)
            self.append(animation)
        self.__readTransformations(fs, gbf)


class GeoBinTextureImage(object):
    
    __slots__ = ('innerTexture', 'innerImage')
    
    def __init__(self, tex = None):
        if tex == None or not isinstance(tex, Texture) or text.getType() != 'Image':
            self.innerTexture = Texture.New()
        else:
            self.innerTexture = tex
        
        self.innerTexture.setType('Image')
    
    def loadFromPath(self, ifp):
        image = None
        
        try:
            image = Image.Get(sys.basename(ifp))
        except Exception, e:
            try:
                image = Image.Load(ifp)
            except Exception, e:
                image = None
        
        if image != None:
            self.innerImage = image
            self.innerTexture.setImage(self.innerImage)
            self.innerTexture.setName(self.innerImage.getName())


class GeoBinMaterial(object):
    
    __slots__ = ('innerMaterial', 'textureNameOffset', 'textureMapOption', \
                 'textureNameLength', 'overlayOffset', 'materialOffset')
    
    def __init__(self, mat = None):
        if not mat:
            self.innerMaterial = Material.New()
        else:
            self.innerMaterial = mat
        
        self.textureNameOffset = -1
        self.textureMapOption = 0
        self.textureNameLength = 0
        self.overlayOffset = -1
        self.materialOffset = -1
    
    def __readHeader(self, fs):
        self.textureNameOffset, \
        self.textureMapOption, \
        self.textureNameLength, \
        self.overlayOffset, \
        self.materialOffset = unpack('<IH3I', fs.read(18))
    
    def readFromFile(self, fs):
        self.__readHeader(fs)
    
    def setTextureImage(self, tex):
        self.innerMaterial.setTexture(0, tex, TexCo.UV)


class GeoBinMesh(object):
    
    __slots__ = ('innerObject', 'innerMesh', 'nameOffset', 'materialIndex', \
                 'vertexFormat', 'primitiveType', 'vertexCount', \
                 'faceIndexCount', 'boneIndexCount')
    
    def __init__(self, obj):
        if obj == None or obj.getType() != 'Mesh':
            raise TypeError, ""
        
        self.innerObject = obj
        self.innerMesh = obj.getData(mesh = True)
        
        if self.innerMesh == None:
            self.innerMesh = Mesh.New(self.innerObject.name)
            self.innerObject.link(self.innerMesh)
        
        self.nameOffset = -1
        self.materialIndex = -1
        self.vertexFormat = 0
        self.primitiveType = TRIANGLE_LIST
        self.vertexCount = 0
        self.faceIndexCount = 0
        self.boneIndexCount = 0
    
    def __readHeader(self, fs):
        self.nameOffset, \
        self.materialIndex, \
        self.vertexFormat, \
        self.primitiveType, \
        self.vertexCount, \
        self.faceIndexCount, \
        self.boneIndexCount = unpack('<2I2B2HB', fs.read(15))
    
    def __readBoneIndices(self, fs):
        for x in xrange(self.boneIndexCount):
            self.innerMesh.addVertGroup('bone.%03d' % unpack('<B', fs.read(1))[0])
    
    def __readVertices(self, fs, gbf):
        self.innerMesh.vertexUV = True
        
        for x in xrange(self.vertexCount):
            self.innerMesh.verts.extend(Vector(unpack('<3f', fs.read(12))))
            vertex = self.innerMesh.verts[-1]
            
            if self.vertexFormat > 0 and self.vertexFormat < 6:
                vertexWeightCount = -1
                
                if gbf.version > 10:
                    vertexWeightCount = self.vertexFormat - 1
                else:
                    vertexWeightCount = self.vertexFormat - 2
                
                vertexWeights = None
                
                if vertexWeightCount == 0:
                    vertexWeights = [1.0]
                elif vertexWeightCount > 0:
                    vertexWeights = list(unpack('<%df' % vertexWeightCount, fs.read(4 * vertexWeightCount)))
                
                if vertexWeights != None:
                    vertexWeights = [vertexWeight for vertexWeight in vertexWeights if vertexWeight > 0] 
                    
                    difference = 1.0 - sum(vertexWeights)
                    
                    if difference > 0:
                        vertexWeights.append(difference)
                    
                    vertexGroups = unpack('<4B', fs.read(4))
                    
                    for y, vertexWeight in enumerate(vertexWeights):
                        vertexGroup = self.innerMesh.getVertGroupNames()[vertexGroups[y]]
                        self.innerMesh.assignVertsToGroup(vertexGroup, [x], vertexWeight, AssignModes.ADD)
            
            vertex.no = Vector(unpack('<3f', fs.read(12)))
            vertex.uvco = Vector(unpack('<2f', fs.read(8)))
            vertex.uvco[1] *= -1.0
    
    def __readFaceIndices(self, fs):
        if self.primitiveType == TRIANGLE_LIST:
            for x in xrange(0, self.faceIndexCount, 3):
                faceIndices = unpack('<3H', fs.read(6))
                faceVertices = [self.innerMesh.verts[y] for y in faceIndices]
                self.innerMesh.faces.extend(faceVertices)
                face = self.innerMesh.faces[-1]
                face.uv = [vertex.uvco for vertex in faceVertices]
        elif self.primitiveType == TRIANGLE_STRIP:
            faceIndices = list(unpack('<2H', fs.read(4)))         
            
            for x in xrange(2, self.faceIndexCount):
                faceIndices.append(unpack('<H', fs.read(2))[0])
                
                faceIndicesCopy = faceIndices[:]
                
                if not x % 2:
                    faceIndicesCopy.reverse()
                
                if not is_degenerate(faceIndicesCopy):
                    faceVertices = [self.innerMesh.verts[y] for y in faceIndicesCopy]
                    self.innerMesh.faces.extend(faceVertices)
                    face = self.innerMesh.faces[-1]
                    face.uv = [vertex.uvco for vertex in faceVertices]
                
                faceIndices.pop(0)
        
        self.innerMesh.faceUV = True
    
    def readFromFile(self, fs, gbf):
        self.__readHeader(fs)
        self.__readBoneIndices(fs)
        self.__readVertices(fs, gbf)
        self.__readFaceIndices(fs)
    
    def setArmature(self, arm):
        if arm == None or not isinstance(arm, GeoBinArmature):
            raise TypeError, ""
        
        if arm.innerObject == None or arm.innerObject.getType() != 'Armature':
            raise TypeError, ""
        
        arm.innerObject.makeParent([self.innerObject])
        armatureModifier = self.innerObject.modifiers.append(Modifier.Types.ARMATURE)
        armatureModifier[Modifier.Settings.OBJECT] = arm.innerObject
        self.innerMesh.update()
    
    def setSmooth(self, b = False):
        for face in self.innerMesh.faces:
            face.smooth = b
        self.innerMesh.update()


class GeoBinCollisionMesh(object):
    
    __slots__ = ('innerObject', 'innerMesh', 'vertexCount', 'faceIndexCount', \
                 'boundingBoxMin', 'boundingBoxMax')
    
    def __init__(self, obj):
        if obj == None or obj.getType() != 'Mesh':
            raise TypeError, ""
        
        self.innerObject = obj
        self.innerMesh = obj.getData(mesh = True)
        
        if self.innerMesh == None:
            self.innerMesh = Mesh.New(self.innerObject.name)
            self.innerObject.link(self.innerMesh)
        
        self.innerObject.drawType = DrawTypes.WIRE
        self.innerObject.drawMode = DrawModes.XRAY
        
        self.vertexCount = 0
        self.faceIndexCount = 0
        self.boundingBoxMin = Vector().zero()
        self.boundingBoxMax = Vector().zero()
    
    def __readHeader(self, fs):
        self.vertexCount, \
        self.faceIndexCount = unpack('<2H', fs.read(4))
        self.boundingBoxMin = Vector(unpack('<3f', fs.read(12)))
        self.boundingBoxMax = Vector(unpack('<3f', fs.read(12)))
    
    def __prepareBoundingBox(self, gbf):
        if gbf.boundingBoxMin.magnitude > 0:
            self.boundingBoxMin = gbf.boundingBoxMin
        
        if gbf.boundingBoxMax.magnitude > 0:
            self.boundingBoxMax = gbf.boundingBoxMax
    
    def __readVertices(self, fs):
        delta = (self.boundingBoxMax - self.boundingBoxMin) / 0xffff
        
        for x in xrange(self.vertexCount):
            position = Vector(unpack('<3H', fs.read(6)))
            position.x *= delta.x
            position.y *= delta.y
            position.z *= delta.z
            position += self.boundingBoxMin
            self.innerMesh.verts.extend(position)
    
    def __readFaceIndices(self, fs):
        getFaceVertices = lambda i: self.innerMesh.verts[i / 3] 
        
        for x in xrange(self.faceIndexCount):
            faceVertices = map(getFaceVertices, unpack('<3H', fs.read(6)))
            self.innerMesh.faces.extend(faceVertices)
    
    def __readOctree(self, fs):
        print fs.tell()
        fs.read((self.faceIndexCount - 1) * 12)
    
    def readFromFile(self, fs, gbf):
        self.__readHeader(fs)
        self.__prepareBoundingBox(gbf)
        self.__readVertices(fs)
        self.__readFaceIndices(fs)
        self.__readOctree(fs)


class GeoBinFile(object):
    
    __slots__ = ('armature', 'materials', 'textures', 'meshes', 'animations', \
                 'collisionMesh', 'version', 'boneCount', 'isBoneFile', \
                 'materialCount', 'crc32', 'fileName', 'fileNameLength', \
                 'vertexCount', 'indexCount', 'boneIndexCount', \
                 'keyFrameCount', 'unknown0', 'descriptorSize', \
                 'collisionSize', 'transformationCount', 'animationCount', \
                 'meshCount', 'unknown1', 'boundingBoxMin', 'boundingBoxMax', \
                 'boundingSphereCenter', 'boundingSphereRadius')
    
    def __init__(self):
        self.armature = None
        self.materials = []
        self.textures = []
        self.meshes = []
        self.animations = None
        self.collisionMesh = None

        self.version = 8
        self.boneCount = 0
        self.isBoneFile = 0
        self.materialCount = 0
        self.crc32 = 0
        self.fileName = ''
        self.fileNameLength = len(self.fileName)
        self.vertexCount = None
        self.indexCount = 0
        self.boneIndexCount = 0 
        self.keyFrameCount = 0
        self.unknown0 = 0
        self.descriptorSize = 0
        self.collisionSize = 0
        self.transformationCount = 0
        self.animationCount = 0
        self.meshCount = 0
        self.unknown1 = 1
        self.boundingBoxMin = Vector().zero()
        self.boundingBoxMax = Vector().zero()
        self.boundingSphereCenter = Vector().zero()
        self.boundingSphereRadius = 0.0
    
    def __readHeader(self, fs):
        self.version, \
        self.boneCount, \
        self.isBoneFile, \
        self.materialCount = unpack('<4B', fs.read(4))
        
        if self.version > 9:
            self.crc32 = unpack('<I', fs.read(4))
        
        if self.version > 11:
            self.fileName = unpack('<64s', fs.read(64))
        
        self.fileNameLength = unpack('<I', fs.read(4))[0]
        
        self.vertexCount = list(unpack('<6H', fs.read(12)))
        
        if self.version > 8:
            self.vertexCount.extend(unpack('<6H', fs.read(12)))
        
        self.indexCount, \
        self.boneIndexCount, \
        self.keyFrameCount, \
        self.descriptorSize = unpack('<2H2I', fs.read(12))
        
        if self.version > 8:
            self.collisionSize = unpack('<I', fs.read(4))[0]
        
        self.transformationCount = unpack('<H', fs.read(2))[0]
        
        if self.version == 8:
            self.animationCount = unpack('<B', fs.read(1))[0]
        else:
            self.animationCount = unpack('<H', fs.read(2))[0]
        
        self.meshCount, \
        self.unknown1 = unpack('<2H', fs.read(4))
        
        self.boundingBoxMin = Vector()
        self.boundingBoxMax = Vector()
        
        if self.version > 10:
            self.boundingBoxMin = Vector(unpack('<3f', fs.read(12)))
            self.boundingBoxMax = Vector(unpack('<3f', fs.read(12)))
        
        self.boundingSphereCenter = Vector()
        self.boundingSphereRadius = 0.0
        
        if self.version > 8:
            self.boundingSphereCenter = Vector(unpack('<3f', fs.read(12)))
            self.boundingSphereRadius = unpack('<f', fs.read(4))[0]
    
    def __readArmature(self, fs):
        if self.isBoneFile == 1:
            self.armature = GeoBinArmature(Object.New('Armature', 'Armature.001'))
            self.armature.readFromFile(fs, self)
    
    def __readMaterials(self, fs):
        for x in xrange(self.materialCount):
            materialObject = GeoBinMaterial()
            materialObject.readFromFile(fs)
            self.materials.append(materialObject)
    
    def __readMeshes(self, fs):
        for x in xrange(self.meshCount):
            meshObject = GeoBinMesh(Object.New('Mesh', "Mesh.%03d" % x))
            meshObject.readFromFile(fs, self)
            self.meshes.append(meshObject)
    
    def __readAnimations(self, fs):
        self.animations = GeoBinAnimations()
        self.animations.readFromFile(fs, self)
    
    def __readCollisionMesh(self, fs):
        if self.collisionSize > 0:
            self.collisionMesh = GeoBinCollisionMesh(Object.New('Mesh', 'Collision_Mesh.001'))
            self.collisionMesh.readFromFile(fs, self)
    
    def __readDescriptor(self, fs, tfp = None, ext = None):
        descriptor = fs.read(self.descriptorSize)
        
        for material in self.materials:
            ambientR, ambientG, ambientB, ambientA, \
            diffuseR, diffuseG, diffuseB, diffuseA, \
            specularR, specularG, specularB, specularA, \
            specularPower = unpack('<12Bf', descriptor[material.materialOffset:material.materialOffset + 16])
            
            material.innerMaterial.setMirCol([float(x) / 255.0 for x in (ambientR, ambientG, ambientB)])
            material.innerMaterial.setRGBCol([float(x) / 255.0 for x in (diffuseR, diffuseG, diffuseB)])
            material.innerMaterial.setSpecCol([float(x) / 255.0 for x in (specularR, specularG, specularB)])
            material.innerMaterial.setSpec(specularPower)
            
            textureName = descriptor[material.textureNameOffset:descriptor.find('\0', material.textureNameOffset)]
            
            if tfp == None:
                tfp = ''
            
            textureFilePath = tfp + textureName
            
            if ext != None:
                textureFilePath = sys.makename(textureFilePath, '.' + ext)
            
            textureImage = GeoBinTextureImage()
            textureImage.loadFromPath(textureFilePath)
            self.textures.append(textureImage)
            
            material.innerMaterial.setTexture(0, textureImage.innerTexture, TexCo.UV)
        
        for mesh in self.meshes:
            mesh.innerMesh.materials = [self.materials[mesh.materialIndex].innerMaterial]
            meshName = descriptor[mesh.nameOffset:descriptor.find('\0', mesh.nameOffset)]
            mesh.innerObject.setName(meshName)
            mesh.innerMesh.name = meshName
            
            image = mesh.innerMesh.materials[0].getTextures()[0].tex.getImage()
            
            if image != None:
                for face in mesh.innerMesh.faces:
                    face.mode = FaceModes.TEX or FaceModes.TWOSIDE
                    face.image = image
    
    def readFromFile(self, fs, tfp = None, ext = None):
        self.__readHeader(fs)
        self.__readArmature(fs)
        self.__readMaterials(fs)
        self.__readMeshes(fs)
        self.__readAnimations(fs)
        self.__readCollisionMesh(fs)
        self.__readDescriptor(fs, tfp, ext)

