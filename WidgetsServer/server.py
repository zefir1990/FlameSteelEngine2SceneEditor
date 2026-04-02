import wx
import grpc
import widgets_pb2
import widgets_pb2_grpc
from concurrent import futures
import threading
import time

class WidgetServicer(widgets_pb2_grpc.WidgetServiceServicer):
    def CreateWindow(self, request, context):
        print(f"Received CreateWindow request: {request.title} ({request.width}x{request.height})")
        # Use wx.CallAfter to safely create the frame on the UI thread
        wx.CallAfter(self._create_frame, request.title, request.width, request.height)
        return widgets_pb2.CreateWindowResponse(success=True, message=f"Window '{request.title}' created successfully.")

    def _create_frame(self, title, width, height):
        frame = wx.Frame(None, title=title, size=(width, height))
        frame.Show()
        print(f"Window '{title}' shown.")

def serve_grpc():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=10))
    widgets_pb2_grpc.add_WidgetServiceServicer_to_server(WidgetServicer(), server)
    server.add_insecure_port('[::]:50051')
    server.start()
    print("gRPC server started on port 50051")
    server.wait_for_termination()

if __name__ == '__main__':
    # Initializing wx.App on the main thread is a requirement for wxPython
    app = wx.App(False)
    
    # Starting gRPC server in a separate background thread
    grpc_thread = threading.Thread(target=serve_grpc, daemon=True)
    grpc_thread.start()
    
    # Keep the app running even if no windows are currently open
    app.SetExitOnFrameDelete(False)
    
    # Create a dummy frame (hidden) to keep the event loop alive in some environments
    dummy_frame = wx.Frame(None)
    
    # Enter the wxPython main event loop - this thread will stay alive until app exits
    print("wxPython main loop started. Waiting for gRPC commands...")
    app.MainLoop()
