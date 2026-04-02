import grpc
import widgets_pb2
import widgets_pb2_grpc
import sys

def run():
    print("Connecting to gRPC server at localhost:50051...")
    with grpc.insecure_channel('localhost:50051') as channel:
        stub = widgets_pb2_grpc.WidgetServiceStub(channel)
        
        # Test 1: Create a basic window
        print("Sending CreateWindow request for 'Test Window'...")
        response = stub.CreateWindow(widgets_pb2.CreateWindowRequest(title="Test Window", width=400, height=300))
        print(f"Server response: {response.success}, message: {response.message}")
        
        # Test 2: Create another window with different title
        print("Sending CreateWindow request for 'Second Window'...")
        response = stub.CreateWindow(widgets_pb2.CreateWindowRequest(title="Second Window", width=200, height=100))
        print(f"Server response: {response.success}, message: {response.message}")

if __name__ == '__main__':
    run()
