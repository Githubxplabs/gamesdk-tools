package gamesdk.tools.managers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import gamesdk.tools.ToolsConfig;
	import gamesdk.tools.ToolsMain;
	import gamesdk.tools.utils.ObjectUtils;
	import gamesdk.tools.utils.StringUtils;
	
	/**日志管理器*/
	public class LogManager extends Sprite
	{
		private var _msgs:Vector.<String> = new Vector.<String>();
		private var _box:Sprite;
		private var _textField:TextField;
		private var _filter:TextField;
		private var _filters:Array = [];
		private var _canScroll:Boolean = true;
		private var _scroll:TextField;
		
		private var _textLeading:int = 15;
		private var _textDisplayNum:int = 15;
		/** 虚拟滚轮的位置*/
		private var _virtualWheel:int;
		/** 过滤后的字符列表*/
		private var _filtered:Vector.<String> = new Vector.<String>();
		/** 当前需要显示的msg列表*/
		private var _needMsgs:Vector.<String>;
		private var _copyText:TextField;
		
		public function LogManager()
		{
			//容器
			_box = new Sprite();
			_box.addChild(ObjectUtils.createBitmap(400, 300, 0x333333, 0.9));
			_box.visible = false;
			addChild(_box);
			_box.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWhellHandler);
			
			//筛选栏
			_filter = new TextField();
			_filter.width = 270;
			_filter.height = 20;
			_filter.type = "input";
			_filter.textColor = 0xffffff;
			_filter.border = true;
			_filter.borderColor = 0xBFBFBF;
			_filter.defaultTextFormat = new TextFormat("Arial", 12);
			_filter.addEventListener(KeyboardEvent.KEY_DOWN, onFilterKeyDown);
			_filter.addEventListener(FocusEvent.FOCUS_OUT, onFilterFocusOut);
			_box.addChild(_filter);
			//控制按钮			
			var clear:TextField = createLinkButton("清除");
			clear.addEventListener(MouseEvent.CLICK, onClearClick);
			clear.x = 280;
			_box.addChild(clear);
			_scroll = createLinkButton("暂停");
			_scroll.addEventListener(MouseEvent.CLICK, onScrollClick);
			_scroll.x = 315;
			_box.addChild(_scroll);
			var copy:TextField = createLinkButton("拷贝");
			copy.addEventListener(MouseEvent.CLICK, onCopyClick);
			copy.x = 350;
			_box.addChild(copy);
			//信息栏
			_textField = new TextField();
			_textField.width = 400;
			_textField.height = 280;
			_textField.y = 20;
			_textField.multiline = true;
			_textField.wordWrap = true;
			//_textField.autoSize = true;
			//_textField.useRichTextClipboard = true;
			//_textField.mouseEnabled = false;
			_textField.defaultTextFormat = new TextFormat("微软雅黑,Arial");
			_box.addChild(_textField);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			_textDisplayNum = int(_textField.height / _textLeading);
			
			_copyText = new TextField();
			_copyText.width = 400;
			_copyText.height = 280;
			_copyText.wordWrap = true;
			_copyText.multiline = true;
		}
		
		private function mouseWhellHandler(e:MouseEvent):void
		{
			if (!_canScroll)
			{
				_virtualWheel -= e.delta;
				refresh();
			}
		}
		
		private function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
		}
		
		private function createLinkButton(text:String):TextField
		{
			var tf:TextField = new TextField();
			tf.selectable = false;
			tf.autoSize = "left";
			tf.textColor = 0x0080C0;
			tf.filters = [new GlowFilter(0xffffff, 0.8, 2, 2, 10)];
			tf.text = text;
			return tf;
		}
		
		private function onCopyClick(e:MouseEvent):void
		{
			var msg:String = "";
			var len:int = _needMsgs.length;
			for (var i:int = 0; i < len; i++)
			{
				msg += "[" + i + "]" + _needMsgs[i];
			}
			_copyText.htmlText = msg;
			System.setClipboard(_copyText.text);
			_copyText.text = "";
		}
		
		private function onScrollClick(e:MouseEvent):void
		{
			_canScroll = !_canScroll;
			_scroll.text = _canScroll ? "暂停" : "开始";
			if (_canScroll)
			{
				updateFilters();
				refresh();
			}
		}
		
		private function onClearClick(e:MouseEvent):void
		{
			_msgs.length = 0;
			_filters.length = 0;
			_textField.htmlText = "";
		}
		
		private function onFilterKeyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Keyboard.ENTER)
			{
				ToolsMain.stage.focus = _box;
			}
		}
		
		private function onFilterFocusOut(e:FocusEvent):void
		{
			_filters = StringUtils.isNotEmpty(_filter.text) ? _filter.text.split(",") : [];
			_filtered.length = 0;
			updateFilters();
			refresh();
		}
		
		private function onStageKeyDown(e:KeyboardEvent):void
		{
			if (e.ctrlKey && e.keyCode == Keyboard.L)
			{
				toggle();
			}
		}
		
		/**信息*/
		public function info(... args):void
		{
			print("info", args, 0x3EBDF4);
		}
		
		/**消息*/
		public function echo(... args):void
		{
			print("echo", args, 0x00C400);
		}
		
		/**调试*/
		public function debug(... args):void
		{
			print("debug", args, 0xdddd00);
		}
		
		/**错误*/
		public function error(... args):void
		{
			print("error", args, 0xFF4646);
		}
		
		/**警告*/
		public function warn(... args):void
		{
			print("warn", args, 0xFFFF80);
		}
		
		private function print(type:String, args:Array, color:uint):void
		{
			if (!ToolsConfig.debugConfig.isDebug)
				return;
			var msg:String = "<p><font color='#" + color.toString(16) + "'><b>[" + type + "]</b></font> <font color='#EEEEEE'>" + args.join(" ") + "</font></p>";
			if (ToolsConfig.debugConfig.isTrace)
				trace("[" + type + "]", args.join(" "));
			
			var msgsLen:int = _msgs.length;
			if (msgsLen > ToolsConfig.debugConfig.logInfoLength)
			{
				msgsLen = _msgs.length = 0;
			}
			_msgs[msgsLen] = msg;
			
			if (_filters.length > 0)
			{
				msgsLen = _filtered.length;
				if (msgsLen > ToolsConfig.debugConfig.logInfoLength)
				{
					msgsLen = _filtered.length = 0;
				}
				if (isFilter(msg))
				{
					_filtered[_filtered.length] = msg;
				}
			}
			
			if (_box.visible)
			{
				refresh();
			}
		}
		
		/** 更新需要显示的文本消息，主要更新偏移值*/
		private function updateNeedMsgs():void
		{
			if (_filters.length > 0)
				_needMsgs = _filtered;
			else
				_needMsgs = _msgs;
			
			var msgsLen:int = _needMsgs.length;
			//_virtualWheel为滚轮偏移量
			if (_canScroll)
			{
				if (_virtualWheel + _textDisplayNum <= msgsLen)
					_virtualWheel = msgsLen - _textDisplayNum;
				else
					_virtualWheel = 0;
			}
			else
			{
				if (_virtualWheel + _textDisplayNum >= msgsLen)
				{
					_virtualWheel = msgsLen - _textDisplayNum;
				}
				if (_virtualWheel < 0)
				{
					_virtualWheel = 0;
				}
			}
		}
		
		/**  更新过滤的文本内容*/
		private function updateFilters():void
		{
			if (_filters.length < 1)
				return;
			var len:int = _msgs.length;
			for (var i:int = 0; i < len; i++)
			{
				var item:String = _msgs[i];
				if (isFilter(item))
				{
					_filtered[_filtered.length] = item;
				}
			}
		}
		
		/**打开或隐藏面板*/
		public function toggle():void
		{
			if (ToolsConfig.debugConfig.isForeverLog && _box.visible)
				return;
			_box.visible = !_box.visible;
			if (_box.visible)
			{
				updateFilters();
				refresh();
			}
		}
		
		/**根据过滤刷新显示，并根据滚轮偏移量显示应该显示的文本条目*/
		private function refresh():void
		{
			updateNeedMsgs();
			var msg:String = "";
			var len:int;
			var i:int;
			len = _textDisplayNum > _needMsgs.length ? _needMsgs.length : _textDisplayNum;
			for (i = 0; i < len; i++)
			{
				var position:int = _virtualWheel + i;
				var item:String = _needMsgs[position];
				msg += "[" + position + "]" + item;
			}
			
			_textField.htmlText = msg;
			if (_canScroll)
				_textField.scrollV = _textField.maxScrollV;
			else
			{
				if (_virtualWheel + _textDisplayNum >= _needMsgs.length)
				{
					_textField.scrollV = _textField.maxScrollV;
				}
				else if (_virtualWheel < 1)
				{
					_textField.scrollV = 0;
				}
			}
		}
		
		/**是否是筛选属性*/
		private function isFilter(msg:String):Boolean
		{
			if (_filters.length < 1)
			{
				return true;
			}
			for each (var item:String in _filters)
			{
				if (msg.indexOf(item) > -1)
				{
					return true;
				}
			}
			return false;
		}
	}
}