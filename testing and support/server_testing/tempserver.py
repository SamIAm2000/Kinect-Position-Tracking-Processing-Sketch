# Echo server program
import socket

HOST = ''                 # Symbolic name meaning all available interfaces
PORT = 12345              # Arbitrary non-privileged port
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((HOST, PORT))
s.listen(1)
conn, addr = s.accept()
print('Connected by', addr)
while True:
    data = conn.recv(1024)
    if not data: break
    print(data) # Paging Python!
    split_string = data.decode().split(",")
    cur_x = int(split_string[0])
    cur_y = int(split_string[1])
    print(f"x = {cur_x} , y = {cur_y}")

    # do whatever you need to do with the data
conn.close()
# optionally put a loop here so that you start 
# listening again after the connection closes