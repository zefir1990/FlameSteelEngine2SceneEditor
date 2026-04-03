import wx
import socket
import json
import threading

class UDPWidgetServer:
    def __init__(self, host='127.0.0.1', port=50051):
        self.host = host
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.sock.bind((self.host, self.port))
        
        self.last_client_addr = None
        
        # Registry to store widgets and sizers by their ID
        self.widgets = {}
        self.sizers = {}
        
        print(f"UDP Hierarchical Server listening on {self.host}:{self.port}")

    def listen(self):
        while True:
            data, addr = self.sock.recvfrom(8192)  # Increased payload size for complex trees
            self.last_client_addr = addr
            message = data.decode('utf-8')
            
            try:
                payload = json.loads(message)
                command = payload.get("command")
                args = payload.get("args", {})
                
                print(f"Executing RPC: {command}({args.get('id', 'none')})")
                
                # Safely trigger UI construction on the main thread
                wx.CallAfter(self._handle_command, command, args)
            except json.JSONDecodeError:
                print("Failed to decode JSON payload")
            except Exception as e:
                print(f"Error processing command: {e}")

    def _handle_command(self, command, args):
        wid = args.get("id")
        pid = args.get("parentId")
        
        if command == "AddWindow":
            self._add_window(wid, args.get("title", "Flame Steel Window"))
        elif command == "AddButton":
            self._add_button(wid, pid, args.get("label", "Button"))
        elif command == "AddText":
            self._add_text(wid, pid, args.get("text", ""))
        elif command == "AddPanel":
            self._add_panel(wid, pid)
        elif command == "AddContainer":
            self._add_container(wid, pid, args.get("type", "vertical"))
        else:
            print(f"Unknown RPC command: {command}")

    def _update_ui(self, widget):
        top_level = widget.GetTopLevelParent()
        if top_level:
            top_level.Layout()
            top_level.Refresh()
            top_level.Update()

    def _add_window(self, wid, title):
        frame = wx.Frame(None, title=title, size=(800, 600))
        # Default vertical sizer for the frame
        sizer = wx.BoxSizer(wx.VERTICAL)
        frame.SetSizer(sizer)
        
        self.widgets[wid] = frame
        self.sizers[wid] = sizer
        
        frame.Center()
        frame.Iconize(False)
        frame.Show()
        frame.Raise()
        frame.SetFocus()
        frame.Refresh()
        frame.Update()
        print(f"Created Frame: {wid}")

    def _add_panel(self, wid, pid):
        parent = self.widgets.get(pid)
        parent_sizer = self.sizers.get(pid)
        
        if parent and parent_sizer:
            # Create a static box with a vertical sizer
            panel = wx.Panel(parent)
            sizer = wx.BoxSizer(wx.VERTICAL)
            panel.SetSizer(sizer)
            
            parent_sizer.Add(panel, 0, wx.ALL | wx.EXPAND, 5)
            panel.Layout()
            self._update_ui(parent)
            
            self.widgets[wid] = panel
            self.sizers[wid] = sizer
            print(f"Created Panel: {wid} inside {pid}")

    def _add_container(self, wid, pid, layout_type):
        parent = self.widgets.get(pid)
        parent_sizer = self.sizers.get(pid)
        
        if parent and parent_sizer:
            # For a ViewGroup, we create a sub-sizer
            orient = wx.VERTICAL if layout_type == "vertical" else wx.HORIZONTAL
            sizer = wx.BoxSizer(orient)
            
            parent_sizer.Add(sizer, 1, wx.EXPAND | wx.ALL, 5)
            self._update_ui(parent)
            
            # We don't save a widget for a pure container, just the sizer
            self.widgets[wid] = parent 
            self.sizers[wid] = sizer
            print(f"Created {layout_type} Container: {wid} inside {pid}")

    def _add_button(self, wid, pid, label):
        parent = self.widgets.get(pid)
        parent_sizer = self.sizers.get(pid)
        
        if parent and parent_sizer:
            btn = wx.Button(parent, label=label)
            btn.Bind(wx.EVT_BUTTON, lambda event, wid=wid: self._on_button_click(event, wid))
            parent_sizer.Add(btn, 0, wx.ALL | wx.EXPAND, 5)
            self._update_ui(parent)
            
            self.widgets[wid] = btn
            print(f"Created Button: '{label}' ({wid}) inside {pid}")

    def _on_button_click(self, event, wid):
        print(f"Button clicked: {wid}")
        if self.last_client_addr:
            payload = {
                "command": "ButtonAction",
                "args": {"id": wid}
            }
            message = json.dumps(payload).encode('utf-8')
            # Send back to client host:50052
            target_addr = (self.last_client_addr[0], 50052)
            self.sock.sendto(message, target_addr)
        else:
            print("no client to send action")

    def _add_text(self, wid, pid, text):
        parent = self.widgets.get(pid)
        parent_sizer = self.sizers.get(pid)
        
        if parent and parent_sizer:
            lbl = wx.StaticText(parent, label=text)
            parent_sizer.Add(lbl, 0, wx.ALL, 5)
            self._update_ui(parent)
            
            self.widgets[wid] = lbl
            print(f"Created Text: '{text}' ({wid}) inside {pid}")

if __name__ == '__main__':
    app = wx.App(False)
    app.SetExitOnFrameDelete(False)
    
    # Create a hidden dummy frame to keep the event loop alive on Windows
    # until the first RPC command arrives safely.
    dummy = wx.Frame(None)
    
    server = UDPWidgetServer()
    udp_thread = threading.Thread(target=server.listen, daemon=True)
    udp_thread.start()
    
    print("wxPython RPC Hierarchical Server running...")
    app.MainLoop()
    print("exited")