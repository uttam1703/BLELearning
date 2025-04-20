# 📱 iOS Bluetooth Chat App

This is a simple **Bluetooth chat application** built with **CoreBluetooth** and **UIKit**, allowing two iOS devices to communicate locally using Bluetooth.

One device acts as a **Central** and the other as a **Peripheral** — both can send and receive messages wirelessly.

---

## 🚀 Features

- 📡 Communicate using CoreBluetooth (BLE)
- 🔄 Central and Peripheral roles
- 💬 Real-time message exchange
- 🧩 Built with UIKit, no third-party libraries

---

## 🛠️ Technologies Used

- **Swift**
- **CoreBluetooth**
- **UIKit**

---

## 📲 How It Works

1. One device starts in **Peripheral mode** and advertises a Bluetooth service.
2. Another device runs in **Central mode** and scans for available peripherals.
3. Once connected, both devices can:
   - Send messages
   - Receive messages
   - Display messages in a simple chat UI

---

## ⚙️ Setup Instructions

1. Clone this repo:
   ```bash
   https://github.com/uttam1703/BLELearning.git
