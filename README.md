
# 📌 **Sneakify - E-commerce App for Shoes**  

**Sneakify** is a Flutter-based e-commerce application designed for seamless online shoe shopping. The app is integrated with Firebase for authentication, database storage, and product management. It provides users with an intuitive shopping experience, secure checkout, and order tracking.

---



![15+ Screens (3)](https://github.com/user-attachments/assets/0849297d-73db-43eb-8882-3b56e85e6897)



---



## 📖 **Table of Contents**
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Screenshots](#screenshots)
- [How It Works](#how-it-works)
- [Firebase Configuration](#firebase-configuration)
- [Admin Panel](#admin-panel)
- [License](#license)



---



## 🎯 **Features**  
✔️ **30+** beautifully designed screens for a smooth and intuitive user journey.   
✔️ **User Authentication:** Sign in, sign up, and Google authentication.   
✔️ **Product Listings:** Users can browse and search for shoes.  
✔️ **Product Details:** Detailed view with images, descriptions, and pricing.  
✔️ **Cart & Checkout:** Users can add products to the cart and proceed to checkout.  
✔️ **Order Management:** Track order history and status.  
✔️ **Wishlist:** Save favorite products for later.  
✔️ **Admin Panel:** Add, update, and delete products.  
✔️ **Analytics Dashboard:** To track performance and sales insights.   
✔️ **Real-time Chats:** with Admin to assist users instantly.   
✔️ **Secure Payments:** Integration with payment gateways.  



  
---




## 💻 **Tech Stack**
- **Frontend:** Flutter (Dart)  
- **Backend:** Firebase (Firestore, Authentication, Storage)  
- **State Management:** Riverpod
- **Database:** Firestore (NoSQL)  
- **Authentication:** Firebase Auth  
- **Storage:** Firebase Storage (for product images)  




---




## 🛠 **Installation**  

1️⃣ **Clone the Repository**  
```bash
git clone https://github.com/your-github-username/sneakify.git
```
2️⃣ **Navigate to the Project Directory**  
```bash
cd sneakify
```
3️⃣ **Install Dependencies**  
```bash
flutter pub get
```
4️⃣ **Run the App**  
```bash
flutter run
```



---




## 📂 **Project Structure**
```
sneakify/
│── 📦 your-flutter-app-repo
├── 📂 lib
│   ├── 📂 const
│   ├── 📂 features
│   │   ├── 📂 admin
│   │   │   ├── 📂 admin_methods
│   │   │   ├── 📂 adminbottomnavigation
│   │   │   ├── 📂 analytics
│   │   │   ├── 📂 chat
│   │   │   ├── 📂 home
│   │   │   ├── 📂 order_detail
│   │   │   ├── 📂 orders
│   │   │   ├── 📂 profile
│   │   │   ├── 📜 upload_data.dart
│   │   ├── 📂 login
│   │   │   ├── 📂 logic
│   │   │   ├── 📂 model
│   │   │   ├── 📂 view
│   │   ├── 📂 Shared
│   │   │   │   ├── 📜 helperclass.dart
│   │   │   │   ├── 📜 sharedclass.dart
│   │   ├── 📂 user
│   │   │   ├── 📂 address
│   │   │   ├── 📂 bestseller
│   │   │   ├── 📂 bottomnavigation
│   │   │   ├── 📂 cart
│   │   │   ├── 📂 checkout
│   │   │   ├── 📂 editprofile
│   │   │   ├── 📂 favorite
│   │   │   ├── 📂 help_center
│   │   │   ├── 📂 home
│   │   │   ├── 📂 home_detail
│   │   │   ├── 📂 leave_review
│   │   │   ├── 📂 my_order
│   │   │   ├── 📂 notification
│   │   │   ├── 📂 onboarding
│   │   │   ├── 📂 order
│   │   │   ├── 📂 profile
│   │   │   ├── 📂 review
│   │   │   ├── 📂 search
│   │   │   ├── 📂 setting
│   │   │   ├── 📜 upload_data.dart
├── 📂 theme
├── 📂 utils
├── 📜 firebase_options.dart
├── 📜 main.dart
└── 📜 README.md
│── assets/
│── pubspec.yaml
│── README.md
```


### 📂 **Main Folder Breakdown**
- lib/ → Main application codebase, including features, UI, and logic.
- theme/ → Defines app-wide styling, colors, and fonts.
- utils/ → Contains utility functions and helper classes.
- assets/ → Stores static resources like images, icons, and fonts.
- firebase_options.dart → Firebase configuration settings.
- main.dart → Entry point of the Flutter application.
- pubspec.yaml → Defines dependencies, assets, and app configurations.
- README.md → Project documentation file.



---




## 📸 **Screenshots**
> Add screenshots of your application for better visibility.  
> ![Screenshot 2025-02-08 111748-Photoroom](https://github.com/user-attachments/assets/d50019ae-d4fa-4d75-a642-22dc848def9a)  ![Screenshot 2025-02-08 111813-Photoroom](https://github.com/user-attachments/assets/e8682a85-8d93-4b54-bde9-260980515cb8)
> <img src="asset/images/S.png" width="350" height="500">




---




## ⚙️ **How It Works**
### 1️⃣ User Authentication  
- Users can **sign up** using email and password.  
- **Google sign-in** is available for quick access.  
- Firebase Authentication handles login and logout securely.  

### 2️⃣ Browsing & Searching Products  
- Users can browse through a **list of shoes**.  
- Advanced search allows finding specific products.  

### 3️⃣ Adding to Cart & Wishlist  
- Users can **add products to the cart** and view total pricing.  
- Favorite products can be saved to the **wishlist** for later purchases.  

### 4️⃣ Secure Checkout & Orders  
- Users can **place orders** and view **order history**.  
- Orders are stored in Firebase Firestore.  




---




## 🔥 **Firebase Configuration**
1️⃣ Create a **Firebase Project**  
2️⃣ Add an **Android & iOS App**  
3️⃣ Download the **google-services.json** file and place it inside:  
```
android/app/
```
4️⃣ Enable **Authentication** (Email/Google)  
5️⃣ Set up **Firestore Database** with a collection for **products, users, and orders**  
6️⃣ Enable **Firebase Storage** for product images  




---




## 🛠 **Admin Panel**
- Admins can **add, edit, and delete products**.  
- Order management for processing user purchases.  
- **Secure access** to admin features.
- **Analytics dashboard** to track performance and sales insights. 




---




## 📜 **License**
This project is licensed under the **MIT License**.




---



## 🧑 **Author**
**Faizan Ahmed**  
🔗 **LinkedIn:** [Your LinkedIn Profile](https://www.linkedin.com/in/faizan-ahmed-303793255/)  




---




### ⭐ **Support & Follow**
If you liked this repo, please **support it by giving a star ⭐!**  
Also, follow my **GitHub profile** to stay updated about my latest projects:  
🔗 **GitHub:** [Your GitHub Profile](https://github.com/FaizanAhmed44)



---
