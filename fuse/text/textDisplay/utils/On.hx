package fuse.text.textDisplay.utils;

abstract On(Array < Void -> Void >) {
	public function new() {
		this = [];
	}

	public function add(callback:Void->Void) {
		this.push(callback);
	}

	public function remove(callback:Void->Void) {
		this.remove(callback);
	}

	public function removeAll() {
		while (this.length > 0)
			this.pop();
	}

	public function fire() {
		for (callback in this)
			callback();
	}
}
