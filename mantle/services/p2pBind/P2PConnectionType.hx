package mantle.services.p2pBind;

/**
 * @author P.J.Shand
 */

@:enum
abstract P2PConnectionType(String) from String
{
    var SERVERLESS = "serverless";
    var LOCAL = "local";
    var CLOUD = "cloud";
}