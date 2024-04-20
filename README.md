# **Ring display**

_Using [Magic Mirror 2](https://magicmirror.builders/)_

### Why

We needed a display to easily view who pressed our Ring doorbell for my grandparents.

### Requirements

- A display
- A ring doorbell
- A Raspberry Pi, with the full version of Respberry Pi OS (legacy 32-bit, also works for Raspberry Pi Zero 2W (That is the one I am using))

### Setup

**It is recommended to use the full Raspberry pi OS**

1. **Clone the project from GitHub**

```bash
git clone https://github.com/mitchellston/ring-display.git
```

2. **Go into the cloned folder**

```bash
cd ring-display
```

3. **Run the initial-setup.sh script:** This script will install and setup the device correctly (This script uses sudo, meaning that it has to be executed by a user with sudo access)

```bash
./initial-setup.sh #(Might not work if you are not using Raspberry Pi OS)
```

_This script will ask you to login with your ring account, copy the code it gives for the following step_

4. **Create a .env file:** The only key that is required to be set is `RING_REFRESH_TOKEN`, this needs to be set with the code that is generated after logging in.

```bash
cp .env.example .env
```

_After this command you can use your favorite text editor to set the settings of the display_

5. **Start the project**

```bash
./startup.sh
```

_The first startup will take a little while_
