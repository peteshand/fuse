package notifier;

import mantle.filesystem.DocStore;
import notifier.Notifier;
import notifier.MapNotifier;

class NotifierPersistence
{
    public static function register(notifier:Notifier<Dynamic>, id:String)
    {
        var data = getNPData(id);

        if (data.localData != null) {
            notifier.silentlySet(data.localData);
        }
        notifier.add(() -> {
            data.sharedObject.setProperty("value", notifier.value);
		    data.sharedObject.flush();
        });
    }

    public static function registerMap(notifier:MapNotifier<Dynamic>, id:String)
    {
        var data = getNPData(id);
        if (data.localData != null) {
            var a:Array<Dynamic> = data.localData;
            for (i in 0...a.length) notifier.add(a[i]);
        }
        
        var onChange = function(a:Array<Dynamic>=null)
        {
            data.sharedObject.setProperty("value", notifier.allItems);
		    data.sharedObject.flush();
        }

        notifier.onAdd.add(onChange);
        notifier.onChange.add(onChange);
        notifier.onRemove.add(onChange);
    }
    
    static function getNPData(id:String):NPData
    {
        var sharedObject:DocStore = DocStore.getLocal("Notifier_" + id);
        return {
            sharedObject:sharedObject,
            localData:Reflect.getProperty(sharedObject.data, "value")
        }
    }
}

typedef NPData =
{
    sharedObject:DocStore,
    localData:Dynamic
}
