/**
 * Copyright (c) 2007, Peter S. Stevens
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the author nor the names of its contributors
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package com.kalunderground.swordfish.papervision3d.object
{
	
	import com.kalunderground.swordfish.papervision3d.utility.Sheep;
	import com.kalunderground.swordfish.papervision3d.utility.TriangleHelper;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import org.papervision3d.Papervision3D;
	import org.papervision3d.core.NumberUV;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.geom.Mesh3D;
	import org.papervision3d.core.geom.Vertex3D;
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.core.proto.SceneObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * The GeometryBinary class allows you to load and parse Geometry Binary files.
	 */
	public class GeometryBinary extends DisplayObject3D
	{
		
		/**
		 * Internal triangle list parse byte.
		 */
		private static const TRIANGLE_LIST:int = 0;
		
		/**
		 * Internal triangle strip parse byte.
		 */
		private static const TRIANGLE_STRIP:int = 1;
		
		/**
		 * Internal scale factor.
		 */
		private static const SCALE_FACTOR:Number = 15.0;
		
		/**
		 * Geometry Binary Zlib file extension pattern.
		 */
		private static const GBZ_PATTERN:RegExp = /\w+\.gbz/gi;
		
		/**
		 * Creates a new GeometryBinary object.
		 * 
		 * @param	url		A String of a valid url path of this object.
		 * @param	materials	A MaterialsList object that contains the material properties of this object.
		 */
		public function GeometryBinary(url:String, materials:MaterialsList=null)
		{
			super();
			
			this.name = url;
			this.materials = materials || new MaterialsList();
			this._materialRefs = new Array();
			this._scaleFactor = SCALE_FACTOR;
			
			loadFile(url);
		}
		
		/**
		 * Loads a geometry binary file from a valid url path and creates a GeometryBinary object.
		 * 
		 * @param	url		A String of a valid url path.
		 * @param	materials	A MaterialsList object that contains the material properties of the GeometryBinary object.
		 * @param	container	A DisplayObjectContainer3D object to host the GeometryBinary object.
		 * @param	name		A String of the GeometryBinary object name.
		 * @return	A GeometryBinary object.
		 */
		public static function loadFile(url:String, materials:MaterialsList=null, container:DisplayObjectContainer3D=null, name:String=null):GeometryBinary
		{
			var geometry:GeometryBinary = new GeometryBinary(url, materials);
			
			if (container != null) {
				container.addChild(geometry, name || url);
			}
			
			return geometry;
		}
		
		/**
		 * Loads a geometry binary file from a valid url path.
		 * 
		 * @param	url		A String of a valid url path.
		 */
		public function loadFile(url:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, completeHandler);
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			var request:URLRequest = new URLRequest(this.name);
			
			try {
				loader.load(request);
			} catch(e:Error) {
				trace("error loading gb file.");
			}
		}
		
		/**
		 * Parses a geometry binary file's header.
		 * 
		 * @param	data	A ByteArray positioned at the file header.
		 */
		private function parseHeader(data:ByteArray):void
		{
			this._version = data.readUnsignedByte();
			
			data.position += 2;
			
			this._meshCount = data.readUnsignedByte();
			
			if (_version > 9) {
				data.position += 4;
			}
			
			if (_version > 11) {
				data.position += 64;
			}
			
			data.position += 4;
			
			if (_version == 8) {
				data.position += 12;
			} else {
				data.position += 24;
			}
			
			data.position += 8;
			
			this._descriptorLength = data.readUnsignedInt();
			
			if (_version > 8) {
				data.position += 4;
			}
			
			data.position += 2;
			
			if (_version == 8) {
				data.position += 1;
			} else {
				data.position += 2;
			}
			
			this._materialCount = data.readUnsignedShort();
			
			data.position += 2;
			
			if (_version > 10) {
				data.position += 24;
			}
			
			if (_version > 8) {
				data.position += 16;
			}
		}
		
		/**
		 * Parses a materials header and creates a MaterialObject3D object.
		 * 
		 * @param	data	A ByteArray positioned at the first available material header.
		 * @return	A new MaterialObject3D object.
		 */
		private function parseMaterial(data:ByteArray):MaterialObject3D
		{
			var bitmapNameIndex:uint = data.readUnsignedInt();
			var bitmapMapOption:uint = data.readUnsignedShort();
			var bitmapNameLength:uint = data.readUnsignedInt();
			var bitmapOverlayIndex:uint = data.readUnsignedInt();
			var materialIndex:uint = data.readUnsignedInt();
			
			var dataPosition:uint = data.position;
			
			data.position = data.length - this._descriptorLength + bitmapNameIndex;
			
			var bitmapName:String = new String();
			
			if (bitmapNameLength == 0) { // oh why have they forgotten the bitmap name length?
				var stringBuffer:ByteArray = new ByteArray();
				stringBuffer.endian = Endian.LITTLE_ENDIAN;
				
				var char:int = 0;
				
				while ((char = data.readByte()) != 0) {
					stringBuffer.writeByte(char);
				}
				
				stringBuffer.position = 0;
				
				bitmapName = stringBuffer.readMultiByte(stringBuffer.length, "us-ascii");
			} else {
				bitmapName = data.readMultiByte(bitmapNameLength, "us-ascii");
			}
			
			data.position = dataPosition;
			
			var material:MaterialObject3D = this.materials.getMaterialByName(bitmapName);
			
			if (!material) { // only load the bitmap if necessary
				material = new BitmapFileMaterial(bitmapName.replace("dds", "png"));
				material.lineColor = material.fillColor = 0xff00ff;
				material.smooth = true;
				material.oneSide = true;
				material.doubleSided = false;
				this.materials.addMaterial(material, bitmapName);
			}
			
			this._materialRefs.push(material);
			
			return material;
		}
		
		/**
		 * Parses a meshes geometry and creates a Mesh3D object.
		 * 
		 * @param	data	A ByteArray positioned at the first available mesh.
		 * @return	A new Mesh3D object.
		 */
		private function parseMesh(data:ByteArray):Mesh3D
		{
			var nameIndex:uint = data.readUnsignedInt();
			var materialIndex:uint = data.readUnsignedInt();
			var vertexType:uint = data.readUnsignedByte();
			var triangleType:uint = data.readUnsignedByte();
			var vertexCount:uint = data.readUnsignedShort();
			var indexCount:uint = data.readUnsignedShort();
			var jointInfluenceCount:uint = data.readUnsignedByte();
			
			if (jointInfluenceCount > 0) {
				data.position += jointInfluenceCount;
			}
			
			var positions:Array = new Array();
			var normals:Array = new Array();
			var uvs:Array = new Array();
			var i:int = vertexCount;
			
			while (i--) {
				positions.push(new Vertex3D(data.readFloat() * this._scaleFactor,
				                            data.readFloat() * this._scaleFactor,
											data.readFloat() * this._scaleFactor));
				
				// lions, tigers, and bears... oh my!
				var step:uint = (vertexType % 6) << 2;
				
				if (this._version > 10) {
					data.position += step;
				} else {
					if (vertexType != 0) {
						data.position += step - 4;
					}
				}
				
				/* the future may deem this usable
				normals.push(new Vertex3D(data.readFloat() * this._scaleFactor,
				                          data.readFloat() * this._scaleFactor,
										  data.readFloat() * this._scaleFactor));*/
				
				data.position += 12;
				
				// negate papervision3d's vertical flip
				uvs.push(new NumberUV(data.readFloat(), 1.0 - data.readFloat()));
			}
			
			var faces:Array = new Array();
			
			if (triangleType == TRIANGLE_LIST) {
				i = indexCount;
				
				while (i--) {
					var pointA:uint = data.readUnsignedShort();
					var pointB:uint = data.readUnsignedShort();
					var pointC:uint = data.readUnsignedShort();
					
					faces.push(new Face3D([positions[pointA], positions[pointB], positions[pointC]], null, [uvs[pointA], uvs[pointB], uvs[pointC]]));
				}
			} else if (triangleType == TRIANGLE_STRIP) {
				var stripQueue:Array = [data.readUnsignedShort(), data.readUnsignedShort(), data.readUnsignedShort()];
				
				i = indexCount - stripQueue.length;
				
				while (i--) { // destripify
					var triangle:Array = Sheep.clone(stripQueue);
					
					if (!(i % 2)) {
						triangle.reverse();
					}
					
					if (!TriangleHelper.isDegenerate(triangle)) {
						pointA = triangle[0];
						pointB = triangle[1];
						pointC = triangle[2];
						
						faces.push(new Face3D([positions[pointA], positions[pointB], positions[pointC]], null, [uvs[pointA], uvs[pointB], uvs[pointC]]));
					}
					
					stripQueue.push(data.readUnsignedShort());
					stripQueue.shift();
				}
			}
			
			var mesh:Mesh3D = new Mesh3D(this._materialRefs[materialIndex], positions, faces);
			
			addChild(mesh);
			
			return mesh;
		}
		
		/**
		 * URLLoader complete event callback handler.
		 * 
		 * @param	e	An Event object.
		 */
		private function completeHandler(e:Event):void
		{
			var loader:URLLoader = URLLoader(e.target);
			var data:ByteArray = loader.data;
			data.endian = Endian.LITTLE_ENDIAN;
			
			var zlib:uint = data.readUnsignedShort();
			
			data.position = 0;
			
			// assume only the zlib cmt/flg that of ByteArray.compress() Z_BEST_COMPRESSION (9)
			if (this.name.search(GBZ_PATTERN) != -1 && zlib == 0xda78) { 
				data.uncompress();
			}
			
			parseHeader(data);
			
			var i:int = this._materialCount;
			
			while (i--) {
				parseMaterial(data);
			}
			
			i = this._meshCount;
			
			while (i--) {
				parseMesh(data);
			}
		}
		
		/**
		 * URLLoader progress event callback handler.
		 * 
		 * @param	e	An ProgressEvent object.
		 */
		private function progressHandler(e:ProgressEvent):void
		{
			trace("GeometryBinary.progressHandler, loaded: " + e.bytesLoaded + " total: " + e.bytesTotal);
		}
		
		/**
		 * URLLoader security error event callback handler.
		 * @param	e	An SecurityErrorEvent object.
		 */
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			var loadEvent:FileLoadEvent = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, this.name);
			dispatchEvent(loadEvent);
			throw new Error("GeometryBinary.securityErrorHandler error.");
		}
		
		/**
		 * URLLoader io error event callback handler.
		 * 
		 * @param	e	An IOErrorEvent object.
		 */
		private function ioErrorHandler(e:IOErrorEvent):void
		{
			var loadEvent:FileLoadEvent = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, this.name);
			dispatchEvent(loadEvent);
			throw new Error("GeometryBinary.ioErrorHandler error.");
		}
		
		private var _version:uint;
		private var _meshCount:uint;
		private var _descriptorLength:uint;
		private var _materialCount:uint;
		private var _materialRefs:Array;
		private var _scaleFactor:Number;
		
	}
	
}
