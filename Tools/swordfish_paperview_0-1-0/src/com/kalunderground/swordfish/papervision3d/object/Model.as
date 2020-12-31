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
	
	import com.kalunderground.swordfish.papervision3d.object.GeometryBinary;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import org.papervision3d.core.Matrix3D;
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * The Model class acts as a container for loading Geometry Binary files.
	 */
	public class Model extends DisplayObject3D
	{
		
		/**
		 * Creates a new Model object.
		 * 
		 * @param	url		A String of a valid url path of this object.
		 * @param	materials	A MaterialsList object that contains the material properties of this object.
		 */
		public function Model(url:String, materials:MaterialsList=null)
		{
			this.name = url;
			this.materials = materials || new MaterialsList();
			
			loadFile(url);
		}
		
		/**
		 * Loads an xml file from a valid url path and creates a Model object.
		 * 
		 * @param	url		A String of a valid url path.
		 * @param	materials	A MaterialsList object that contains the material properties of the GeometryBinary object.
		 * @param	container	A DisplayObjectContainer3D object to host the GeometryBinary object.
		 * @param	name		A String of the GeometryBinary object name.
		 * @return	A Model object.
		 */
		public static function loadFile(url:String, materials:MaterialsList=null, container:DisplayObjectContainer3D=null, name:String=null):Model
		{
			var model:Model = new Model(url, materials);
			
			if (container != null) {
				container.addChild(model, name || url);
			}
			
			return model;
		}
		
		/**
		 * Loads an xml file from a valid url path.
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
				trace("error loading xml file.");
			}
		}
		
		/**
		 * 
		 * @param	xml	An XML transform structure.
		 * @return	A Matrix3D object.
		 */
		private function parseTranslation(xml:XML):Matrix3D
		{
			var x:Number = xml.translation.@x || 0.0;
			var y:Number = xml.translation.@y || 0.0;
			var z:Number = xml.translation.@z || 0.0;
			
			return Matrix3D.translationMatrix(x, y, z);
		}
		
		/**
		 * 
		 * @param	xml	An XML transform structure.
		 * @return	A Matrix3D object.
		 */
		private function parseRotation(xml:XML):Matrix3D
		{
			var x:Number = xml.rotation.@x || 0.0;
			var y:Number = xml.rotation.@y || 0.0;
			var z:Number = xml.rotation.@z || 0.0;
			var angle:Number = xml.rotation.@angle || 0.0;
			
			return Matrix3D.rotationMatrix(x, y, z, angle);
		}
		
		/**
		 * 
		 * @param	xml	An XML transform structure.
		 * @return	A Matrix3D object.
		 */
		private function parseScale(xml:XML):Matrix3D
		{
			var x:Number = xml.scale.@x || 0.0;
			var y:Number = xml.scale.@y || 0.0;
			var z:Number = xml.scale.@z || 0.0;
			
			return Matrix3D.scaleMatrix(x, y, z);
		}
		
		/**
		 * 
		 * @param	xml An XML model structure.
		 * @return	A Matrix3D object.
		 */
		private function parseTransform(xml:XML):Matrix3D
		{
			var transform:XML = xml.transform[0];
			var transformationMatrix:Matrix3D = Matrix3D.IDENTITY;
			
			if (transform) {
				transformationMatrix = Matrix3D.multiply(parseTranslation(transform), parseRotation(transform));
				// To-do: add scale transform.
			}
			
			return transformationMatrix;
		}
		
		/**
		 * Parses a geometry node.
		 * 
		 * @param	xml	An XML model structure.
		 */
		private function parseGeometry(xml:XML):void
		{
			for each (var geometry:String in xml.geometry) {
				addChild(new GeometryBinary(geometry, this.materials));
			}
		}
		
		/**
		 * URLLoader complete event callback handler.
		 * 
		 * @param	e	An Event object.
		 */
		private function completeHandler(e:Event):void
		{
			XML.ignoreComments = true;
			
			var loader:URLLoader = URLLoader(e.target);
			var xml:XML = new XML(loader.data);
			
			parseGeometry(xml);
			this.transform = parseTransform(xml);
		}
		
		/**
		 * URLLoader progress event callback handler.
		 * 
		 * @param	e	An ProgressEvent object.
		 */
		private function progressHandler(e:ProgressEvent):void
		{
			trace("Model.progressHandler, loaded: " + e.bytesLoaded + " total: " + e.bytesTotal);
		}
		
		/**
		 * URLLoader security error event callback handler.
		 * @param	e	An SecurityErrorEvent object.
		 */
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			var loadEvent:FileLoadEvent = new FileLoadEvent(FileLoadEvent.LOAD_ERROR, this.name);
			dispatchEvent(loadEvent);
			throw new Error("Model.securityErrorHandler error.");
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
			throw new Error("Model.ioErrorHandler error.");
		}
		
	}

}