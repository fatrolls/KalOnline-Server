#!BPY

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

"""
Name: 'Geometry Binary (.gb)...'
Blender: 245
Group: 'Import'
Tooltip: 'Import Geometry Binary files (*.gb)'
"""

__author__ = 'Peter S. Stevens'
__email__ = 'pstevens:cryptomail*org'
__url__ = ('blender', 'elysiun', 'Project homepage, http://www.kalzone.org/')
__version__ = '0.4.0'
__bpydoc__ = """ \
This script imports Geomentry Binary (*.gb) files.
"""

import Blender
from Blender import BGL, Draw, Modifier, Scene, sys, Window
from Blender.Window import *
from Blender.Mesh import *
from Blender.Mathutils import *
from swordfish_gb import *

PROPERTIES = {}

# Property constants
SCALE_MIN = -10
SCALE_MAX = 10
ROTATION_MIN = -360
ROTATION_MAX = 360
MODEL_FILE_MAX = 10


# Event constants
EVENT_NONE = 0
EVENT_EXIT = 1
EVENT_IMPORT = 2
EVENT_MODEL_FILE_INDEX_CHANGED = 4
EVENT_MODEL_FILE_CHANGED = 5
EVENT_MODEL_FILE_REMOVED = 6
EVENT_BROWSE_MODEL_FILE = 20
EVENT_BROWSE_BONE_FILE = 21
EVENT_BROWSE_ANIME_FILE = 22
EVENT_BROWSE_TEX_PATH = 23

TEXTURE_EXTENSIONS = ('bmp', 'gif', 'jpg', 'png', 'tga')


def ui_set_property_defaults():
    global PROPERTIES
    
    PROPERTIES['MODEL_FILES'] = []
    PROPERTIES['MODEL_FILE_INDEX'] = Draw.Create(-1)
    PROPERTIES['MODEL_FILE'] = Draw.Create('')
    PROPERTIES['TEX_PATH'] = Draw.Create(Blender.Get('texturesdir'))
    PROPERTIES['BONE_FILE'] = Draw.Create('')
    PROPERTIES['ANIME_FILE'] = Draw.Create('')
    PROPERTIES['SCALE'] = Draw.Create(1)
    PROPERTIES['ROTX'] = Draw.Create(90)
    PROPERTIES['ROTY'] = Draw.Create(0)
    PROPERTIES['ROTZ'] = Draw.Create(180)
    PROPERTIES['FLIP_NORM'] = Draw.Create(True)
    PROPERTIES['SMOOTH'] = Draw.Create(True)
    PROPERTIES['COL_MESH'] = Draw.Create(False)
    PROPERTIES['TEX_EXT_OVERRIDE'] = Draw.Create(False)
    PROPERTIES['TEX_EXT_INDEX'] = Draw.Create(0)


def ui_file_path_exists_event(evt, val):
    if val and not sys.exists(val):
        Draw.PupMenu('Warning%%t|The file %s does not exist.' % val)


def ui_browse_button_event(evt, val):
    def ui_set_file_property(fp):
        global PROPERTIES
        
        ui_file_path_exists_event(evt, fp) # Warn the user if the file doesn't exist
        
        if evt == EVENT_BROWSE_MODEL_FILE:
            MODEL_FILE_length = len(PROPERTIES['MODEL_FILES'])
            
            if MODEL_FILE_length < MODEL_FILE_MAX:
                PROPERTIES['MODEL_FILE_INDEX'].val = len(PROPERTIES['MODEL_FILES'])
                PROPERTIES['MODEL_FILES'].append(fp)
                PROPERTIES['MODEL_FILE'].val = fp
            else:
                Draw.PupMenu('Error%t|Maximum mesh file limit reached.')
        
        if evt == EVENT_BROWSE_BONE_FILE:
            PROPERTIES['BONE_FILE'].val = fp
        
        if evt == EVENT_BROWSE_ANIME_FILE:
            PROPERTIES['ANIME_FILE'].val = fp
        
        if evt == EVENT_BROWSE_TEX_PATH:
            PROPERTIES['TEX_PATH'].val = fp
    
    if evt == EVENT_BROWSE_TEX_PATH:
        Window.FileSelector(ui_set_file_property, 'Ok', '')
    else:
        Window.FileSelector(ui_set_file_property, 'Ok', sys.makename(ext='.gb'))


def ui_button_event(evt):
    global PROPERTIES
    
    if evt == EVENT_MODEL_FILE_INDEX_CHANGED:
        MODEL_FILE_INDEX = PROPERTIES['MODEL_FILE_INDEX'].val
        
        if MODEL_FILE_INDEX > -1:
            PROPERTIES['MODEL_FILE'].val = PROPERTIES['MODEL_FILES'][MODEL_FILE_INDEX]
    
    if evt == EVENT_MODEL_FILE_CHANGED:
        MODEL_FILE_INDEX = PROPERTIES['MODEL_FILE_INDEX'].val
        
        if MODEL_FILE_INDEX > -1:
            ui_file_path_exists_event(evt, PROPERTIES['MODEL_FILE'].val) # Warn the user if the file doesn't exist
            
            PROPERTIES['MODEL_FILES'][MODEL_FILE_INDEX] = PROPERTIES['MODEL_FILE'].val
    
    if evt == EVENT_MODEL_FILE_REMOVED:
        MODEL_FILE_INDEX = PROPERTIES['MODEL_FILE_INDEX'].val
        
        if MODEL_FILE_INDEX > -1:
            result = Draw.PupMenu("Remove %s?" % PROPERTIES['MODEL_FILES'][MODEL_FILE_INDEX] + "%t|Yes|No")
            
            if result == -1 or result == 2:
                Draw.Redraw(1)
                return
            
            PROPERTIES['MODEL_FILE'].val = ''
            
            PROPERTIES['MODEL_FILES'].pop(MODEL_FILE_INDEX)
            
            if MODEL_FILE_INDEX >= len(PROPERTIES['MODEL_FILES']):
                MODEL_FILE_INDEX -= 1
                PROPERTIES['MODEL_FILE_INDEX'].val = MODEL_FILE_INDEX
            
            if MODEL_FILE_INDEX > -1:
                PROPERTIES['MODEL_FILE'].val = PROPERTIES['MODEL_FILES'][MODEL_FILE_INDEX]
    
    if evt == EVENT_IMPORT:
        if not len(PROPERTIES['MODEL_FILES']):
            Draw.PupMenu('Error%t|No model files to import.')
        else:
            transformationMatrix = Matrix().identity()
            
            transformationMatrix *= ScaleMatrix(PROPERTIES['SCALE'].val, 4)
            transformationMatrix *= RotationMatrix(PROPERTIES['ROTX'].val, 4, 'x')
            transformationMatrix *= RotationMatrix(PROPERTIES['ROTY'].val, 4, 'y')
            transformationMatrix *= RotationMatrix(PROPERTIES['ROTZ'].val, 4, 'z')
            
            Window.WaitCursor(1)
            
            scene = Scene.GetCurrent()
            
            render = scene.render
            
            render.framesPerSec(FRAMES_PER_SEC)
            
            armatureFile = None
            
            fileStream = None
            
            if len(PROPERTIES['BONE_FILE'].val) > 0:
                try:
                    fileStream = open(PROPERTIES['BONE_FILE'].val, 'rb')
                    armatureFile = GeoBinFile()
                    armatureFile.readFromFile(fileStream)
                    
                    if armatureFile.armature != None:
                        scene.objects.link(armatureFile.armature.innerObject)
                        armatureFile.armature.innerObject.setMatrix(transformationMatrix)
                    else:
                        armatureFile = None
                except IOError:
                    pass
                finally:
                    fileStream.close()
            
            if len(PROPERTIES['ANIME_FILE'].val) > 0:
                try:
                    fileStream = open(PROPERTIES['ANIME_FILE'].val, 'rb')
                    animationFile = GeoBinFile()
                    animationFile.readFromFile(fileStream)
                    
                    if animationFile.animations != None and len(animationFile.animations) > 0:
                        armatureFile.armature.applyAnimation(animationFile.animations, 0)
                    
                    if len(animationFile.animations[0].keyFrames) > 0:
                        render.endFrame(animationFile.animations[0].keyFrames[-1].index)
                except IOError:
                    pass
                finally:
                    fileStream.close()
            
            textureExtension = None
            
            if PROPERTIES['TEX_EXT_OVERRIDE'].val == True:
                textureExtension = TEXTURE_EXTENSIONS[PROPERTIES['TEX_EXT_INDEX'].val]
            
            for filePath in PROPERTIES['MODEL_FILES']:
                try:
                    fileStream = open(filePath, 'rb')
                    meshFile = GeoBinFile()
                    meshFile.readFromFile(fileStream, PROPERTIES['TEX_PATH'].val, textureExtension)
                    
                    for mesh in meshFile.meshes:
                        scene.objects.link(mesh.innerObject)
                        mesh.innerObject.setMatrix(transformationMatrix)
                        
                        if PROPERTIES['FLIP_NORM'].val == True:
                            mesh.innerMesh.flipNormals()
                            mesh.innerMesh.update()
                        
                        if PROPERTIES['SMOOTH'].val == True:
                            mesh.setSmooth(PROPERTIES['SMOOTH'].val)
                        
                        if armatureFile != None:
                            mesh.setArmature(armatureFile.armature)
                    
                    if meshFile.collisionMesh != None and PROPERTIES['COL_MESH'].val == True:
                        scene.objects.link(meshFile.collisionMesh.innerObject)
                        meshFile.collisionMesh.innerObject.setMatrix(transformationMatrix)
                        
                        if PROPERTIES['FLIP_NORM'].val == True:
                            meshFile.collisionMesh.innerMesh.flipNormals()
                        
                        meshFile.collisionMesh.innerMesh.update()
                except IOError:
                    pass
                finally:
                    fileStream.close()
            
            Window.WaitCursor(0)
            Draw.Exit()
            return
    
    if evt == EVENT_EXIT:
        Draw.Exit()
        return
    
    Draw.Redraw(1)


def ui_event(evt, val):
    if evt == Draw.ESCKEY:
        ui_button_event(EVENT_EXIT)
        return


def ui_draw():
    global PROPERTIES
    
    theme = Theme.Get()[0]
    
    buttonSpace = theme.get('buts')
    
    if buttonSpace != None:
        backgroundColor = buttonSpace.back
        
        BGL.glClearColor(*[float(x) / 255.0 for x in backgroundColor])
        BGL.glClear(BGL.GL_COLOR_BUFFER_BIT)
    
    Draw.BeginAlign()
    MODEL_FILES = '|'.join(["%s %%x%s" % (file_path, i) for i, file_path in enumerate(PROPERTIES['MODEL_FILES'])])
    PROPERTIES['MODEL_FILE_INDEX'] = Draw.Menu(MODEL_FILES, EVENT_MODEL_FILE_INDEX_CHANGED, 10, 250, 20, 20, PROPERTIES['MODEL_FILE_INDEX'].val, 'Model files')
    
    width = 275
    
    if len(PROPERTIES['MODEL_FILES']) > 0:
        width -= 75
    
    PROPERTIES['MODEL_FILE'] = Draw.String('Model File: ', EVENT_MODEL_FILE_CHANGED, 30, 250, width, 20, PROPERTIES['MODEL_FILE'].val, 255, 'Model file')
    
    if len(PROPERTIES['MODEL_FILES']) > 0: 
        Draw.PushButton('Remove', EVENT_MODEL_FILE_REMOVED, 230, 250, 75, 20, 'Remove selected model file')
    
    Draw.PushButton('Add...', EVENT_BROWSE_MODEL_FILE, 305, 250, 75, 20, 'Add new model file', ui_browse_button_event)
    Draw.EndAlign()
    
    Draw.BeginAlign()
    PROPERTIES['BONE_FILE'] = Draw.String('Bone File: ', EVENT_NONE, 10, 220, 295, 20, PROPERTIES['BONE_FILE'].val, 255, 'Bone file', ui_file_path_exists_event) 
    Draw.PushButton('Browse...', EVENT_BROWSE_BONE_FILE, 305, 220, 75, 20, 'Browse for bone file', ui_browse_button_event)
    Draw.EndAlign()
    
    Draw.BeginAlign()
    PROPERTIES['ANIME_FILE'] = Draw.String('Animation File: ', EVENT_NONE, 10, 190, 295, 20, PROPERTIES['ANIME_FILE'].val, 255, 'Animation file', ui_file_path_exists_event) 
    Draw.PushButton('Browse...', EVENT_BROWSE_ANIME_FILE, 305, 190, 75, 20, 'Browse for animation file', ui_browse_button_event)
    Draw.EndAlign()
    
    Draw.BeginAlign()
    PROPERTIES['TEX_PATH'] = Draw.String('Texture Path: ', EVENT_NONE, 10, 160, 295, 20, PROPERTIES['TEX_PATH'].val, 255, 'Texture Path', ui_file_path_exists_event) 
    Draw.PushButton('Browse...', EVENT_BROWSE_TEX_PATH, 305, 160, 75, 20, 'Browse for texture path', ui_browse_button_event)
    
    width = 370
    
    if PROPERTIES['TEX_EXT_OVERRIDE'].val == True:
        width -= 75
    
    PROPERTIES['TEX_EXT_OVERRIDE'] = Draw.Toggle('Override Texture Extension...', EVENT_NONE, 10, 140, width, 20, PROPERTIES['TEX_EXT_OVERRIDE'].val, 'Override Texture Extension')
    
    if PROPERTIES['TEX_EXT_OVERRIDE'].val == True:
        TEX_EXTS = 'Texture Extension %t|' + '|'.join(["%s %%x%s" % (extension, i) for i, extension in enumerate(TEXTURE_EXTENSIONS)])
        PROPERTIES['TEX_EXT_INDEX'] = Draw.Menu(TEX_EXTS, EVENT_NONE, 305, 140, 75, 20, PROPERTIES['TEX_EXT_INDEX'].val, 'Texture Extension')
    Draw.EndAlign()
    
    Draw.BeginAlign()
    PROPERTIES['SCALE'] = Draw.Slider('Scale:', EVENT_NONE, 10, 110, 140, 20, PROPERTIES['SCALE'].val, SCALE_MIN, SCALE_MAX, 1, 'Scale')
    PROPERTIES['ROTX'] = Draw.Slider('RotX:', EVENT_NONE, 10, 90, 140, 20, PROPERTIES['ROTX'].val, ROTATION_MIN, ROTATION_MAX, 1, 'Degrees of rotation on the X axis')
    PROPERTIES['ROTY'] = Draw.Slider('RotY:', EVENT_NONE, 10, 70, 140, 20, PROPERTIES['ROTY'].val, ROTATION_MIN, ROTATION_MAX, 1, 'Degrees of rotation on the Y axis')
    PROPERTIES['ROTZ'] = Draw.Slider('RotZ:', EVENT_NONE, 10, 50, 140, 20, PROPERTIES['ROTZ'].val, ROTATION_MIN, ROTATION_MAX, 1, 'Degrees of rotation on the Z axis')
    Draw.EndAlign()
    
    Draw.BeginAlign()
    PROPERTIES['FLIP_NORM'] = Draw.Toggle('Flip Normals', EVENT_NONE, 155, 110, 110, 20, PROPERTIES['FLIP_NORM'].val, 'Flip Normals')
    PROPERTIES['SMOOTH'] = Draw.Toggle('Smooth Faces', EVENT_NONE, 155, 90, 110, 20, PROPERTIES['SMOOTH'].val, 'Smooth Faces')
    Draw.EndAlign()
    
    PROPERTIES['COL_MESH'] = Draw.Toggle('Collision Mesh', EVENT_NONE, 270, 110, 110, 20, PROPERTIES['COL_MESH'].val, 'Collision Mesh')
    
    Draw.PushButton('Import', EVENT_IMPORT, 225, 10, 75, 20, 'Import')
    Draw.PushButton('Cancel', EVENT_EXIT, 305, 10, 75, 20, 'Cancel')


def main():
    ui_set_property_defaults()
    
    Draw.Register(ui_draw, ui_event, ui_button_event)


if __name__ == '__main__':
    main()
