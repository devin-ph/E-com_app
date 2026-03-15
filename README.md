# TH4 - Nhóm 1 — Mini E-Commerce App

Ứng dụng bán hàng Flutter, sử dụng **Provider** cho State Management và **FakeStore API** làm nguồn dữ liệu.

---

## Cấu trúc thư mục (cho phép thành viên làm việc song song, không conflict)

```
lib/
├── main.dart                      ← Cấu hình app, injection Provider, routes
│
├── models/                        ← Data models (không ai chỉnh sửa tùy tiện)
│   ├── product.dart
│   ├── cart_item.dart
│   ├── order.dart
│   └── category.dart
│
├── providers/                     ← State Management (không ai chỉnh sửa tùy tiện)
│   ├── cart_provider.dart
│   ├── product_provider.dart
│   └── order_provider.dart
│
├── services/                      ← API & Storage (không ai chỉnh sửa tùy tiện)
│   ├── api_service.dart
│   └── storage_service.dart
│
├── widgets/                       ← Shared widgets dùng nhiều màn hình
│   ├── product_card.dart
│   ├── cart_icon_button.dart
│   └── product_grid_shimmer.dart
│
├── utils/
│   └── formatters.dart
│
└── screens/
    ├── home/                      ← THÀNH VIÊN 1 phụ trách
    │   ├── home_screen.dart
    │   └── widgets/
    │       ├── banner_carousel.dart
    │       ├── category_row.dart
    │       └── product_grid.dart
    │
    ├── product_detail/            ← THÀNH VIÊN 2 phụ trách
    │   ├── product_detail_screen.dart
    │   └── widgets/
    │       └── add_to_cart_bottom_sheet.dart
    │
    ├── cart/                      ← THÀNH VIÊN 3 phụ trách
    │   └── cart_screen.dart
    │
    ├── checkout/                  ← THÀNH VIÊN 4 phụ trách
    │   └── checkout_screen.dart
    │
    └── orders/                    ← THÀNH VIÊN 4 phụ trách
        └── orders_screen.dart
```

---

## Quy tắc làm việc nhóm (tránh conflict)

| Thành viên | Phụ trách                          | File được chỉnh                        |
|---|---|---|
| Thành viên 1 | Home Screen                    | `screens/home/**`                      |
| Thành viên 2 | Product Detail Screen          | `screens/product_detail/**`            |
| Thành viên 3 | Cart Screen                    | `screens/cart/**`                      |
| Thành viên 4 | Checkout + Orders Screen       | `screens/checkout/**`, `screens/orders/**` |

- **Chỉ sửa file trong thư mục được phân công.** Không được sửa `models/`, `providers/`, `services/` mà không thảo luận với cả nhóm.
- Nếu cần thêm widget **dùng chung**, tạo pull request riêng và tag toàn nhóm review.
- `main.dart` chỉ được sửa khi thêm route mới — cần merge request rõ ràng.

---

## Tính năng

| Màn hình | Tính năng |
|---|---|
| **Trang chủ** | SliverAppBar sticky, Search bar, Banner carousel tự động, Danh mục, Product grid infinite scroll, Pull-to-refresh, Hero animation |
| **Chi tiết sản phẩm** | Image slider, Giá gốc/giảm giá, Phân loại (size/màu), Mô tả xem thêm/thu gọn, BottomSheet thêm giỏ hàng |
| **Giỏ hàng** | Checkbox chọn/bỏ chọn, Chọn tất cả, Tổng tiền realtime, +/- số lượng, Swipe xóa, Dismissible |
| **Thanh toán** | Form địa chỉ, Chọn phương thức (COD/MoMo/Banking), Xác nhận đặt hàng, Dialog thành công |
| **Đơn mua** | TabBar 4 trạng thái (Chờ xác nhận/Đang giao/Đã giao/Đã hủy), Danh sách đơn hàng |

## State Management

- **Provider** pattern
- `CartProvider`: Quản lý toàn bộ giỏ hàng, persist xuống `SharedPreferences`
- `ProductProvider`: Fetch + pagination sản phẩm từ FakeStore API
- `OrderProvider`: Lưu lịch sử đơn hàng (local)

## Chạy dự án

```bash
flutter pub get
flutter run
```

Nguồn dữ liệu: [FakeStore API](https://fakestoreapi.com)


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
