# Linux Day06 - Networking and Service Diagnosis

## 1. Basic Network Communication Model

A client process communicates with a server process through a network.

```text
Client process
→ destination IP address
→ destination port
→ listening socket
→ server process
→ network service
```

The main concepts are:

```text
IP address
Identifies a host or network interface in an IP network.

Port
Identifies a TCP or UDP application endpoint on a host.

Process
A running instance of a program.

Service
A function provided by a process or a group of processes.

Socket
A kernel-managed communication object used by a process for networking.
```

A server process normally:

```text
creates a socket
→ binds the socket to an IP address and port
→ enters the LISTEN state
→ accepts client connections
→ receives requests
→ sends responses
```

## 2. Network Interface and Network Card

A network card is a physical or virtual network device.

A network interface is the operating-system representation of network communication capability.

Typical Linux interfaces:

```text
lo
Loopback interface

enp0s3
Ethernet interface provided by the VirtualBox virtual network card

wlan0
Possible wireless interface

docker0
Possible Docker virtual bridge
```

A physical or virtual network card normally creates a network interface through a device driver.

However, not every network interface has a physical network card.

For example:

```text
lo
docker0
tun0
veth interfaces
```

can be completely virtual.

## 3. MAC Address

`MAC` means:

```text
Media Access Control
```

A MAC address is used to identify a network interface on a local data-link network.

Example:

```text
08:00:27:0f:f3:d1
```

A normal MAC address contains:

```text
48 bits
=
6 bytes
=
12 hexadecimal digits
```

Relationship:

```text
MAC address
Identifies the current network interface on the local link.

IP address
Identifies the destination in an IP network.

Port
Identifies the destination application on the host.
```

MAC addresses are mainly used for the current local-network hop. They are not normally carried unchanged across the entire Internet.

## 4. Ethernet

Ethernet is a family of local-area-network technologies and standards.

An Ethernet frame contains information such as:

```text
destination MAC address
source MAC address
protocol type
payload
error-checking information
```

An IP packet can be encapsulated inside an Ethernet frame.

```text
HTTP data
→ TCP segment
→ IP packet
→ Ethernet frame
→ network interface
```

## 5. IP Address

`IP` means:

```text
Internet Protocol
```

An IP address is a logical address used by the IP protocol.

The Ubuntu virtual machine has:

```text
IPv4 address: 10.0.2.15/24
Interface: enp0s3
```

The loopback interface has:

```text
IPv4: 127.0.0.1
IPv6: ::1
```

## 6. localhost and Loopback

`localhost` is a hostname that represents the current computer.

It normally resolves to:

```text
127.0.0.1
::1
```

`127.0.0.1` is the common IPv4 loopback address.

`::1` is the IPv6 loopback address.

Traffic sent through a loopback address remains inside the current operating system.

```text
client process
→ Linux loopback interface
→ server process
```

It does not travel through the external network.

## 7. Private and Public IP Addresses

Private IPv4 address ranges include:

```text
10.0.0.0/8

172.16.0.0/12

192.168.0.0/16
```

The Ubuntu address:

```text
10.0.2.15
```

is a private IPv4 address.

Private addresses:

- Are used inside homes, companies, virtual networks, and data centers
- Can be reused in separate private networks
- Are not directly routed across the public Internet

A public IP address can normally be routed across the public Internet.

Private devices commonly access the Internet through NAT.

`NAT` means:

```text
Network Address Translation
```

Current network path:

```text
Ubuntu private IP 10.0.2.15
→ VirtualBox NAT gateway 10.0.2.2
→ host network
→ public Internet
```

A public IP address does not automatically make a service accessible. The process, listening address, port, firewall, and routing configuration must also allow access.

## 8. Network Inspection Commands

### View network interfaces and addresses

```bash
ip addr
```

Important fields:

```text
UP
The interface is administratively enabled.

LOWER_UP
The lower-level link is available.

link/ether
The MAC address of an Ethernet interface.

inet
An IPv4 address.

inet6
An IPv6 address.

mtu
Maximum Transmission Unit.
```

### View the hostname

```bash
hostname
```

### Quickly view host IP addresses

```bash
hostname -I
```

### View the routing table

```bash
ip route
```

Observed routing information:

```text
default via 10.0.2.2 dev enp0s3
```

This means that destinations without a more specific route are sent through:

```text
gateway: 10.0.2.2
interface: enp0s3
```

## 9. Routing

The routing table decides where outgoing IP packets should be sent.

Observed routes:

```text
10.0.2.0/24
Directly connected private network

default via 10.0.2.2
Default route through the VirtualBox gateway
```

A directly connected destination does not require the default gateway.

An external destination normally uses the default route.

## 10. ping and ICMP

`ping` tests whether a target returns ICMP echo responses.

`ICMP` means:

```text
Internet Control Message Protocol
```

Example:

```bash
ping -c 4 127.0.0.1
```

The option:

```text
-c
count
```

specifies the number of requests.

The tests confirmed:

```text
127.0.0.1
The loopback path works.

10.0.2.15
The local interface address works.

10.0.2.2
The VirtualBox gateway is reachable.

1.1.1.1
External IP connectivity works.
```

Important output:

```text
packets transmitted
Number of echo requests sent

packets received
Number of echo replies received

packet loss
Percentage of requests without replies

time
Round-trip time for one request

RTT
Round-Trip Time
```

A failed ping does not always mean the target service is unavailable because ICMP may be blocked while TCP and HTTP remain available.

## 11. DNS and Name Resolution

`DNS` means:

```text
Domain Name System
```

DNS commonly translates domain names into IP addresses.

Example:

```text
example.com
→ an IPv4 or IPv6 address
```

The broader process is called name resolution.

Linux may use multiple name sources:

```text
/etc/hosts
DNS
mDNS
other configured name services
```

The query order is configured through:

```text
/etc/nsswitch.conf
```

`NSS` means:

```text
Name Service Switch
```

### Query the system host database

```bash
getent hosts example.com
getent hosts localhost
```

`getent hosts` uses the Linux system name-resolution configuration. It is not limited to direct DNS queries.

Observed result:

```text
localhost
→ ::1
```

This is the IPv6 loopback address.

## 12. Inspecting Listening Ports

`ss` means:

```text
Socket Statistics
```

Commands:

```bash
ss -lt
ss -ltn
sudo ss -ltnp
```

Options:

```text
-l
listening sockets

-t
TCP sockets

-n
numeric addresses and ports

-p
process information
```

Without `-n`, known port numbers may be displayed as service names:

```text
domain
Port 53

ipp
Port 631
```

With `-n`, they are displayed numerically.

Example:

```text
LISTEN 0 5 127.0.0.1:8000 0.0.0.0:* users:(("python3",pid=10552,fd=3))
```

This proves:

```text
python3 process
→ PID 10552
→ owns file descriptor 3
→ holds a TCP socket
→ listens on 127.0.0.1:8000
```

## 13. Starting a Local HTTP Service

Command:

```bash
python3 -m http.server 8000 --bind 127.0.0.1
```

Meaning:

```text
python3
Run the Python 3 interpreter.

-m
Run a Python module.

http.server
Python standard-library HTTP server module.

8000
TCP listening port.

--bind 127.0.0.1
Bind only to the local IPv4 loopback address.
```

Background execution:

```bash
python3 -m http.server 8000 \
    --bind 127.0.0.1 \
    > http-server.log 2>&1 &
```

Save the PID:

```bash
http_pid=$!
echo "$http_pid" > http-server.pid
```

## 14. HTTP Client Testing with curl

`curl` is a command-line network client.

It is commonly understood as:

```text
Client URL
```

`URL` means:

```text
Uniform Resource Locator
```

### View the response body

```bash
curl http://127.0.0.1:8000
```

### View response headers

```bash
curl -I http://127.0.0.1:8000
```

The uppercase `-I` normally sends an HTTP HEAD request.

### View the detailed connection process

```bash
curl -v http://127.0.0.1:8000
```

`-v` means:

```text
verbose
```

Prefixes in verbose output:

```text
*
curl connection and diagnostic information

>
HTTP data sent by curl

<
HTTP data returned by the server
```

## 15. HTTP Request

Observed request:

```http
GET / HTTP/1.1
Host: 127.0.0.1:8000
User-Agent: curl/7.81.0
Accept: */*
```

Meaning:

```text
GET
Request a resource.

/
Request the server root path.

HTTP/1.1
HTTP version used by the client.

Host
Target host and port.

User-Agent
Client software information.

Accept
Response content types accepted by the client.
```

## 16. HTTP Response

Observed response:

```http
HTTP/1.0 200 OK
Server: SimpleHTTP/0.6 Python/3.10.12
Content-type: text/html; charset=utf-8
Content-Length: 407
```

A response contains:

```text
status line
response headers
blank line
response body
```

Important fields:

```text
200 OK
The request succeeded.

Server
Server software information.

Content-Type
Type and encoding of the response body.

Content-Length
Response-body size in bytes.

Date
Time when the response was generated.
```

The Python HTTP server returned an HTML directory listing because no `index.html` file existed in the served directory.

## 17. Service Logs

The HTTP server recorded:

```text
"GET / HTTP/1.1" 200
"HEAD / HTTP/1.1" 200
```

The log shows:

```text
client address
request time
HTTP method
request path
HTTP version
status code
```

Logs confirm that the request reached the server and show how the server processed it.

## 18. Service Not Running

After stopping the server:

```bash
kill -INT "$(cat http-server.pid)"
```

the listening socket disappeared.

Checking the port:

```bash
sudo ss -ltnp | grep ':8000'
```

returned no match.

A new curl request produced:

```text
Connection refused
curl exit status 7
```

`Connection refused` means:

```text
The target IP is reachable
+
no process is listening on the requested TCP port
```

This is different from a timeout, where no immediate response is received.

## 19. Port Already Occupied

When one server was already listening on:

```text
127.0.0.1:8000
```

a second server tried to bind the same address and port.

It failed with:

```text
OSError: [Errno 98] Address already in use
```

Meaning:

```text
The first process already owns the listening address.

The second process cannot bind another socket to the same
protocol, local IP address, and local port combination.
```

The second process exited with status:

```text
1
```

which indicates application failure.

## 20. Complete Service Diagnosis Workflow

```text
1. Start the service.

2. Check whether the process exists.
   ps
   pgrep

3. Check whether the expected port is listening.
   ss -ltnp

4. Send a client request.
   curl URL

5. Inspect the HTTP response.
   status code
   headers
   body

6. Inspect application logs.

7. Stop the service.

8. Test failure conditions.
   service not running
   connection refused
   port already occupied
```

## 21. Key Troubleshooting Conclusions

```text
Process exists
Does not automatically mean the network service is ready.

Port is listening
Means a socket has entered the LISTEN state.

curl succeeds
Means the client connected and received an HTTP response.

Connection refused
Usually means no process is listening on the target port.

Address already in use
Means another socket already owns the requested local address and port.

ping succeeds
Does not prove that an HTTP service is running.

DNS succeeds
Does not prove that the target TCP port is accessible.
```
