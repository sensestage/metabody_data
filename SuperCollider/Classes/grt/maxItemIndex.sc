+ Collection {
	maxIndexAndItem { | function |
		var maxValue, maxIndex;
		if (function.isNil) { // optimized version if no function
			this.do { | elem, index |
				if (maxValue.isNil) {
					maxValue = elem;
					maxIndex = index;
				}{
					if (elem > maxValue) {
						maxValue = elem;
						maxIndex = index;
					}
				}
			}
			^[ maxIndex, maxValue ];
		}{
			this.do {|elem, i| var val;
				if (maxValue.isNil) {
					maxValue = function.value(elem, i);
					maxIndex = i;
				}{
					val = function.value(elem, i);
					if (val > maxValue) {
						maxValue = val;
						maxIndex = i;
					}
				}
			}
			^[ maxIndex, maxValue ];
		}
	}
}