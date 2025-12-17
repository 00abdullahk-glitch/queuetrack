# semesterproject

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Universal queue feature

This project now includes a simple universal queue flow:

- Users can generate a numeric token (top-right > Universal Queue) via `/uqueue`.
- Tokens are created with an incrementing number stored in Firestore (`meta/queue.nextNumber`).
- Shop owner can login (hard-coded credentials in `OwnerLogin`) and manage the queue (call next / finish) via `/owner/dashboard`.
- Notifications: in-app SnackBars inform users when their token is called or finished.

Notes:
- This is intentionally minimal/simple to serve as a starting point. Security and production-ready features (owner auth, push notifications, rate limiting) are left as future improvements.

