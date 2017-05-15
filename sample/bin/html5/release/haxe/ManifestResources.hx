package;


import lime.app.Config;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;
import lime.utils.Assets;

#if sys
import sys.FileSystem;
#end

@:access(lime.utils.Assets)


@:keep @:dox(hide) class ManifestResources {
	
	
	public static var preloadLibraries:Array<AssetLibrary>;
	public static var preloadLibraryNames:Array<String>;
	
	
	public static function init (config:Config):Void {
		
		preloadLibraries = new Array ();
		preloadLibraryNames = new Array ();
		var rootPath = null;
		
		if (config != null && Reflect.hasField (config, "assetsPrefix")) {
			
			rootPath = Reflect.field (config, "assetsPrefix");
			
		}
		
		if (rootPath == null) {
			
			#if (ios || tvos)
			rootPath = "assets/";
			#elseif (windows && !cs)
			rootPath = FileSystem.absolutePath (haxe.io.Path.directory (#if (haxe_ver >= 3.3) Sys.programPath () #else Sys.executablePath () #end)) + "/";
			#else
			rootPath = "";
			#end
			
		}
		
		Assets.defaultRootPath = rootPath;
		
		#if (openfl && !flash)
		openfl.text.Font.registerFont (__ASSET__OPENFL__akkuratpro_otf);
		openfl.text.Font.registerFont (__ASSET__OPENFL__arial_ttf);
		
		#end
		
		var data, manifest, library;
		
		data = '{"name":null,"assets":"aoy4:pathy14:arrow_blue.pngy4:sizei77149y4:typey5:IMAGEy2:idR1goR0y14:arrow_gold.pngR2i75771R3R4R5R6goR0y14:arrow_pink.pngR2i54533R3R4R5R7goR0y16:arrow_purple.pngR2i104860R3R4R5R8goR0y14:arrow_teal.pngR2i66002R3R4R5R9goR0y11:bg_pink.jpgR2i131980R3R4R5R10goR0y15:btn_restart.pngR2i44081R3R4R5R11goR0y13:btn_start.pngR2i30947R3R4R5R12goR0y15:corner_blue.pngR2i5095R3R4R5R13goR0y15:corner_gold.pngR2i5960R3R4R5R14goR0y15:corner_pink.pngR2i18605R3R4R5R15goR0y17:corner_purple.pngR2i5198R3R4R5R16goR0y15:corner_teal.pngR2i5068R3R4R5R17goR0y18:dot_connection.pngR2i1459R3R4R5R18goR0y7:kea.pngR2i82695R3R4R5R19goR0y8:kea2.pngR2i83029R3R4R5R20goR0y8:kea3.pngR2i72846R3R4R5R21goR0y8:kea4.pngR2i73939R3R4R5R22goR0y10:wabbit.pngR2i449R3R4R5R23goR2i152116R3y4:FONTy9:classNamey23:__ASSET__akkuratpro_otfR5y14:akkuratpro.otfy7:preloadtgoR2i915212R3R24R25y18:__ASSET__arial_ttfR5y9:arial.ttfR28tgh","version":2,"libraryArgs":[],"libraryType":null}';
		manifest = AssetManifest.parse (data, rootPath);
		library = AssetLibrary.fromManifest (manifest);
		Assets.registerLibrary ("default", library);
		
		
		library = Assets.getLibrary ("default");
		if (library != null) preloadLibraries.push (library);
		else preloadLibraryNames.push ("default");
		
		
	}
	
	
}


#if !display
#if flash

@:keep @:bind #if display private #end class __ASSET__manifest_default_json extends null { }


#elseif (desktop || cpp)

@:file("") #if display private #end class __ASSET__manifest_default_json extends haxe.io.Bytes {}

@:keep #if display private #end class __ASSET__akkuratpro_otf extends lime.text.Font { public function new () { __fontPath = #if (ios || tvos) "assets/" + #end "akkuratpro"; name = "Akkurat Pro Regular"; super (); }}
@:keep #if display private #end class __ASSET__arial_ttf extends lime.text.Font { public function new () { __fontPath = #if (ios || tvos) "assets/" + #end "arial"; name = "Arial"; super (); }}


#else

@:keep #if display private #end class __ASSET__akkuratpro_otf extends lime.text.Font { public function new () { #if !html5 __fontPath = "akkuratpro"; #end name = "Akkurat Pro Regular"; super (); }}
@:keep #if display private #end class __ASSET__arial_ttf extends lime.text.Font { public function new () { #if !html5 __fontPath = "arial"; #end name = "Arial"; super (); }}


#end

#if (openfl && !flash)

@:keep #if display private #end class __ASSET__OPENFL__akkuratpro_otf extends openfl.text.Font { public function new () { #if !html5 __fontPath = #if (ios || tvos) "assets/" + #end "akkuratpro"; #end name = "Akkurat Pro Regular"; super (); }}
@:keep #if display private #end class __ASSET__OPENFL__arial_ttf extends openfl.text.Font { public function new () { #if !html5 __fontPath = #if (ios || tvos) "assets/" + #end "arial"; #end name = "Arial"; super (); }}


#end
#end