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
        print(f"UDP Server listening on {self.host}:{self.port}")

    def listen(self):
        while True:
            data, addr = self.sock.recvfrom(4096)
            message = data.decode('utf-8')
            print(f"Received UDP message: {message} from {addr}")
            
            try:
                payload = json.loads(message)
                command = payload.get("command")
                
                if command == "CreateWindow":
                    title = payload.get("title", "New Window")
                    width = payload.get("width", 800)
                    height = payload.get("height", 600)
                    
                    # Safely trigger UI creation on the main thread
                    wx.CallAfter(self._create_frame, title, width, height)
                else:
                    print(f"Unknown command: {command}")
            except json.JSONDecodeError:
                print("Failed to decode JSON payload")
            except Exception as e:
                print(f"Error processing command: {e}")

    def _create_frame(self, title, width, height):
        frame = wx.Frame(None, title=title, size=(width, height))
        frame.Show()
        print(f"Window '{title}' shown via UDP command.")

if __name__ == '__main__':
    # Initialize wx.App on the main thread
    app = wx.App(False)
    
    # Keep the app running even if no windows are currently open
    app.SetExitOnFrameDelete(False)
    
    # Create a hidden dummy frame to keep the event loop alive
    dummy_frame = wx.Frame(None)
    
    # Start UDP server in a background thread
    server = UDPWidgetServer()
    udp_thread = threading.Thread(target=server.listen, daemon=True)
    udp_thread.start()
    
    print("wxPython main loop started. Waiting for UDP commands...")
    app.MainLoop()
