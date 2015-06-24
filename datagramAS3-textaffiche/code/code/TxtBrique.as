package code
{
	
	import flash.display.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextLineMetrics;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import frocessing.color.ColorHSV;
	
	//import flupie.textanim.*;
	//import caurina.transitions.*;
	
	
	class TxtBrique extends Sprite {
		
		
		
		
		private var _lastTime:int;
		
		private var bl:Number = (getTimer() / 50) % 360;
		public var col:ColorHSV = new ColorHSV((getTimer() / 50) % 360);
		public var age:int=0;
		public var state:int=0;
		public var glowing:Boolean = true;
		
		public var age1 : int = 300;
		public var age2 : int = 400;
		public var age3 : int = 500;
		
		var fmt:TextFormat = new TextFormat('Verdana', 54, 0xFF00FF, true); //entre 20 et 40?
		var tf:TextField = new TextField();
		
		var _waraImageGlow:BitmapData;
		var tmpG:BitmapData;
		var ptZero:Point = new Point();
		var bmdMask:BitmapData;
		var counter:Number = 1;
		var mskY:Number;
		
		var bitm:Bitmap;	
		var bGlow:Bitmap;
		
		var timer:Timer;
		var letexte:String
		
		public function TxtBrique(tx:String, agea:int, ageb:int, agec:int) {
		
			age1 = agea;
			age2 = ageb;
			age3 = agec;
			letexte= tx;
			
			_lastTime = getTimer();
	
			//tf.backgroundColor = 0xFF0000;
			//tf.background=true;
			//tf.border = true;
			fmt.leading = Main.lead;//-10; // en fonction de la taille de typo
			tf.defaultTextFormat = fmt;
			tf.autoSize = TextFieldAutoSize.LEFT;
			tf.text = tx;//+"\n"+"yoyoy";//'balablabal';
			
			var maxWidth:Number = Main.cadreX;//250;	
			fmt.size = Main.typo;//Math.random()*8 + 20; // size en fonction du nombre de char
			
			var red:int=Math.random()*150+105; //values for 105 to 255
			var green:int=Math.random()*150+105;
			var blue:int=Math.random()*150+105;
			var colo:uint = (red*256*256)+(green*256)+blue;
			fmt.color =  0xFFFFFF;//colo; //RGB value;
			tf.setTextFormat(fmt);
			
			tf.multiline = false;
			tf.wordWrap = false;
			if (tf.width > maxWidth)
			{
				tf.multiline = true;
				tf.wordWrap = true;
				tf.width = maxWidth;
				
			}else {
				fmt.leading+=8;
				tf.setTextFormat(fmt);
			}
		
			/*
			var myAnim:TextAnim = new TextAnim(tf);
			myAnim.mode = TextAnimMode.CENTER_EDGES;
			myAnim.blocksVisible = false;
			myAnim.effects = myEffect;
			myAnim.start();
			*/
			

			var tmp:BitmapData=new BitmapData(tf.width, tf.height, true, 0x00000000)
			tmp.draw(tf);
			var rect:Rectangle = tmp.getColorBoundsRect(0xff000000, 0xff000000, true);
			var _waraImage:BitmapData = new BitmapData(rect.width+3, rect.height+3, true, 0x00000000);
			_waraImage.draw(tmp, new Matrix(1, 0, 0, 1, -rect.x+1, -rect.y+1));
			bitm = addChild(new Bitmap(_waraImage)) as Bitmap;
			
			tmpG = new BitmapData(tf.width, tf.height, true, 0x00000000);
			tmpG.draw(tf);
			var glow1:GlowFilter = new GlowFilter(0xFFFFFF, .9, 10, 10, 4); // .9 8 8 4
			//var glow2:BlurFilter = new BlurFilter(3, 3, 1); // .9 8 8 4
			tmpG.applyFilter(tmpG, tmpG.rect, ptZero, glow1);
			//tmpG.applyFilter(tmpG, tmpG.rect, ptZero, glow2);
			
			_waraImageGlow = new BitmapData(rect.width+3, rect.height+3, true, 0x00000000);
			_waraImageGlow.draw(tmpG, new Matrix(1, 0, 0, 1, -rect.x+1, -rect.y+1));
			//_waraImageGlow = new BitmapData(tmpG.width+5, tmpG.height+5, true, 0xff000000);
			 bGlow = addChild(new Bitmap(_waraImageGlow)) as Bitmap;
			//b.bitmapData=_waraImageGlow;
	
			
			
			
				// Create a mask sprite.
				var msk:Sprite = new Sprite();
				msk.graphics.beginGradientFill("radial", [0xffffff, 0xffffff], [1, 0], [64, 255]);
				msk.graphics.drawCircle(0, 0, 100);
				msk.graphics.endFill();
				
				// Create a mask BitmapData using mask sprite.
				bmdMask = new BitmapData(200, 200, true, 0x00000000);
				var mtx:Matrix = new Matrix();
				mtx.translate(100, 100);
				bmdMask.draw(msk, mtx);

				mskY = 100-_waraImageGlow.height / 2;

			
			bGlow.scaleX = 1.03
			bGlow.scaleY = 1.10;
			bGlow.x = -(bGlow.width) / 2; //+7
			bGlow.y = -(bGlow.height) / 2; //+15
			
			bitm.scaleX = bitm.scaleY = 1;
			bitm.x = -bitm.width / 2;//+3;
			bitm.y = -bitm.height / 2;//+8;
			if ((bl>215)&&(bl<265)) var more : Number = .4
			else more = 0;	
			transform.colorTransform = new ColorTransform(col.r / 255+Math.random()*.7+.2+more, col.g / 255+Math.random()*.7+.2+more, col.b / 255+Math.random()*.7+.2+more);
			
			this.graphics.beginFill(0xFFFFFF, .3);
			this.graphics.lineStyle(3 , 0xFFFFFF);
			this.graphics.drawRect(-this.width/2, -this.height/2, this.width , this.height);
			this.graphics.endFill();
			
			 // effet contour blanc
		/*	var myGlow:GlowFilter = new GlowFilter(); 
			myGlow.color = 0xFFFFFF;
			myGlow.blurX = 5;
			myGlow.blurY = 5; 
			myGlow.quality = 1;
			myGlow.strength = 255;
			//myGlow.alpha = alpha_;
			this.filters = [myGlow];
			*/
			
			timer = new Timer(40, 10000);//vie en frame : 40sec
			timer.addEventListener(TimerEvent.TIMER, cochange);
			timer.start();
			
			//var age:int = 100;
		}
		
		public function sender(){
			if(this.parent.parent != null){
				var parentObj:Object = this.parent.parent as Object;
				parentObj._reseau.sender("touche");
			}	
		}
		

		
		/*function myEffect(block:TextAnimBlock):void 
		{
			block.scaleX = 2;
			block.scaleY = 0;
			Tweener.addTween(block, {scaleX:1, scaleY:1, time:1, transition:"easeoutelastic"});
		}
		*/
		
		public function cochange(e:Event) {
			age++;		
			
			if (glowing){
			
				/*tf.text = "oihhii";
				var tmp:BitmapData=new BitmapData(tf.width, tf.height, true, 0x00000000)
				tmp.draw(tf);
				var rect:Rectangle = tmp.getColorBoundsRect(0xff000000, 0xff000000, true);
				var _waraImage:BitmapData = new BitmapData(rect.width+5, rect.height+5, true, 0x00000000);
				_waraImage.draw(tmp, new Matrix(1, 0, 0, 1, -rect.x+2, -rect.y+2));
				removeChild(bitm);
				 bitm = addChild(new Bitmap(_waraImage)) as Bitmap;
				*/
				
			/*_waraImageGlow.fillRect(_waraImageGlow.rect, 0x00000000);
			_waraImageGlow.copyPixels(tmpG, tmpG.rect, ptZero, 
				bmdMask,                            // alphaBitmap
				new Point(200 - counter, mskY),     // alphaPoint
				true                                // mergeAlpha
			);
				counter += 15;
				if (counter > Main.cadreX+200)	{
				counter = -10;
				glowing = false;
				}
			*/
				bGlow.alpha = counter;	
				counter -= .08
					if (counter <-0){
						counter = 1;
						glowing = false;
						
					}
				
			
				
		
				
			
			
			}
			
			if (age<50){	
			//var col:ColorHSV = new ColorHSV((getTimer()-_lastTime / 30) % 360);
			//transform.colorTransform = new ColorTransform(col.r / age*10+2, col.g / age*10+1, col.b / age*10+5);
				
			}		
			
			if (age == age1) state=1;//disparait
			if (age == age2) state=2;
			if (age == age3) state=3;//kill
		}
	}
}
