# 🚌 SchoolNow – Automated School Bus System (ASBS)
Final Project Report (README.md)

---

## 📌 Project Overview

**SchoolNow** is a mobile-based Automated School Bus System (ASBS) developed to improve
student safety, attendance accuracy, and fare management for school transportation services
in Malaysia.  
The system replaces manual processes with **QR-based attendance**, **automated fare records**,
and **real-time bus tracking**.

This README reflects the **FINAL IMPLEMENTATION** of the project.

---

## 📱 Final UI Screenshots

> 📌 Replace image paths with your actual screenshots inside `/screenshots/`

### 🔐 Login Screen (Role-based)
![Login Screen](screenshots/login.png)

### 👨‍👩‍👧 Parent Dashboard
![Parent Home](screenshots/parent_home.png)

### 🧑‍🎓 Student QR Bus Pass
![Student QR](screenshots/student_qr.png)

### 🚍 Driver QR Scanner
![QR Scanner](screenshots/qr_scanner.png)

### 🗺️ Live Bus Location Tracking
![Live Location](screenshots/live_location.png)

### 🧑‍💼 Admin – Manage Drivers
![Add Driver](screenshots/add_driver.png)

### 🧑‍💼 Admin – Manage Routes
![Add Route](screenshots/add_route.png)

---

## ✅ Summary of Achieved Features

### 👨‍👩‍👧 Parent & Student
- Student registration
- Bus route booking and subscription
- Digital student bus pass (QR code)
- QR-based tap-in and tap-out attendance
- Real-time trip status (On Board / Completed)
- Live bus location tracking
- Digital fare and booking records

### 🚍 Driver
- Role-based login
- View assigned routes and students
- Scan student QR codes for attendance
- Update trip status
- Share live bus location

### 🧑‍💼 Administrator
- Add and manage drivers
- Add and manage buses
- Create and manage routes
- Monitor student attendance records
- View and manage student bookings
- Centralized system control

---

## 🛠️ Technical Explanation

### 🔹 System Architecture
SchoolNow follows a **client–cloud architecture**:
- **Frontend:** Flutter mobile application
- **Backend:** Cloud-based database & authentication
- **QR System:** Used for student attendance verification
- **Maps Integration:** Google Maps for real-time bus tracking

### 🔹 Technology Stack
- **Framework:** Flutter
- **Language:** Dart
- **Platform:** Hybrid Mobile Application (Android)
- **Backend:** Cloud database & authentication
- **QR Scanner:** Camera-based QR scanning
- **Maps:** Google Maps API

### 🔹 Authentication & Access Control
- Role-based login (Admin, Driver, Parent, Student)
- Access to features restricted by user role
- Secure login using email and password

### 🔹 Attendance System
- Each student is assigned a unique QR code
- QR scanned during boarding and alighting
- Attendance recorded automatically in database
- Reduces human error and manual record keeping

### 🔹 Live Tracking
- Bus location updated in real time
- Parents can view live bus movement on map
- Improves safety and transparency

---

## ⚠️ Limitations

- Payment gateway is simulated (no real online payment integration)
- System currently supports **single-school deployment**
- Internet connection is required for live tracking
- Limited analytics and reporting features
- No push notification alerts implemented

---

## 🚀 Future Enhancements

- Integration with real online payment gateways (e-wallet / card)
- Push notification alerts for parents
- Advanced attendance and payment analytics
- Multi-school and district-level support
- Driver performance and route optimization
- iOS deployment support

---

## 📚 Course Information

**Course:** ISB46903 – Automated Fare Collection Technology  
**Programme:** Bachelor of Information Technology (Hons) Software Engineering  
**Institution:** Malaysian Institute of Information Technology  

---

## 📌 Final Note

This README.md reflects the **FINAL implemented version** of the SchoolNow system.
All features listed above are functional and demonstrated during the final presentation.

> **Non-updated README = NO submission**  
> ✅ This README is FINAL and ready for evaluation.
