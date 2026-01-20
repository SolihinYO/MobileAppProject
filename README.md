# 🚌 SchoolNow – Automated School Bus System (ASBS)
## Final Project Report (README.md)

---

## 1. Introduction

School transportation services play an important role in ensuring that students travel safely and efficiently between home and school. In Malaysia, many school bus services still rely on manual processes such as handwritten attendance records and cash-based fare collection. These traditional methods are inefficient, prone to human error, and provide limited visibility for parents regarding their children’s daily travel status.

The **Automated School Bus System (ASBS)**, also known as **SchoolNow**, is a mobile-based application developed to address these issues by replacing manual processes with a digital and automated solution. The system integrates QR-based attendance tracking, automated fare records, and real-time bus location monitoring to improve safety, efficiency, and transparency for all stakeholders involved.

SchoolNow is developed using the Flutter framework, allowing the application to operate as a hybrid mobile application. This enables a consistent and user-friendly experience across devices while supporting different user roles such as parents, students, bus drivers, and administrators.

---

## 2. Application Domain

The SchoolNow system falls under the domains of **Transportation**, **Education Technology**, and **Safety Management**. It combines mobile technology with automated fare collection principles to improve the management of school transportation services and enhance student safety.

---

## 3. Problem Statement

School bus transportation services in Malaysia commonly depend on manual methods for recording student attendance and managing transportation fees. These processes are inefficient and often result in inaccurate records, delayed updates, and missing information. Parents usually lack real-time confirmation of whether their children have safely boarded or exited the bus, which can cause anxiety and reduce trust in the transportation system.

In addition, fare collection is typically handled through cash payments or informal record-keeping. This increases the risk of payment errors, lost records, and difficulties in tracking service usage. School administrators also face challenges in managing buses, drivers, routes, students, attendance, and payments due to the absence of a centralized digital platform.

Therefore, there is a clear need for an integrated digital system that improves student safety, reduces human error, enhances operational efficiency, and provides real-time information to all stakeholders involved in school transportation services.

---

## 4. Project Objectives

The main objective of this project is to design and develop a mobile-based Automated School Bus System that improves the safety, efficiency, and reliability of school transportation services.

Specifically, the system aims to implement a digital attendance mechanism using QR codes, provide real-time bus tracking for parents, enable digital booking and fare records, assist drivers with route and student management, and allow administrators to oversee all transportation operations through a centralized system.

---

## 5. System Overview

SchoolNow is designed as a role-based mobile application where each user accesses the system according to their assigned role. Parents are able to register students, book bus routes, view attendance records, and track the bus location in real time. Students are provided with a digital QR bus pass that is used for attendance verification during boarding and alighting.

Bus drivers use the application to view assigned routes and student lists, scan QR codes to record attendance, and update trip status. Administrators manage buses, drivers, routes, bookings, attendance, and payment records through administrative interfaces.

---

## 6. Final User Interface Screens and Explanation

### 6.1 Login Screen

The login screen is the entry point of the application and supports role-based access for administrators, drivers, parents, and students. Users are required to log in using their email and password. Based on the selected role, users are redirected to their respective dashboards.

This approach ensures secure access control and prevents unauthorized users from accessing system features that are not relevant to their role.

---

### 6.2 Parent Dashboard

The parent dashboard acts as the main control panel for parents. It displays relevant information such as student details, booking status, trip progress, and payment records. Parents can easily navigate to features such as bus booking, live tracking, and attendance history.

This dashboard is designed to improve transparency and provide parents with peace of mind regarding their child’s daily transportation activities.

---

### 6.3 Student Registration Screen

The student registration screen allows parents to register their children into the system by entering personal information such as name, age, and login credentials. Once registered, the student is linked to the transportation services available in the system.

This digital registration process eliminates paper-based forms and reduces errors associated with manual data entry.

---

### 6.4 Bus Booking Screen

The bus booking screen enables parents to select a suitable bus route, driver, bus, and subscription duration for their child. The system automatically calculates and records the booking details.

This feature simplifies the booking process and ensures accurate route and fare assignment while maintaining a complete digital record of all bookings.

---

### 6.5 Digital Student Bus Pass (QR Code)

Each registered student is assigned a unique QR code that functions as a digital bus pass. The QR code must be shown to the driver during boarding and alighting.

This feature replaces manual attendance taking and ensures fast, accurate, and secure identification of students, thereby enhancing safety and accountability.

---

### 6.6 Driver QR Scanner Screen

The QR scanner screen is used by bus drivers to scan student QR codes during boarding and drop-off. Upon successful scanning, attendance records are automatically stored in the system database.

This automation reduces human error and ensures reliable tap-in and tap-out attendance tracking.

---

### 6.7 Attendance Monitoring Screen (Administrator)

Administrators can view attendance records through the attendance monitoring screen. The system displays student attendance status such as present, absent, or unknown.

This feature enables centralized attendance management and supports monitoring, verification, and reporting activities.

---

### 6.8 Live Bus Location Tracking

The live tracking screen displays the real-time location of the bus using map integration. Parents can monitor the bus movement during pickup and drop-off times.

This feature enhances safety, reduces uncertainty, and improves communication between parents and drivers.

---

### 6.9 Administrative Management Screens

Administrators are provided with interfaces to add and manage drivers, buses, and routes. These screens allow administrators to input and update operational data such as driver information, bus details, route locations, estimated travel time, and fare prices.

Centralizing these functions improves operational efficiency and data accuracy.

---

## 7. Summary of Achieved Features

The SchoolNow system successfully implements student registration, digital bus booking, QR-based attendance tracking, real-time bus location monitoring, and role-based system access. All core functionalities planned for the project have been implemented and tested in the final version of the application.

---

## 8. Technical Explanation

SchoolNow follows a client–cloud architecture. The frontend is developed using Flutter, while backend services handle authentication, data storage, and real-time updates. QR code technology is used for attendance verification, and map services are integrated for live tracking.

Role-based access control ensures that each user only interacts with features relevant to their role. Attendance data, booking records, and trip status updates are stored centrally to support real-time synchronization across devices.

---

## 9. Limitations

Despite its successful implementation, the system has some limitations. The current version does not integrate a real online payment gateway, and payment records are simulated. The system also requires an active internet connection for live tracking and data synchronization. Additionally, reporting and analytics features are limited, and the system currently supports only a single-school deployment.

---

## 10. Future Enhancements

Future improvements may include integration with real payment gateways, push notification alerts for parents, advanced reporting and analytics, multi-school deployment support, route optimization features, and iOS platform support.

---

## 11. Conclusion

The Automated School Bus System (ASBS) demonstrates how mobile technology can be used to improve school transportation services. By integrating QR-based attendance, automated fare records, and real-time tracking, the system enhances safety, reduces human error, and improves operational efficiency.

SchoolNow provides a reliable and transparent solution that benefits parents, students, drivers, and administrators, and it has strong potential for further enhancement and real-world deployment.

