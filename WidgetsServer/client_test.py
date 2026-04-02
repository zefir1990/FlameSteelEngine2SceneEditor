import socket
import json
import uuid

def send_command(command, args):
    host = '127.0.0.1'
    port = 50051
    
    payload = {
        "command": command,
        "args": args
    }
    
    message = json.dumps(payload).encode('utf-8')
    
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        print(f"Sending UDP command: {command} to {host}:{port}")
        sock.sendto(message, (host, port))

def run_tests():
    # Test 1: Create a root window
    window_id = str(uuid.uuid4())
    print(f"--- Test 1: Create Window ({window_id}) ---")
    send_command("AddWindow", {
        "id": window_id,
        "title": "UDP Test Window"
    })
    
    # Test 2: Add a button to that window
    button_id = str(uuid.uuid4())
    print(f"--- Test 2: Add Button ({button_id}) ---")
    send_command("AddButton", {
        "id": button_id,
        "parentId": window_id,
        "label": "Click Me (UDP)"
    })

    # Test 3: Add a text label
    text_id = str(uuid.uuid4())
    print(f"--- Test 3: Add Text ({text_id}) ---")
    send_command("AddText", {
        "id": text_id,
        "parentId": window_id,
        "text": "Sent via Python UDP Client"
    })

if __name__ == '__main__':
    run_tests()
