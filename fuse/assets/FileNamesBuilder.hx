package fuse.assets;

/**
 * ...
 * @author P.J.Shand
 */
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;

class FileNamesBuilder {
	public static function build(directory:String):Array<Field> {
		var fileReferences:Array<IRef> = [];
		buildTree(directory, fileReferences);

		var fields:Array<Field> = Context.getBuildFields();
		for (fileRef in fileReferences) {
			// create new fields based on file references!
			// if (fileRef.isDirectory) {
			////trace(fileRef.value);
			// var childFields:Array<Field> = FileNamesBuilder.build(fileRef.value);
			// for (i in 0...childFields.length)
			// {
			// fields.push({
			// name: fileRef.fileName + "." + childFields[i].name,
			// doc: childFields[i].doc,
			// access: childFields[i].access,
			// kind: childFields[i].kind,
			// pos: childFields[i].pos
			// });
			// }
			//
			// }
			// else {
			fields.push({
				name: fileRef.name,
				doc: fileRef.documentation,
				access: [Access.APublic, Access.AStatic, Access.AInline],
				kind: FieldType.FVar(macro:String, macro $v{fileRef.value}),
				pos: Context.currentPos()
			});
			// }
		}

		return fields;
	}

	static function buildTree(directory:String, fileReferences:Array<IRef>):Void {
		var fileNames = FileSystem.readDirectory(directory);

		for (fileName in fileNames) {
			if (FileSystem.isDirectory(directory + "/" + fileName)) {
				// trace("isDirectory: " + directory + "/" + fileName);
				buildTree(directory + "/" + fileName, fileReferences);
				// fileReferences.push(new DirRef(directory + "/" + fileName, fileName));
			} else {
				fileReferences.push(new FileRef(directory + "/" + fileName, fileName));
			}
		}
	}
}
