# Active Directory Lab – Cybersecurity Simulation Project

##  Overview
This project is a self-contained Active Directory (AD) lab built using VirtualBox. It simulates a real enterprise network, allowing hands-on experience with:
- Domain Controller configuration
- Bulk user creation
- Attack simulations (Brute Force, Atomic Red Team)
- Log collection with Splunk
- Event monitoring and detection

The goal: **to understand how enterprise networks operate and how to detect suspicious activity using security tools**.

---

##  Tools & Technologies Used
- VirtualBox (VM environment)
- Windows Server 2022 (Domain Controller)
- Windows 10 (Client)
- Ubuntu Linux (Splunk server)
- Kali Linux (Attacker)
- Splunk + Sysmon + Splunk Universal Forwarder
- PowerShell scripting
- Hydra & Crowbar (for brute-force)
- Atomic Red Team

---

##  Virtual Machine Configuration

| VM Name      | OS               | Purpose            | Network | Notes             |
|--------------|------------------|---------------------|---------|--------------------|
| DC           | Windows Server   | Domain Controller   | NAT + Host-only | 4 GB RAM |
| CLIENT       | Windows 10       | Domain-joined client| NAT + Host-only |  |
| SPLUNK       | Ubuntu           | SIEM (Splunk)       | NAT + Host-only |  |
| KALI         | Kali Linux       | Attacker            | NAT + Host-only |  |

---

##  Steps to Build the Lab

### 1. Download & Install VirtualBox and ISOs
- Install VirtualBox on your host machine.
- Download ISOs for:
  - Windows Server 2022 / 2019
  - Windows 10
  - Ubuntu Desktop or Server
  - Kali Linux

---

### 2. Set Up Domain Controller (Windows Server)

- Install Windows Server and configure two NICs (NAT and Host-Only).
- Run `configureADLab.ps1` to automate:
  - Domain Services
  - DNS
  - DHCP setup

- Promote the server to a Domain Controller for `adproject.local`.

---

### 3. Create Users in AD

Run the PowerShell script `create-users.ps1` to bulk-create 1,000 users in a specific Organizational Unit (OU):

```powershell
.\create-users.ps1 -InputFile names.txt -OU "OU=_ADMINS,DC=adproject,DC=local"
```
---

### 4. Configure Windows 10 Client
- Set the IP and DNS of the client to point to the Domain Controller.
- Rename the client to CLIENT.
- Join the domain:
  - adproject.local
- Log in using one of the domain users (e.g., jsparrow).

---

### 5. Install and Configure Splunk
**On the Ubuntu Splunk Server:**
- Download and install Splunk:

```bash
wget -O splunk.deb "https://download.splunk.com/products/splunk/releases/9.0.5/linux/splunk-9.0.5-xxxxxxx.deb"
sudo dpkg -i splunk.deb
sudo /opt/splunk/bin/splunk start --accept-license
```


**On DC and Client:**
- Configure inputs.conf to forward logs:

```
[default]
host = CLIENT
[WinEventLog://Security]
disabled = 0
```
---

##  Simulated Attacks

### 1. Brute Force (From Kali)

- Use Hydra or Crowbar to brute-force RDP logins:
**Using Hydra:**
  
```bash
hydra -l jsparrow -P passwords.txt rdp://192.168.10.100
```
**Using Crowbar:**
```bash
crowbar -b rdp -u jsparrow -C passwords.txt -s 192.168.10.100
```

---

### 2. Atomic Red Team (From Windows Client)

Install and run Atomic Red Team tests:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
IEX (IWR -UseBasicParsing -Uri 'https://raw.githubusercontent.com/redcanaryco/invoke-atomicredteam/main/install-     atomicredteam.ps1')
Install-AtomicRedTeam
Invoke-AtomicTest T1136.001
```
- **T1136.001 simulates local account creation — a common attacker technique.**

---

## Monitoring & Detection in Splunk

### Detect Brute-Force Attacks
Search for Event ID 4625 (failed logons):
```spl
index=main EventCode=4625
```

---

### Detect Local Account Creation
Search for Event ID 4720 (new local user created):

```spl
index=main EventCode=4720
```

---

##  Summary of Scripts & Configurations

| Script/File          | Purpose                            |
|----------------------|------------------------------------|
| configureADLab.ps1   | Set up AD DS, DNS, DHCP            |
| create-users.ps1     | Bulk user creation                 |
| inputs.conf          | Splunk Forwarder config            |
| atomic-red-install.ps1 | Atomic Red Team script installer |





