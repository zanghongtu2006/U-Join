# U‑Join — High‑Performance IM System

U‑Join is a **high‑performance, real‑time Instant Messaging (IM) system** designed to demonstrate **backend architecture design, distributed messaging, and mobile client integration**.

---

## 🎯 Design Goals

- **Ultra‑fast message delivery**
- **Minimal backend pressure**
- **Scalable multi‑device message synchronization**
- **Clear separation of responsibilities**
- **Production‑ready architectural decisions**

---

## 🧱 Technology Stack

### Backend
- **Java**
- **WebSocket + STOMP protocol**
- **Apache RocketMQ** (message streaming & decoupling)
- Stateless IM gateway design

### Frontend
- **Flutter** (mobile client)
- Web / desktop demo client

### Storage & Media
- Cloud Object Storage (Images / Videos / Files)
- Backend issues **temporary upload tokens**
- Media uploaded **directly from client to cloud**

---

## 🏗️ System Architecture

```
┌──────────────┐
│ Flutter App  │
│ (Mobile)     │
└──────┬───────┘
       │  WS + STOMP
       ▼
┌──────────────────┐
│ IM Gateway (Java)│
│  - Auth          │
│  - Routing       │
│  - MQ Producer   │
└──────┬───────────┘
       │ RocketMQ
       ▼
┌──────────────────┐
│ MQ Consumers     │
│  - Persistence  │
│  - Sync logic   │
└──────┬───────────┘
       ▼
┌──────────────────┐
│ Database         │
└──────────────────┘

Media Flow:
Client → Cloud Storage → URL → Message Payload
```

---

## 🔄 Message Flow Design

### 1️ Text / Control Messages
1. Client sends message via **WS‑STOMP**
2. Backend validates & routes message
3. Message pushed into **RocketMQ**
4. MQ consumers:
   - Persist message asynchronously
   - Handle multi‑device synchronization

### 2️ Image / Video / File Messages
1. Client compresses media **locally**
2. Client uploads media **directly to cloud storage**
3. Backend only issues **temporary upload credentials**
4. Client sends message containing **media URL**
5. Backend handles **message routing only**

➡️ **Backend never processes large binary payloads**, ensuring high throughput.

---

## ⚡ Performance‑Oriented Design

### ✅ Backend Load Reduction
- No synchronous DB writes on message send
- No media upload proxying
- Stateless IM gateway nodes

### ✅ Message Throughput Optimization
- RocketMQ used as **core message backbone**
- Producers optimized for low latency
- Consumers handle persistence & fan‑out

### ✅ Message Retention Control
- RocketMQ retention policy defines:
  - Maximum message lifetime
  - Storage pressure boundaries
- Enables **time‑bounded message replay**

---

## 🔁 Multi‑Device Message Synchronization

U‑Join supports **multi‑terminal message consistency**, similar to modern IM platforms:

- Mobile
- Web
- Desktop

Design considerations:
- Messages are replayed from MQ or storage based on **offset & message ID**
- Late‑joining devices can synchronize history
- Ordering guaranteed via message ID strategy

---

## 🆔 Message ID Strategy

Each message has a **globally unique ID** that provides:

- **Idempotency**  
  Duplicate delivery is safely ignored

- **Strict ordering**
  ID generation embeds time & sequence constraints

- **Consistency across devices**
  Same message ID used for:
  - Send
  - Persist
  - Sync
  - Acknowledgment

This avoids:
- Duplicate messages
- Ordering ambiguity
- Race conditions in multi‑device scenarios

---

## 📁 Project Structure

```
U‑Join/
├─ im-server/           # Java IM gateway & MQ producer
├─ flutterclient/       # Flutter mobile client
├─ client-demo/         # Web / desktop demo client
├─ .mvn/wrapper
├─ LICENSE
└─ README.md
```

---

## 🧪 What Dose This Project Matters

This repository demonstrates:

- Real‑world **IM system design**
- Practical **distributed messaging** usage
- Understanding of **high‑concurrency architecture**
- Conscious trade‑offs between:
  - Latency
  - Throughput
  - Consistency
- Clear separation of:
  - Gateway
  - Messaging
  - Persistence
  - Media handling

> This is **not a toy chat app**, but a system designed with **production constraints** in mind.

---

## 📄 License

GPL‑3.0

---

## 👤 Author

Hongtu Zang  
Senior Backend / Platform Engineer  
Focus: High‑performance systems, distributed architecture, cloud platforms

