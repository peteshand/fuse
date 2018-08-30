
package mantle.bind;

import mantle.notifier.Notifier;
import mantle.managers.state.State;
import mantle.managers.transition.Transition;

class Bind
{
    static var transitionBinds = new Map<Transition, TransitionBind>();

    public static function bindTransition(transition:Transition, notifier:Notifier<Dynamic>, value:Dynamic, operation:String="==")
    {
        var transitionBind:TransitionBind = transitionBinds.get(transition);
        if (transitionBind == null){
            transitionBind = new TransitionBind(transition);
            transitionBinds.set(transition, transitionBind);
        }
        transitionBind.bind(notifier, value, operation);
    }
}

class TransitionBind
{
    var state:State = new State();

    public function new(transition:Transition)
    {
        if (state.value == true) transition.Show();
        else transition.Hide();
        
        state.onActive.add(() -> {
            transition.Show();
        });
        state.onInactive.add(() -> {
            transition.Hide();
        });
    }

    public function bind(notifier:Notifier<Dynamic>, value:Dynamic, operation:String="==")
    {
        state.addCondition(notifier, value, operation);
    }
}