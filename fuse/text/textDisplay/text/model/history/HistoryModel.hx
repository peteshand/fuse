package fuse.text.textDisplay.text.model.history;

import signals.Signal;

/**
 * ...
 * @author P.J.Shand
 */
class HistoryModel {
	private var textDisplay:TextDisplay;

	@:allow(fuse.text.textDisplay.control.history) private static var stepPool:Array<HistoryStep> = [];

	@:allow(fuse.text.textDisplay.control.history) private var history:Array<HistoryStep> = [];
	@:allow(fuse.text.textDisplay.control.history) private var currStepIndex:Int = -1;
	@:allow(fuse.text.textDisplay.control.history) private var ignoreChanges:Bool;
	@:allow(fuse.text.textDisplay.control.history) private var onActiveChange = new Signal0();
	private var _active:Null<Bool> = null;

	public var active(get, set):Null<Bool>;
	@:isVar public var undoSteps(default, set):Int = 0;
	@:isVar public var clearUndoOnFocusLoss(default, set):Bool = false;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;
	}

	@:allow(fuse.text.textDisplay.control.history)
	inline function clearHistory() {
		recycleSteps(history);
		history = [];
		currStepIndex = -1;
	}

	@:allow(fuse.text.textDisplay.control.history)
	inline function recycleSteps(steps:Array<HistoryStep>) {
		for (step in steps) {
			step.htmlText = null;
			stepPool.push(step);
		}
	}

	@:allow(fuse.text.textDisplay.control.history)
	private function undo() {
		if (currStepIndex <= 0)
			return;

		currStepIndex--;
		setCurrStep();
	}

	@:allow(fuse.text.textDisplay.control.history)
	private function redo() {
		if (currStepIndex == -1 || currStepIndex >= history.length - 1)
			return;

		currStepIndex++;
		setCurrStep();
	}

	@:allow(fuse.text.textDisplay.control.history)
	private function setCurrStep() {
		ignoreChanges = true;
		var step:HistoryStep = history[currStepIndex];
		textDisplay.htmlText = step.htmlText;
		if (step.selectionBegin == null) {
			textDisplay.selection.index = step.selectionIndex;
		} else {
			textDisplay.selection.set(step.selectionBegin, step.selectionEnd, step.selectionIndex);
		}
		ignoreChanges = false;
	}

	private function get_active():Null<Bool> {
		return _active;
	}

	private function set_active(value:Null<Bool>):Null<Bool> {
		if (_active == value)
			return value;
		_active = value;
		onActiveChange.dispatch();
		return _active;
	}

	function set_undoSteps(value:Int):Int {
		undoSteps = value;
		if (history.length > undoSteps) {
			currStepIndex -= history.length - undoSteps;
			if (currStepIndex < 0)
				currStepIndex = 0;
			recycleSteps(history.splice(0, history.length - undoSteps));
		}
		return value;
	}

	function set_clearUndoOnFocusLoss(value:Bool):Bool {
		clearUndoOnFocusLoss = value;
		if (clearUndoOnFocusLoss && !active) {
			clearHistory();
		}
		return value;
	}
}
