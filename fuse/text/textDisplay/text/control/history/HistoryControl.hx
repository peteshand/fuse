package fuse.text.textDisplay.text.control.history;

import openfl.ui.Keyboard;
import openfl.events.Event;
import fuse.text.textDisplay.text.model.layout.CharLayout;
import fuse.text.textDisplay.text.model.selection.Selection;
import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.events.KeyboardEvent;
import fuse.text.textDisplay.text.TextDisplay;
import fuse.text.textDisplay.text.model.history.HistoryModel;
import fuse.text.textDisplay.text.model.history.HistoryStep;

class HistoryControl {
	private var historyModel:HistoryModel;
	private var selection:Selection;
	private var textDisplay:TextDisplay;
	var ignoreChanges:Bool;

	public function new(textDisplay:TextDisplay) {
		this.textDisplay = textDisplay;
		this.historyModel = textDisplay.historyModel;
		this.selection = textDisplay.selection;

		historyModel.onActiveChange.add(OnActiveChange);

		textDisplay.charLayout.layoutChanged.add(onTextChange);
		selection.addEventListener(Event.SELECT, onSelectionChange);
	}

	public function setIgnoreChanges(ignore:Bool):Void {
		ignoreChanges = ignore;
	}

	function OnActiveChange() {
		if (historyModel.active) {
			textDisplay.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			storeStep();
		} else {
			textDisplay.removeEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			if (historyModel.clearUndoOnFocusLoss) {
				historyModel.clearHistory();
			}
		}
	}

	private function onSelectionChange(e:Event):Void {
		if (historyModel.ignoreChanges || !historyModel.active || ignoreChanges)
			return;

		var currStep:HistoryStep = (historyModel.currStepIndex == -1 ? null : historyModel.history[historyModel.currStepIndex]);
		if (currStep != null) {
			currStep.selectionIndex = selection.index;
			currStep.selectionBegin = selection.begin;
			currStep.selectionEnd = selection.end;
		}
	}

	private function onTextChange():Void {
		if (historyModel.ignoreChanges || !historyModel.active || ignoreChanges)
			return;

		storeStep();
	}

	function storeStep() {
		var html = this.textDisplay.htmlText;
		var currStep:HistoryStep = (historyModel.currStepIndex == -1 ? null : historyModel.history[historyModel.currStepIndex]);
		if (currStep != null && currStep.htmlText == html) {
			currStep.selectionIndex = selection.index;
			currStep.selectionBegin = selection.begin;
			currStep.selectionEnd = selection.end;
			return;
		}

		var step:HistoryStep = (HistoryModel.stepPool.length > 0 ? HistoryModel.stepPool.pop() : new HistoryStep());
		step.htmlText = this.textDisplay.htmlText;
		step.selectionIndex = selection.index;
		step.selectionBegin = selection.begin;
		step.selectionEnd = selection.end;

		if (historyModel.currStepIndex != -1 && historyModel.currStepIndex != historyModel.history.length - 1) {
			historyModel.recycleSteps(historyModel.history.splice(historyModel.currStepIndex + 1,
				historyModel.history.length - historyModel.currStepIndex - 1));
		}
		if (historyModel.history.length > historyModel.undoSteps - 1) {
			historyModel.recycleSteps(historyModel.history.splice(0, historyModel.history.length - (historyModel.undoSteps - 1)));
		}
		historyModel.history.push(step);
		historyModel.currStepIndex = historyModel.history.length - 1;
	}

	private function OnKeyDown(e:KeyboardEvent):Void {
		if (e.isDefaultPrevented())
			return;

		if (e.keyCode == Keyboard.Z && e.ctrlKey && !e.shiftKey && !e.altKey)
			historyModel.undo();
		else if (e.keyCode == Keyboard.Y && e.ctrlKey && !e.shiftKey && !e.altKey)
			historyModel.redo(); // Normal Redo (CTRL + Y)
		else if (e.keyCode == Keyboard.Z && e.ctrlKey && e.shiftKey && !e.altKey)
			historyModel.redo(); // Rarer Redo (CTRL + SHIFT + Z)
	}
}
