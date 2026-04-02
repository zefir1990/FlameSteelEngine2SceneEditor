import subprocess
import sys

def generate_proto():
    print("Generating gRPC Python stubs from widgets.proto...")
    command = [
        sys.executable, "-m", "grpc_tools.protoc",
        "-I.",
        "--python_out=.",
        "--grpc_python_out=.",
        "widgets.proto"
    ]
    
    result = subprocess.run(command, capture_output=True, text=True)
    if result.returncode != 0:
        print("Error generating gRPC stubs:")
        print(result.stderr)
        sys.exit(1)
    print("Successfully generated stubs.")

if __name__ == "__main__":
    generate_proto()
