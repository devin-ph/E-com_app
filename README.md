# TH4 - G3C3 — E-Commerce App

Ứng dụng sàn thương mại điện tử xây dựng bằng Flutter

---

## Cấu trúc thư mục

```
lib/
├── main.dart                      ← Cấu hình app, injection Provider, routes
│
├── models/                        ← Data models
│   ├── product.dart
│   ├── cart_item.dart
│   ├── order.dart
│   └── category.dart
│
├── providers/                     ← State Management
│   ├── cart_provider.dart
│   ├── product_provider.dart
│   └── order_provider.dart
│
├── services/                      ← API & Storage
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
    ├── home/                      ← LÊ TIẾN MINH
    │   ├── home_screen.dart
    │   └── widgets/
    │       ├── banner_carousel.dart
    │       ├── category_row.dart
    │       └── product_grid.dart
    │
    ├── product_detail/            ← ĐINH PHƯƠNG LY
    │   ├── product_detail_screen.dart
    │   └── widgets/
    │       └── add_to_cart_bottom_sheet.dart
    │
    ├── cart/                      ← TRẦN QUANG QUÂN
    │   └── cart_screen.dart
    │
    ├── checkout/                  ← PHẠM NGỌC MINH NAM
    │   └── checkout_screen.dart
    │
    └── orders/                    ← PHẠM NGỌC MINH NAM
        └── orders_screen.dart
```

---

## Phân công nhiệm vụ

| Thành viên | Phụ trách                          | File được chỉnh                        |
|---|---|---|
| Lê Tiến Minh | Home Screen                    | `screens/home/**`                      |
| Đinh Phương Ly | Product Detail Screen          | `screens/product_detail/**`            |
| Trần Quang Quân | Cart Screen                    | `screens/cart/**`                      |
| Phạm Ngọc Minh Nam | Checkout + Orders Screen       | `screens/checkout/**`, `screens/orders/**` |

## Tính năng

| Màn hình | Tính năng |
|---|---|
| **Trang chủ** | SliverAppBar sticky, Search bar, Banner carousel tự động, Danh mục, Product grid infinite scroll, Pull-to-refresh, Hero animation |
| **Chi tiết sản phẩm** | Image slider, Giá gốc/giảm giá, Phân loại (size/màu), Mô tả xem thêm/thu gọn, BottomSheet thêm giỏ hàng |
| **Giỏ hàng** | Checkbox chọn/bỏ chọn, Chọn tất cả, Tổng tiền realtime, +/- số lượng, Swipe xóa, Dismissible |
| **Thanh toán** | Form địa chỉ, Chọn phương thức (COD/MoMo/Banking), Xác nhận đặt hàng, Dialog thành công |
| **Đơn mua** | TabBar 4 trạng thái (Chờ xác nhận/Đang giao/Đã giao/Đã hủy), Danh sách đơn hàng |

## Chạy dự án

```bash
git clone https://github.com/devin-ph/E-com_app.git
cd E-com_app
flutter pub get
flutter run
```