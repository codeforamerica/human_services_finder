// handles creating a fixed search header when scrolling
define(['util/util'],
	function(util) {
  'use strict';

		var _header;
		var _offsetY;
		var _floating = false;
		var _floatingContent;

		function init()
		{
			_header = document.getElementById("floating-results-header");
			//_offsetY = document.getElementById('content-header').offsetHeight;
			var doc = document.documentElement, body = document.body;
			var lastScroll = (doc && doc.scrollTop  || body && body.scrollTop  || 0);
			window.scrollTo(0, 0);
			_offsetY = util.getOffset(_header).top;
			_floatingContent = document.querySelector('#floating-results-header .floating-content');

			window.scrollTo(0, lastScroll);
			_checkIfFloating();

			window.addEventListener("scroll",_onScroll,false);
		}

		function _onScroll(evt)
		{
			_checkIfFloating();
		}

		function _checkIfFloating()
		{
			if (window.scrollY >= _offsetY)
			{
				// fix header
				if (!_floating)
				{
					_header.classList.add("floating");
					_floatingContent.classList.remove('hide');
					_floating = true;
				}
			}
			else
			{
				// reset header
				if (_floating)
				{
					_header.classList.remove("floating");
					_floatingContent.classList.add('hide');
					_floating = false;
				}
			}
		}

	return {
		init:init
	};
});