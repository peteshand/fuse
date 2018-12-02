
package fuse.core.backend.display;

class CoreMask
{
    public var display:CoreImage;

    public function new(display:CoreImage)
    {
        this.display = display;
    }

    public function dispose()
    {
        display = null;
    }
}