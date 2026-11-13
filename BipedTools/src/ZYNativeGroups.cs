using System;
using System.Drawing;
using System.Collections.Generic;
using System.Runtime.InteropServices;
namespace Zhuoyu.Biped {
 public static class NativeInput197Events {
  [StructLayout(LayoutKind.Sequential)] struct POINT {public int X,Y;}
  [StructLayout(LayoutKind.Sequential)] struct RECT {public int Left,Top,Right,Bottom;}
  [DllImport("user32.dll")] static extern bool GetCursorPos(out POINT p);
  [DllImport("user32.dll")] static extern bool GetWindowRect(IntPtr h,out RECT r);
  [DllImport("user32.dll")] static extern IntPtr SetCapture(IntPtr h);
  [DllImport("user32.dll")] static extern bool ReleaseCapture();
  [DllImport("user32.dll")] static extern IntPtr GetCapture();
  [DllImport("user32.dll")] static extern short GetAsyncKeyState(int key);
  [DllImport("user32.dll")] static extern bool SetWindowPos(IntPtr h,IntPtr after,int x,int y,int w,int height,uint flags);
  [DllImport("user32.dll",EntryPoint="GetWindowLongW")] static extern int GetWindowLong(IntPtr h,int index);
  [DllImport("user32.dll",EntryPoint="SetWindowLongW")] static extern int SetWindowLong(IntPtr h,int index,int value);
  [DllImport("user32.dll")] static extern bool PostMessage(IntPtr h,uint msg,IntPtr w,IntPtr l);
  delegate IntPtr WindowProc(IntPtr h,uint msg,IntPtr w,IntPtr l);
  [DllImport("user32.dll",EntryPoint="SetWindowLongPtrW")] static extern IntPtr SetWindowProc(IntPtr h,int index,IntPtr proc);
  [DllImport("user32.dll",EntryPoint="GetWindowLongPtrW")] static extern IntPtr GetWindowProc(IntPtr h,int index);
  [DllImport("user32.dll")] static extern IntPtr CallWindowProc(IntPtr proc,IntPtr h,uint msg,IntPtr w,IntPtr l);
  [DllImport("user32.dll")] static extern int GetMessageTime();
  [DllImport("user32.dll")] static extern uint GetDoubleClickTime();
  class Input {public IntPtr Target,Previous;public bool Muted,Interactive,HasDown,SwallowUp;public int Builtin,LastTime,LastX,LastY,PressId;}
  static IntPtr lastBuiltinDown=IntPtr.Zero;
  static int pressSequence;
  public static int ActiveBuiltinPressId {get;private set;}
  public static int EditBuiltinPressId {get;private set;}
  static readonly Queue<KeyValuePair<int,int>> builtinEdits=new Queue<KeyValuePair<int,int>>();
  public static int NextBuiltinEdit {get{
   if(builtinEdits.Count==0)return 0;
   KeyValuePair<int,int> edit=builtinEdits.Dequeue();EditBuiltinPressId=edit.Value;return edit.Key;
  }}
  public static void ClearBuiltinEdits(){builtinEdits.Clear();lastBuiltinDown=IntPtr.Zero;}
  public static void ConfigureBuiltin(long button,long receiver,int key,bool muted,bool interactive){
   Configure(button,receiver,muted,interactive);inputs[new IntPtr(button)].Builtin=key;
  }
  static void QueueBuiltin(Input item,int edit) {
   builtinEdits.Enqueue(new KeyValuePair<int,int>(edit,item.PressId));
   // Max owns the receiver event boundary; no managed timer ever enters MAXScript.
   PostMessage(item.Target,0x201,IntPtr.Zero,IntPtr.Zero);
  }
  static readonly Dictionary<IntPtr,Input> inputs=new Dictionary<IntPtr,Input>();
  static readonly WindowProc callback=Dispatch;
  static readonly IntPtr callbackPtr=Marshal.GetFunctionPointerForDelegate(callback);
  public static void BeginUpdate(long button) {
   IntPtr h=new IntPtr(button);Input item;
   if(inputs.TryGetValue(h,out item)&&item.Muted&&item.Interactive)
    SetWindowLong(h,-16,GetWindowLong(h,-16)|0x08000000);
  }
  public static void Configure(long button,long target,bool muted,bool interactive) {
   IntPtr h=new IntPtr(button);Input item;
   if(!inputs.TryGetValue(h,out item)) {
    item=new Input();item.Previous=GetWindowProc(h,-4);inputs.Add(h,item);
   }
   item.Target=new IntPtr(target);item.Muted=muted;item.Interactive=interactive;item.Builtin=0;
   // Keep Max's disabled paint state, but allow hovering and editing an empty group.
   // BeginUpdate restores the OS flag before the next normal Max enable/disable update.
   if(interactive)SetWindowLong(h,-16,GetWindowLong(h,-16)&~0x08000000);
   // Max can restore its own procedure during a style/z-order update. Attach only after those updates.
   if(GetWindowProc(h,-4)==item.Previous)SetWindowProc(h,-4,callbackPtr);
  }
  static IntPtr Dispatch(IntPtr h,uint msg,IntPtr w,IntPtr l) {
   Input item=inputs[h];
   if(msg==0x82) {IntPtr result=CallWindowProc(item.Previous,h,msg,w,l);inputs.Remove(h);return result;}
   // Leave hover messages with the real Max button so Max owns its rich tooltip.
   // Queue click input to the existing MAXScript receiver; no script runs inside this callback.
   if(item.Interactive&&item.Builtin>0) {
    // Preserve Max's single click/keyboard/hover. Defer edits to a native UI event,
    // never call MAXScript or open a dialog inside a native window procedure.
    if(msg==0x204){lastBuiltinDown=IntPtr.Zero;return IntPtr.Zero;}
    if(msg==0x205){QueueBuiltin(item,item.Builtin);return IntPtr.Zero;}
    if(msg==0x201||msg==0x203){
     int now=GetMessageTime(),x=(short)(l.ToInt64()&65535),y=(short)((l.ToInt64()>>16)&65535);
     bool twice=msg==0x203||(lastBuiltinDown==h&&item.HasDown&&unchecked((uint)(now-item.LastTime))<=GetDoubleClickTime()&&Math.Abs(x-item.LastX)<=4&&Math.Abs(y-item.LastY)<=4);
     lastBuiltinDown=twice?IntPtr.Zero:h;item.HasDown=!twice;item.LastTime=now;item.LastX=x;item.LastY=y;
     if(twice){item.SwallowUp=true;QueueBuiltin(item,-item.Builtin);return IntPtr.Zero;}
     // Correlate the native double-click with its first selection, independent of
     // how long a complex Max scene takes to process that first click.
     item.PressId=++pressSequence;ActiveBuiltinPressId=item.PressId;
    }
    if(msg==0x202&&item.SwallowUp){item.SwallowUp=false;return IntPtr.Zero;}
    if(msg==0x202)ActiveBuiltinPressId=item.PressId;
    return CallWindowProc(item.Previous,h,msg,w,l);
   }
   if(msg==0x201)lastBuiltinDown=IntPtr.Zero;
   if(item.Interactive&&(msg==0x201||msg==0x202||msg==0x203||msg==0x205)) {
    PostMessage(item.Target,msg,w,l);return IntPtr.Zero;
   }
   return CallWindowProc(item.Previous,h,msg,w,l);
  }
  public static void Detach(long button) {BeginUpdate(button);IntPtr h=new IntPtr(button);Input item;if(inputs.TryGetValue(h,out item)){if(GetWindowProc(h,-4)==callbackPtr){SetWindowProc(h,-4,item.Previous);inputs.Remove(h);}else{item.Interactive=false;item.Target=IntPtr.Zero;}}}
  public static Point Cursor {get{POINT p;GetCursorPos(out p);return new Point(p.X,p.Y);}}
  public static bool LeftDown {get{return (GetAsyncKeyState(1)&0x8000)!=0;}}
  public static Rectangle Bounds(long hwnd){RECT r;GetWindowRect(new IntPtr(hwnd),out r);return new Rectangle(r.Left,r.Top,r.Right-r.Left,r.Bottom-r.Top);}
  public static void Capture(long hwnd){SetCapture(new IntPtr(hwnd));}
  public static void Release(long hwnd){if(GetCapture()==new IntPtr(hwnd))ReleaseCapture();}
  public static void Raise(long hwnd){SetWindowPos(new IntPtr(hwnd),IntPtr.Zero,0,0,0,0,0x13);}
 }
}
