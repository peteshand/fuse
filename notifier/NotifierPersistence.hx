package notifier;

import mantle.filesystem.DocStore;
import notifier.Notifier;

class NotifierPersistence
{
    public static function register(notifier:Notifier<Dynamic>, id:String)
    {
        var sharedObject:DocStore = DocStore.getLocal("Notifier_" + id);
        var localData:Dynamic = Reflect.getProperty(sharedObject.data, "value");
        if (localData != null) {
            notifier.silentlySet(localData);
        }
        notifier.add(() -> {
            sharedObject.setProperty("value", notifier.value);
		    sharedObject.flush();
        });
    }
}