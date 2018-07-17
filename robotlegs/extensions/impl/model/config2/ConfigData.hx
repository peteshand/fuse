package robotlegs.extensions.impl.model.config2;

/**
 * @author P.J.Shand
 */
typedef ConfigData =
{
	_location:String,
	?_filename:String,
	_name:String,
	props:Array<ConfigProp>,
	?flags:Array<Flag>
}

typedef ConfigProp =
{
	?_type:String,
	?_if:Array<Dynamic>,
	_name:String,
	_activeLocation:String,
	value:Dynamic,
}

typedef Flag =
{
	name:String,
	value:String,
}